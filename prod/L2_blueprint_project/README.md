# ESLZ (Enterprise Scale Landing Zone) project blueprint

## Description

This level 2 blueprint will deploy the project  resources needed.

The following resources will be deployed by this blueprint:

1. Project resource group
2. Azure Active Directory group members for the project
3. NSG (Network Security Group) for MAZ, PAZ, OZ and RZ
4. Project storage account
5. Demo linux management VM

## Deployment

1. Launch the development workspace in a container following the instructions found at: https://github.com/Azure/caf-terraform-landingzones/blob/master/documentation/getting_started/getting_started.md

2. If not already logged-in:

```
rover login
```

3. Configure the <envname>.tfvars file in the `environments` folder with the desired values. See the [README.md](./environments/README.md) file in the folder for more information.

4. Deploy the desired Landing Zone environment resources. For example, to manually deploy the `dev` environment use the following commands:

```sh
cd /tf/caf/L2_blueprint_project
gorover dev apply
```

To deploy the same thing but using a CI/CD pipeline on github use the following commands:

```sh
cd /tf/caf/L2_blueprint_project
runactions dev apply
```

Then check you github repo actions logs to look at the terraform deployment run.

5. If you need to ever interact directly with the statefile for a given blueprint simply do it as follow:

```sh
cd /tf/caf/L2_blueprint_project
goterraform <env> <command(s)>

eg: goterraform dev state list
```
