
/*
Ref: 1.1
Calling a child module and passing variable named server
*/

module "servers" {
  source = "./app-cluster"
  version = "1.0.0"
  servers = 5
}
