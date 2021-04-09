# How to deploy the bootstrap

1. Edit the config.yaml file at the root of the environment folder making sure to set the subscription_id under the common section to the id of the subscription you are planning to deploy the ESLZ to. Adjust anu other variables as needed.

2. Run the bootstrap with:

```bash
/tf/caf/scripts/bootstrap.sh
```

Once bootstrapped use the standard terragrunt commands to manage blueprint.