#!/bin/bash
# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

git clone https://github.com/oracle/oci-service-broker.git osb
cd osb

helm install charts/oci-service-broker/.  --name ${helm_oci_service_broker_release_name} \
--version ${oci_service_broker_version} \
--set ociCredentials.secretName=${oci_service_broker_secret_name} \
--set replicaCount=${oci_service_broker_replicas} \
--set service.name=${oci_service_broker_service_name} \
--set storage.etcd.useEmbedded=${oci_service_broker_etcd_embedded} \
--set storage.etcd.servers=${oci_service_broker_servers} \
--set storage.etcd.tls.enabled=${oci_service_broker_storage_tls_enabled} \
--set storage.etcd.tls.clientCertSecretName=${oci_service_broker_client_cert_secret_name} \
--set tls.enabled=${oci_service_broker_tls_enabled} \
--set tls.secretName=${oci_service_broker_tls_secret_name}

kubectl create -f charts/oci-service-broker/samples/oci-service-broker.yaml
