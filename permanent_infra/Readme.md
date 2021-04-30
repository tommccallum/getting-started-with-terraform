# Permanent Infrastructure

A IaC project tends to require some permanent infrastructure like an initial Cloud Object Storage and a Vault for secrets.  Here we create these and then make them available to the more dynamic infrastructure which is the main part of our project.

If an cloud object storage does not exist for a real project then this is a demo of how you could set one up.  We need to separate it into a new directory so the terraform script will not try and build it everytime.