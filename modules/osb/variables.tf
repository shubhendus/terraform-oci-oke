# Copyright 2017, 2019 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# identity
variable "api_fingerprint" {}

variable "api_passphrase" {
  default = ""
}
variable "api_private_key_path" {}

variable "tenancy_ocid" {}

variable "user_ocid" {}

# ssh keys
variable "ssh_private_key_path" {}

# general oci

variable "label_prefix" {}

variable "region" {}


# bastion
variable "bastion_public_ip" {}

variable "create_bastion" {}

variable "image_operating_system" {}

# oci service broker
variable "create_oci_service_broker" {}

variable "service_catalog_version" {}

variable "helm_oci_service_broker_release_name" {}

variable "oci_service_broker_version" {}

variable "oci_service_broker_secret_name" {}

variable "oci_service_broker_replicas" {}

variable "oci_service_broker_service_name" {}

variable "oci_service_broker_etcd_embedded" {}

variable "oci_service_broker_servers" {
  default = ""
}

variable "oci_service_broker_storage_tls_enabled" {}

variable "oci_service_broker_client_cert_secret_name" {}

variable "oci_service_broker_tls_enabled" {}

variable "oci_service_broker_tls_secret_name" {}