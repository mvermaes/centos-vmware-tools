#!/bin/bash -eux

# Install the EPEL repository (CentOS 6 only)
major_version="`sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/redhat-release | awk -F. '{print $1}'`"
if [ "$major_version" -eq 6 ]; then
  yum -y install epel-release
fi

# Install the open source tools package
yum -y install open-vm-tools

# Install build dependencies
yum -y install perl gcc fuse make kernel-devel net-tools policycoreutils-python

# Mount the installer iso and extract it to /tmp
mkdir -p /tmp/vmware /tmp/vmware-archive
mount -o loop /home/vagrant/linux.iso /tmp/vmware
TOOLS_PATH="`ls /tmp/vmware/VMwareTools-*.tar.gz`"
tar xzf ${TOOLS_PATH} -C /tmp/vmware-archive

# Install VMware Tools
/tmp/vmware-archive/vmware-tools-distrib/vmware-install.pl --force-install --default

# Cleanup
umount /tmp/vmware
rm -rf /tmp/vmware /tmp/vmware-archive
rm -f /home/vagrant/*.iso
rm -f /etc/udev/rules.d/70-persistent-net.rules
