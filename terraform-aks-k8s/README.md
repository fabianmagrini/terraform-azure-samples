# Create a Kubernetes cluster with Azure Kubernetes Service and Terraform

References:

* <https://docs.microsoft.com/en-us/azure/terraform/terraform-create-k8s-cluster-with-tf-and-aks>
* <https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure>
* <https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli>

## Getting Started

```sh
mkdir terraform-aks-k8s && cd terraform-aks-k8s
```

If you have multiple Azure subscriptions, first query your account with az account list to get a list of subscription ID and tenant ID values:

```sh
az account list --query "[].{name:name, subscriptionId:id, tenantId:tenantId}"
```

To use a selected subscription, set the subscription for this session with az account set. Set the SUBSCRIPTION_ID environment variable to hold the value of the returned id field from the subscription you want to use:

```sh
az account set --subscription="${SUBSCRIPTION_ID}"
```

Now you can create a service principal for use with Terraform. Use az ad sp create-for-rbac, and set the scope to your subscription as follows:

```sh
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"
```

Your appId, password, sp_name, and tenant are returned. Make a note of the appId and password.

Export your service principal credentials. Replace the \<your-client-id\> and \<your-client-secret\> placeholders with the appId and password values associated with your service principal, respectively.

```sh
export TF_VAR_client_id=<your-client-id>
export TF_VAR_client_secret=<your-client-secret>
```

## Initialse the working directory

```sh
cd <working-directory>
terraform init
```

## Deploy the configuration

Run terraform plan to test the new Terraform configuration

```sh
terraform plan --out out.plan
```

Apply the configuration

```sh
terraform apply out.plan
```

## Clean up resources

```sh
terraform destroy -auto-approve
```
