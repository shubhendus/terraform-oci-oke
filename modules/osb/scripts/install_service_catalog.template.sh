#!/bin/bash
# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

helm repo add ${repo_name} ${helm_repo_url}

helm install ${repo_name}/${chart} --set controllerManager.verbosity="4" --timeout 300 --name ${name} --version ${catalog_version}