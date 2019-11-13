# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_security_list" "admin" {
  compartment_id = var.oci_admin_identity.compartment_id
  display_name   = "${var.oci_admin_general.label_prefix}-admin"
  vcn_id         = var.oci_admin_network.vcn_id

  egress_security_rules {
    protocol    = local.all_protocols
    destination = local.anywhere
  }

  ingress_security_rules {
    # allow ssh
    protocol = local.tcp_protocol
    
    source = var.oci_admin_network.vcn_cidr

    tcp_options {
      min = local.ssh_port
      max = local.ssh_port
    }
  }
  count = var.oci_admin.create_admin == true ? 1 : 0
}