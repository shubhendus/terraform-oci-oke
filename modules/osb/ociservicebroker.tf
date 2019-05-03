# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

data "template_file" "create_oci_credentials_secret" {
  template = "${file("${path.module}/scripts/create_oci_credentials_secret.template.sh")}"

  vars = {
    tenancy_ocid    = "${var.tenancy_ocid}"
    user_ocid       = "${var.user_ocid}"
    api_fingerprint = "${var.api_fingerprint}"
    region          = "${var.region}"
    api_passphrase  = "${var.api_passphrase}"
    api_key_path    = "${var.image_operating_system == "Canonical Ubuntu"   ? "/home/ubuntu/oci_rsa.pem" : "/home/opc/oci_rsa.pem"}"
  }

  count = "${(var.create_bastion == true && var.create_oci_service_broker == true)   ? 1 : 0}"
}

data "template_file" "api_key" {
  template = "${file(var.api_private_key_path)}"
  count    = "${(var.create_bastion == true && var.create_oci_service_broker == true)   ? 1 : 0}"
}

data "template_file" "install_oci_service_broker" {
  template = "${file("${path.module}/scripts/install_osb.template.sh")}"

  vars = {
    helm_oci_service_broker_release_name       = "${var.helm_oci_service_broker_release_name}"
    oci_service_broker_version                 = "${var.oci_service_broker_version}"
    oci_service_broker_secret_name             = "${var.oci_service_broker_secret_name}"
    oci_service_broker_replicas                = "${var.oci_service_broker_replicas}"
    oci_service_broker_service_name            = "${var.oci_service_broker_service_name}"
    oci_service_broker_etcd_embedded           = "${var.oci_service_broker_etcd_embedded}"
    oci_service_broker_servers                 = "${var.oci_service_broker_servers}"
    oci_service_broker_storage_tls_enabled     = "${var.oci_service_broker_storage_tls_enabled}"
    oci_service_broker_client_cert_secret_name = "${var.oci_service_broker_client_cert_secret_name}"
    oci_service_broker_tls_enabled             = "${var.oci_service_broker_tls_enabled}"
    oci_service_broker_tls_secret_name         = "${var.oci_service_broker_tls_secret_name}"
  }

  count = "${(var.create_bastion == true && var.create_oci_service_broker == true)   ? 1 : 0}"
}

resource null_resource "create_oci_credentials_secret" {
  connection {
    host        = "${var.bastion_public_ip}"
    private_key = "${file(var.ssh_private_key_path)}"
    timeout     = "40m"
    type        = "ssh"
    user        = "${var.image_operating_system == "Canonical Ubuntu"   ? "ubuntu" : "opc"}"
  }

  provisioner "file" {
    content     = "${data.template_file.api_key.rendered}"
    destination = "${var.image_operating_system == "Canonical Ubuntu"   ? "/home/ubuntu/oci_rsa.pem" : "/home/opc/oci_rsa.pem"}"
  }

  provisioner "file" {
    content     = "${data.template_file.create_oci_credentials_secret.rendered}"
    destination = "~/create_oci_credentials.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/create_oci_credentials.sh",
      "$HOME/create_oci_credentials.sh",
      "rm -f $HOME/create_oci_credentials.sh",
      "rm -f $HOME/oci_rsa.pem"
    ]
  }

  count = "${(var.create_bastion == true  && var.create_oci_service_broker == true)   ? 1 : 0}"
}

resource null_resource "install_oci_service_broker" {
  connection {
    host        = "${var.bastion_public_ip}"
    private_key = "${file(var.ssh_private_key_path)}"
    timeout     = "40m"
    type        = "ssh"
    user        = "${var.image_operating_system == "Canonical Ubuntu"   ? "ubuntu" : "opc"}"
  }

  depends_on = ["null_resource.install_service_catalog"]

  provisioner "file" {
    content     = "${data.template_file.install_oci_service_broker.rendered}"
    destination = "~/install_oci_service_broker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/install_oci_service_broker.sh",
     "$HOME/install_oci_service_broker.sh",
    ]
  }

  count = "${(var.create_bastion == true  && var.create_oci_service_broker == true)   ? 1 : 0}"
}
