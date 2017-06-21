#!/bin/bash -eux

# Update all packages and reboot
yum -y update
reboot

# Sleep to avoid Packer starting the next script
sleep 10
