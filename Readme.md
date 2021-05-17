# Using Terraform with IBM Cloud

Why use Terraform?  To automate creating infrastructure on a Cloud provider.  Terraform can "hook" into application deployment tools such as Helm and many others, but Terraform focuses on the services.  In the general case Terraform can work out the dependencies between services, but sometimes it does need help via the [depends_on](https://www.terraform.io/docs/language/meta-arguments/depends_on.html) feature.

## Getting Started

**Watch out for the Terraform version restrictions, make sure you pick an appropriate version that works with the Cloud provider you are using**

* Download the Terraform application by following the instructions [here](https://cloud.ibm.com/docs/ibm-cloud-provider-for-terraform?topic=ibm-cloud-provider-for-terraform-setup_cli). (There is no need to install the IBM Cloud Provider plugin, if you are using the newer Terraform package.)

## Layout

* ```first.tf``` is run if there is no Cloud Object Storage (COS) area to keep the terraform state in.  This can be done locally but if you are working in teams you will to share the terraform *.tfstate files.
* ```main.tf``` is the file that will be run to create//destroy your infrastructure.
* ```version.tf``` gives terraform the initial provider information.
* ```.env``` keep your secrets in here.  **NEVER UPLOAD THIS FILE TO GIT SERVICE**  An alternative is to use a vault provider like Hashicorp.
* ```terraform.tfvars``` assign default values to variables
* ```variables.tf``` global variable declarations

## Starting up...

Copy the .env.template to .env in the root directory of the system.  There is no need to do this for subdirectories as the build.sh script will do this for you.

In the root directory of the repository run the build script which merges the environment variables in with the *.tf.template files in each subdirectory.  This is a custom script to overcome a limited with terraform blocks.

```
./build.sh
```

Initialise your terraform environment, use this command whenever you edit your terraform files.

```
cd iac_demo_1
terraform init
```

If succesful, type:

```
terraform plan
terraform apply
```

## Tips

* Keep infrastructure build code in a separate repository from your application code repository.
* Keep secrets secret.
* Get something working without variables and then split out into modules and variables.
* Remember when creating credentials for the Cloud Object Storage to store your terraform state you click on "Advanced options" and set HMAC to TRUE.
* If you really can't figure out what is going wrong, delete the .terraform directory and rerun ```terraform init```.
* Remember to use ```data``` blocks to get information about a service and ```resource``` blocks to create new resources.  If you create a resource and want to get information you need both a ```data``` and a ```resource``` block.

## Constraints

Cloud object storage buckets on Cloud Foundry must have a unique name across the whole Cloud Object Storage system.  There is also a delay in cleaning up bucket names.  This means that if you destroy a Cloud Storage bucket you cannot immediately recreate this.  For this reason we use a random number generator to create a prefix that, we hope, will be unique when we start the permanent infrastructure.

## Recommended Reading

* [O'Reilly's Terraform Up and Running](https://www.amazon.co.uk/Terraform-Running-Writing-Infrastructure-Code/dp/1492046906/ref=asc_df_1492046906/)
* 
## References

* [https://cloud.ibm.com/docs/ibm-cloud-provider-for-terraform?topic=ibm-cloud-provider-for-terraform-getting-started](https://cloud.ibm.com/docs/ibm-cloud-provider-for-terraform?topic=ibm-cloud-provider-for-terraform-getting-started)
* [https://registry.terraform.io/](https://registry.terraform.io/)
* [https://registry.terraform.io/providers/IBM-Cloud/ibm/latest](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest)
* [https://www.ibm.com/cloud/blog/store-terraform-states-cloud-object-storage](https://www.ibm.com/cloud/blog/store-terraform-states-cloud-object-storage)