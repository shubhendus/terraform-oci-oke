provider "helm" {
  kubernetes {
    config_path = "${path.root}/generated/kubeconfig"
  }
}

# data "helm_repository" "svc-catalog" {
#   name = "svc-catalog"
#   url  = "https://svc-catalog-charts.storage.googleapis.com"
# }