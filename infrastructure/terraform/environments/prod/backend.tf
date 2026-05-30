terraform {
  backend "gcs" {
    bucket  = "xynapse-terraform-state-2026" 
    prefix  = "terraform/state"            
  }
}