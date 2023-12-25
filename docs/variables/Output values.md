# Output Values

Output values make information about your infrastructure available on the command line, and can expose information for other Terraform configurations to use. Output values are similar to return values in programming languages

## Use cases of Output Values

- A child module can use outputs to expose a subset of its resource attributes to a parent module.
- A root module can use outputs to print certain values in the CLI output after running terraform apply.

## Declaring an Output Value

```
output "instance_ip_addr" {
  value = aws_instance.server.private_ip
}
```

The value argument takes an expression whose result is to be returned to the user

## Accessing module output

From parent module, output of child modules can be accessed using `module.<MODULE NAME>.<OUTPUT NAME>` 

### Custom Condition Checks

You can use precondition blocks to specify guarantees about output data. The following examples creates a precondition that checks whether the EC2 instance has an encrypted root volume.


```
output "api_base_url" {
  value = "https://${aws_instance.example.private_dns}:8433/"

  # The EC2 instance must have an encrypted root volume.
  precondition {
    condition     = data.aws_ebs_volume.example.encrypted
    error_message = "The server's root volume is not encrypted."
  }
}
```

### Output Value Optional Arguments

`description`

briefly describe the purpose of each value using the optional description argument

```
output "instance_ip_addr" {
  value       = aws_instance.server.private_ip
  description = "The private IP address of the main server instance."
}
```

`sensitive`

An output can be marked as containing sensitive material using the optional sensitive argument

```
output "db_password" {
  value       = aws_db_instance.db.password
  description = "The password for logging in to the database."
  sensitive   = true
}
```
