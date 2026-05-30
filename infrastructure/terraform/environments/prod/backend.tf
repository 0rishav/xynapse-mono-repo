terraform {
  backend "gcs" {
    bucket  = "xynapse-terraform-state" 
    prefix  = "terraform/state"        
  }
}