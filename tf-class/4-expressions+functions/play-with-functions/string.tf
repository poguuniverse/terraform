locals {
  num1 = 10
  num2 = 5
}

output "addition_result" {
  value = local.num1 + local.num2
}

output "subtraction_result" {
  value = local.num1 - local.num2
}

output "multiplication_result" {
  value = local.num1 * local.num2
}

output "division_result" {
  value = local.num1 / local.num2
}

output "modulus_result" {
  value = local.num1 % local.num2
}
