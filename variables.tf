variable "rg1-name" {
    type = string
    
    #default = "RG-Group-01"

}



variable "location" {
    type = string
    description = "Azure location of terraform server environment"
    #default = "westus2"

}



variable "replicationtype" {
    type = string
    #default = "GRS"

}


variable "accounttier" {
    type = string
    #default = "Standard"

}