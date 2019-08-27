# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_containerengine_cluster" "k8s_cluster" {
  compartment_id     = var.oke_identity.compartment_ocid
  kubernetes_version = local.kubernetes_version
  name               = "${var.oke_general.label_prefix}-${var.oke_cluster.cluster_name}"

  options {
    add_ons {
      is_kubernetes_dashboard_enabled = var.oke_cluster.cluster_options_add_ons_is_kubernetes_dashboard_enabled
      is_tiller_enabled               = var.oke_cluster.cluster_options_add_ons_is_tiller_enabled
    }

    kubernetes_network_config {
      pods_cidr     = var.oke_cluster.cluster_options_kubernetes_network_config_pods_cidr
      services_cidr = var.oke_cluster.cluster_options_kubernetes_network_config_services_cidr
    }

    service_lb_subnet_ids = length(var.oke_general.ad_names) == 1 ? [var.oke_cluster.cluster_subnets[element(local.lb_ads, 0)]] : [var.oke_cluster.cluster_subnets[element(local.lb_ads, 0)], var.oke_cluster.cluster_subnets[element(local.lb_ads, 1)]]
  }

  vcn_id = var.oke_cluster.vcn_id
}
