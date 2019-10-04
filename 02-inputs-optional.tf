variable "rg_location" {
  description                       = "Location to build all the resources in"
  default                           = "UK South"
}

variable "tags" {
  description                             = "The tags to associate with your resources."
  type                                    = "map"
  default                                 = {
      Team                                = "Reform-DevOps"
  }
}