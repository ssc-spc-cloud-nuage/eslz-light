set -e

if [[ ! -f "./backend.azurerm.tf" ]]; then
  terragrunt apply -var-file=deploy.tfvars

  echo "Moving launchpad to the cloud"

  export tenant_id=$(terragrunt output -raw tenant_id) && echo " - tenant_id: ${tenant_id}"
  export subscription_id=$(terragrunt output -raw subscription_id) && echo " - subscription_id: ${subscription_id}"
  export storage_account_name=$(terragrunt output -raw storage_account_name) && echo " - storage_account_name: ${storage_account_name}"
  export resource_group_name=$(terragrunt output -raw resource_group_name) && echo " - resource_group: ${resource_group_name}"
  export access_key=$(terragrunt output -raw storage_account_access_key) && echo " - storage_key: retrieved"

  terragrunt state pull > /tmp/terraform.tfstate

  az storage blob upload -f /tmp/terraform.tfstate \
          --container-name "statefiles" \
          --name "L0_blueprint_bootstrap/terraform.tfstate" \
          --auth-mode key \
          --account-key ${access_key} \
          --account-name ${storage_account_name} \
          --no-progress

  RETURN_CODE=$?
  if [ $RETURN_CODE != 0 ]; then
      error ${LINENO} "Error uploading the blob storage" $RETURN_CODE
  else    
    echo "terraform {" > backend.azurerm.tf
    echo "  backend \"azurerm\" {" >> backend.azurerm.tf
    echo "    resource_group_name=\"${resource_group_name}\"" >> backend.azurerm.tf
    echo "    storage_account_name=\"${storage_account_name}\"" >> backend.azurerm.tf
    echo "    container_name=\"statefiles\"" >> backend.azurerm.tf
    echo "    key=\"L0_blueprint_bootstrap/terraform.tfstate\"" >> backend.azurerm.tf
    echo "  }" >> backend.azurerm.tf
    echo "}" >> backend.azurerm.tf

    # rm terragrunt.tfs*

    echo "INFO - generating remote state configuration ../env.yaml"
    cat << EOF > ../env.yaml
remote_state:
  tenant_id: "${tenant_id}"
  subscription_id: "${subscription_id}"
  resource_group_name: ${resource_group_name}
  storage_account_name: ${storage_account_name}
  container_name: statefiles

EOF
    echo "INFO - Do not forget to check-in ../env.yaml to source code management"

  fi
else
  terragrunt apply -var-file=deploy.tfvars
fi
