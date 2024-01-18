locals {
  list1 = [1, 2, 3]
  list2 = [4, 5, 6]
}

output "list_length" {
  value = length(local.list1)
}

output "element_at_index" {
  value = element(local.list1, 1)
}

output "concatenated_list" {
  value = concat(local.list1, local.list2)
}

output "flattened_list" {
  value = flatten([local.list1, local.list2])
}
