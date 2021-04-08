# ESLZ (Enterprise Scale Landing Zone) Client Template

## Background

This blueprint is a custom implementation of the "Azure Cloud Adoption Framework landing zones for Terraform" found at the following URL: https://github.com/Azure/caf-terraform-landingzones

This landinzone solution follows the [GC Naming and Tagging Standard for Azure](https://bernardmaltais.github.io/GC_Naming_and_Tagging/index.html).

In summary the concept of the Landingzone is similar to how you would build presence on a remote planet (the cloud).

1st, you would use some sort of [rover](https://github.com/aztfmod/rover) to build a [launchpad](https://github.com/aztfmod/level0/tree/master/launchpads/launchpad_opensource_light) from which you would control activity on the remote planet (L0_blueprint_launchpad).

Next, using the [rover](https://github.com/aztfmod/rover) on the launchpad you would build a base from which to operate. (L1_blueprint_base).

Finally, from this base, you can then start to work on various project and missions. (L2_blueprint_project).

To communicate with earth (ground) from the landinzone base you need to relay communications through a spaceport (Shared VDC). The spaceport is the only way communication from the base with earth can be established. The spaceport is built by a central authority that oversee and ensure all communication flow security. The L1_blueprint_spaceport is not part of this client project.

All those blueprints use [resources](https://www.terraform.io/docs/providers/azurerm/r/availability_set.html) found on the planet and/or pre-built [modules](https://github.com/canada-ca-terraform-modules/terraform-azurerm-active-directory-v2) to create the assembly.

So here you have it. A L0 blueprint is 1st deployed, then the L1 blueprint and finally the L2 blueprint. There is a structured dependancies between them all to successfully complete projects/missions outcome on the remote planet ;-)

## Prerequisites

In order to start deploying your with CAF landing zones, you need admin rights on your development machine and the following components installed on it:

- [Visual Studio Code](https://code.visualstudio.com/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Git](https://git-scm.com/)

You can deploy it easily on Windows and MacOS with the following software managers:

| MacOS                                              | Windows                                                       |
| -------------------------------------------------- | ------------------------------------------------------------- |
| ```brew cask install visual-studio-code docker ``` | Install Chocolatey (https://chocolatey.org/docs/installation) |
| ```brew install git ```                            | ```choco install git vscode docker-desktop ```               |

Once installed, open **Visual Studio Code** and install "**Remote Development**" extension

## Deployment

Follow the README.md documentation in:

0. [envvars](./envvars/README.md)
1. [L0_blueprint_launchpad](./L0_blueprint_launchpad/README.md)
2. [L1_blueprint_base](./L1_blueprint_base/README.md)
3. [L2_blueprint_project](./L2_blueprint_project/README.md)

If all went well you will now have deployed the landinzone in the subscription.

## Pipeline

This template comes with an Azure DevOps pipeline that can be use to `plan` and `apply` changes to all your environments.  To start using the pipeline:

1. [Create your environments](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environment) in the "Pipelines > Environments" section of your project.
2. [Add deployment approval policies](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass#approvals) to each environment.  This will require a reviewer to approve infrastructure changes.
2. [Create a variable group](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=classic) named `AzureCLI` in "Pipelines > Library".  It should include the following secrets:
```sh
ARM_CLIENT_ID     # User id of the service principal (SP)
ARM_CLIENT_SECRET # Password for the SP
ARM_TENANT_ID     # Tenant ID of the infrastructure
```
3. Update the top of `azure-pipelines.yaml` with your environment names:
```yaml
parameters:
- name: environments
  type: object
  default:
  - sandbox
  - dev
  - test
  - prod
  # etc.
```
4. Create a new pipeline in the "Pipelines" section of your project and select `azure-pipelines.yaml` as the source.
5. Add branch policies to your `main` branch by going to "Repo > Branches" and selecting "Branch policies" from the "More..." actions menu of the branch:
    - [Limit merge types](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops#limit-merge-types): only allow `Merge` and `Squash`.  This allows the pipeline to properly identify changes after a merge.
    - [Build validation](https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops#build-validation): this will run a pipeline for any Pull Request that must pass before you can merge the change to `main`.  It also prevents pushing commits to `main` directly:
      - Select your pipeline
      - Trigger: Automatic
      - Policy requirement: Required
      - Build expiration: Immediately 

### Pipeline behaviour

- The pipeline has one Setup stage and a Plan + Apply stage for each environment.
- The Setup stage checks if there are any code or variable changes that need to be applied.
- For each environment:
  - if changes, run `rover ${ENV} plan` in a Plan stage.
  - if plan exists, run `rover ${ENV} apply` in an Apply stage.
- You can skip applying changes for a level folder (LN) and environment by creating a `.env` file in the LN's environments folder with `skip_${ENV}=true`:
```sh
# stop the pipeline from making any changes to the L1_blueprint_base folder in dev:
echo "skip_dev=true" >> L1_blueprint_base/environments/.env
```

## Rover command pipeline

You can create a manual pipeline to run rover commands against any environment and level folder with `.azuredevops/pipelines/rover-command.yaml`:

1. Update `rover-command.yaml` by adding your:
    - environments, 
    - level folder names, and
    - the commands you want to allow.
2. Create a new pipeline in the "Pipelines" section of your project and select `rover-command.yaml`.