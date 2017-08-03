#!/bin/bash -eu
c6="$(ls -1rt centos6*.box | tail -1)"
c7="$(ls -1rt centos7*.box | tail -1)"

vagrant box add "${c6}" --name centos6-vmware-tools --force
vagrant box add "${c7}" --name centos7-vmware-tools --force
