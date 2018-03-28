## Overview
This procedure installs the open source version of VMware Tools (`open-vm-tools`) and then compiles and installs the HGFS driver which allows use of VMware's native shared folder support. It is specifically for use with the official CentOS Vagrant boxes published at https://app.vagrantup.com/centos.

## Requirements
* Most versions of VMware and Vagrant should work with these instructions. The latest version of the Vagrant VMware plugin should always be used.

### Tested versions (MacOS)
Component | Version
--|--
CentOS box | 1802.01
VMware Fusion Pro | 10.1.1
Vagrant | 2.0.2
Vagrant VMware Desktop Plugin | 1.0.1

### Windows support
This procedure is no longer tested directly on a Windows host.

The steps have remained largely unchanged for several years, and are expected to remain valid until at least the next major release of RHEL/CentOS.

## Host preparation
* Copy the VMware Tools installer from the VMware application folder to the guest. The default locations for the installer are:
  * `/Applications/VMware\ Fusion.app/Contents/Library/isoimages/linux.iso` (MacOS)
  * `C:\Program Files (x86)\VMware\VMware Workstation\linux.iso` (Windows)
* Use `vagrant rsync` (MacOS) or a SMB synced folder (Windows) to copy the iso into the guest's `/vagrant` directory

## Commands to run within Vagrant guest
#### Update and reboot (if needed)
This is only required if the kernel has been updated since the box was released, so that the `kernel-devel` package matches the running kernel version

```
sudo yum -y update
exit
vagrant reload # On host
```

#### Install the EPEL repository (CentOS 6 only)
```
sudo yum -y install epel-release
```

#### Install the open source tools package
This provides all VMware functionality except for the HGFS driver required for synced folders:
```
sudo yum -y install open-vm-tools
```

#### Install build dependencies
```
sudo yum -y install perl gcc fuse make kernel-devel net-tools policycoreutils-python
```

#### Mount the installer iso and extract it to /tmp
```
mkdir -p /tmp/vmware /tmp/vmware-archive
sudo mount -o loop /vagrant/linux.iso /tmp/vmware
TOOLS_PATH="`ls /tmp/vmware/VMwareTools-*.tar.gz`"
tar xzf ${TOOLS_PATH} -C /tmp/vmware-archive
```

#### Install VMware Tools
Both `--force-install` and `--default` are required to avoid prompting, as we have already installed `open-vm-tools`. See https://kb.vmware.com/kb/2126368 for more details:
```
sudo /tmp/vmware-archive/vmware-tools-distrib/vmware-install.pl --force-install --default
```

#### Cleanup
```
sudo umount /tmp/vmware
rm -rf /tmp/vmware /tmp/vmware-archive /vagrant/*.iso
# linux.iso can also be removed from the host if still present (MacOS)
```

## Create a new shared folder using VMware shared folders
It currently isn't possible to override the default rsync `synced_folder` for `/vagrant` (this is a known issue). As a workaround, use a different name for the mount point in the guest, by adding a line like this to the `Vagrantfile` before the final `end`:
```
config.vm.synced_folder ".", "/vagrant2"
```

## Restart the VM and test
```
vagrant reload
```

## References:
* http://partnerweb.vmware.com/GOSIG/CentOS_7.html
* https://github.com/chef/bento
