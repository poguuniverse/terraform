
# Module

A module is a container for multiple resources that are used together.

Every Terraform configuration has at least one module, known as its root module, which consists of the resources defined in the .tf files in the main working directory.

## Calling a Child Module

To call a module means to include the contents of that module into the configuration with specific values for its input variables.

Refer `sample/3.module.tf - Ref: 1.1`

__Fields:__

`source` - path to local directory containing terraform configuration file or remote source to download from
`version` - recommended for module from registry

__Meta-Arguments__

`count` - multiple instance of modules from single module
`for_each` - multiple instance of modules from single module. Iterate over set or map to pass variable to the module
`providers` -  pass provider configuration to the module


## Module Source

The source argument in a module block tells Terraform where to find the source code for the desired child module.

- Local Paths
- Terraform Registry
- Github
- Bitbucket
- S3 Bucket
- GCS Bucket
- Modules in package sub-directories

### Local Paths

File Path location relative to `./` or `./..`. 

```
module <module-name> {
  source = "./<dir-name>"
}
```

### Terraform Registry

A module registry is the native way of distributing Terraform modules for use across multiple configurations, using a Terraform-specific protocol that has full support for module versioning.

```
module "consul" {
  source = "hashicorp/consul/aws"
  version = "0.1.0"
}
```

For modules hosted in other registries, prefix the source address with an additional <HOSTNAME>/ portion, giving the hostname of the private registry:

```
module "consul" {
  source = "app.terraform.io/example-corp/k8s-cluster/azurerm"
  version = "1.1.0"
}
```


### GitHub

Terraform will recognize unprefixed github.com URLs and interpret them automatically as Git repository sources.

```
module "consul" {
  source = "github.com/hashicorp/example"
}
```

### Generic Git Repository


```
module "vpc" {
  source = "git::https://example.com/vpc.git"
}

module "storage" {
  source = "git::ssh://username@example.com/storage.git"
}

```

___SSH PROTOCOL__

If SSH Protocol is used, any configured SSHKeys will be used. This is common way of accessing non-public access.

___HTTP PROTOCOL__

For protocol that uses username/password credentials, configure [Git Credentials Storage](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage) to select a suitable source of credentials for your environment.

___Selecting a Revision__

By default, Terraform will clone and use the default branch (referenced by HEAD) in the selected repository. You can override this using the ref argument

```
# select a specific tag
module "vpc" {
  source = "git::https://example.com/vpc.git?ref=v1.2.0"
}

# directly select a commit using its SHA-1 hash
module "storage" {
  source = "git::https://example.com/storage.git?ref=51d462976d84fdea54b47d80dcabbf680badcdb8"
}

```

### HTTP URLs

When you use an HTTP or HTTPS URL, Terraform will make a GET request to the given URL, which can return another source address.


If an HTTP/HTTPS URL requires authentication credentials, use a .netrc file to configure the credentials. By default, Terraform searches for the .netrc file in your HOME directory.
For information on the .netrc format, refer to [the documentation for using it in curl](https://everything.curl.dev/usingcurl/netrc).

### S3 Bucket

You can use archives stored in S3 as module sources using the special s3:: prefix, followed by an S3 bucket object URL.

```
module "consul" {
  source = "s3::https://s3-eu-west-1.amazonaws.com/examplecorp-terraform-modules/vpc.zip"
}
```

The AWS credentials should be accessible in the following locations

- The AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables.
- The default profile in the .aws/credentials file in your home directory.
- If running on an EC2 instance, temporary credentials associated with the instance's IAM Instance Profile.

### GCS Bukcet

You can archives stored in Google Cloud Storage as module sources using the special gcs:: prefix

```
module "consul" {
  source = "gcs::https://www.googleapis.com/storage/v1/modules/foomodule.zip"
}

```





