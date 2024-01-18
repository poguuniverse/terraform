locals {
  str1 = "Hello"
  str2 = "World"
}

output "formatted_string" {
  value = format("%s, %s!", local.str1, local.str2)
}

output "joined_string" {
  value = join(" ", [local.str1, local.str2])
}

output "lowercase_string" {
  value = lower(local.str1)
}

output "uppercase_string" {
  value = upper(local.str1)
}

output "substring" {
  value = substr(local.str1, 0, 3)
}
