# Terraform samples

Terraform samples for creating Azure infra

References:

* <https://docs.microsoft.com/en-us/azure/terraform/>
* <https://learn.hashicorp.com/collections/terraform/azure-get-started>

## Prerequisites

* Install terraform
* Azure CLI
* az login

### Logging into the Azure CLI

If you have multiple subscriptions then set subscription after completing the login.

```sh
az login
az account list
az account set --subscription="SUBSCRIPTION_ID"
```

## Initialse the working directory

```sh
cd <working-directory>
terraform init
```

## Deploy the configuration

Run terraform plan to test the new Terraform configuration

```sh
terraform plan --out plan.out
```

Apply the configuration

```sh
terraform apply plan.out
```

## Clean up resources

```sh
terraform destroy -auto-approve
```

## Appendix

Useful Azure CLI commands

### List subscriptions

```sh
az account list
```

You will find the subscriptionId and tenantId displayed.

### List Resource Groups

```sh
az group list
```

### List Resources

```sh
az resource list
az resource list --location australiaeast
az resource list --resource-group SuperfundLookupRG
```
