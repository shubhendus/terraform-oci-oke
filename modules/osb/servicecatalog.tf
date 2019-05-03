# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

data "template_file" "install_svcat" {
  template = "${file("${path.module}/scripts/install_svcat.template.sh")}"
  count    = "${(var.create_bastion == true && var.create_oci_service_broker == true)   ? 1 : 0}"
}

data "template_file" "install_service_catalog" {
  template = "${file("${path.module}/scripts/install_service_catalog.template.sh")}"

  vars = {
    chart          = "catalog"
    name           = "catalog"
    helm_repo_url  = "https://svc-catalog-charts.storage.googleapis.com"
    repo_name         = "svc-cat"
    catalog_version = "${var.service_catalog_version}"
  }

  count = "${(var.create_bastion == true && var.create_oci_service_broker == true)   ? 1 : 0}"
}

resource "null_resource" "install_svcat_bastion" {
  connection {
    host        = "${var.bastion_public_ip}"
    private_key = "${file(var.ssh_private_key_path)}"
    timeout     = "40m"
    type        = "ssh"
    user        = "${var.image_operating_system == "Canonical Ubuntu"   ? "ubuntu" : "opc"}"
  }

  provisioner "file" {
    content     = "${data.template_file.install_svcat.rendered}"
    destination = "~/install_svcat.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/install_svcat.sh",
      "bash $HOME/install_svcat.sh",
    ]
  }

  count = "${(var.create_bastion == true && var.create_oci_service_broker == true)   ? 1 : 0}"
}

resource "null_resource" "install_service_catalog" {
  connection {
    host        = "${var.bastion_public_ip}"
    private_key = "${file(var.ssh_private_key_path)}"
    timeout     = "40m"
    type        = "ssh"
    user        = "${var.image_operating_system == "Canonical Ubuntu"   ? "ubuntu" : "opc"}"
  }

  depends_on = ["null_resource.is_worker_active"]

  provisioner "file" {
    content     = "${data.template_file.install_service_catalog.rendered}"
    destination = "~/install_service_catalog.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/install_service_catalog.sh",
      "bash $HOME/install_service_catalog.sh",
    ]
  }

  count = "${(var.create_bastion == true && var.create_oci_service_broker == true)   ? 1 : 0}"
}
