# Common Errors

## Incompatible provider version

```

Initializing the backend...

Initializing provider plugins...
- Finding ibm-cloud/ibm versions matching "1.23.2"...
╷
│ Error: Incompatible provider version
│ 
│ Provider registry.terraform.io/ibm-cloud/ibm v1.23.2 does not have a package available for your current platform, linux_386.
│ 
│ Provider releases are separate from Terraform CLI releases, so not all providers are available for all platforms. Other versions of this provider may have different
│ platforms supported.
```

The solution is to carefully check your installed version against the version expected.  If it says 13+ then try the last version of 0.13.*.  You need to find a compatible version of Terraform, sometimes you have to go a couple of minor versions back.

## String interpolation is no longer done the obvious way

```
Warning: Interpolation-only expressions are deprecated

  on first.tf line 5, in data "ibm_resource_group" "cos_group":
   5:   name = "${TF_VAR_shared_resource_group}"
```

String interpolation is now using ```${var.XXX}``` where XXX is a input variable declared in the local file or a *.tfvars file.


## Access Key for Cloud Object Storage not recognised

```
Initializing the backend...
Backend configuration changed!

Terraform has detected that the configuration specified for the backend
has changed. Terraform will now check for existing state in the backends.



Error: Error loading state:
    InvalidAccessKeyId: The AWS Access Key ID you provided does not exist in our records.
        status code: 403, request id: b1ba0019-5593-40d7-abf4-9eb4d64daf24, host id: 

Terraform failed to load the default state from the "s3" backend.
State migration cannot occur unless the state can be loaded. Backend
modification and state migration has been aborted. The state in both the
source and the destination remain unmodified. Please resolve the
above error and try again.
```

You have used the wrong items for the access code and secret.  You need to click on Advanced Options and set HMAC to TRUE to generate these.

## Why is it coming up with AWS errors for IBM Cloud?

This is because they use the same api which was developed for AWS, you can ignore the name.

## Variables cannot be used in terraform blocks

```
Error: Variables not allowed

  on main.tf line 25, in terraform:
  25:         region                      = var.region

Variables may not be used here.
```

[This help page](https://www.terraform.io/docs/language/settings/index.html) states that variables cannot be used in a terraform block.
