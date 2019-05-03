#!/bin/bash
# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

kubectl create secret generic ocicredentials \
--from-literal=tenancy=${tenancy_ocid} \
--from-literal=user=${user_ocid} \
--from-literal=fingerprint=${api_fingerprint} \
--from-literal=region=${region} \
--from-literal=passphrase=${api_passphrase} \
--from-file=privatekey=${api_key_path}