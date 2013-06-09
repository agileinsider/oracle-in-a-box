#!/bin/sh

date > /etc/vagrant_box_build_time

mkdir /media/cdrom
mount /dev/cdrom /media/cdrom

cat > /etc/yum.repos.d/puppetlabs.repo << EOM
[puppetlabs]
name=puppetlabs
baseurl=http://yum.puppetlabs.com/el/6/products/\$basearch
enabled=1
gpgcheck=0
EOM

cat > /etc/yum.repos.d/puppetlabs-deps.repo << EOM
[puppetlabs-deps]
name=Puppet Labs Dependencies EL 6 - x86_64
baseurl=http://yum.puppetlabs.com/el/6/dependencies/x86_64
enabled=1
gpgcheck=0
EOM

cat > /etc/yum.repos.d/epel.repo << EOM
[epel]
name=epel
baseurl=http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/\$basearch
enabled=1
gpgcheck=0
EOM

yum --enablerepo=c6-media -y install gcc make gcc-c++ kernel-devel-`uname -r` zlib-devel openssl-devel readline-devel sqlite-devel perl wget dkms nfs-utils
yum --enablerepo=c6-media -y install puppet facter ruby-devel rubygems
gem install --no-ri --no-rdoc chef
yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y clean all
rm /etc/yum.repos.d/{puppetlabs,puppetlabs-deps,epel}.repo

# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
curl -L -o authorized_keys https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
chown -R vagrant /home/vagrant/.ssh

# Installing the virtualbox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
curl -L -o VBoxGuestAdditions_$VBOX_VERSION.iso http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso

# Configure Networking

cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOM
DEVICE="eth0"
BOOTPROTO="dhcp"
IPV6INIT="no"
NM_CONTROLLED="yes"
ONBOOT="yes"
HOTPLUG="yes"
TYPE="Ethernet"
EOM

cat > /etc/sysconfig/network-scripts/ifcfg-eth1 << EOM
DEVICE="eth1"
BOOTPROTO="dhcp"
IPV6INIT="no"
NM_CONTROLLED="no"
ONBOOT="no"
HOTPLUG="no"
TYPE="Ethernet"
EOM

echo "Cleaning up DHCP leases..."
rm /var/lib/dhclient/*

echo "Cleaning up udev rules..."
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Disable DNS for SSH - speeds up boot-time"
sed -i "s/^#UseDNS.*$/UseDNS no/" /etc/ssh/sshd_config
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

echo "A little patch or two"
echo 0 > /proc/sys/kernel/hung_task_timeout_secs
echo 'Welcome to your automatically provisioned virtual machine.' > /etc/motd

echo "Zero Disk For Compression"
dd if=/dev/zero of=/tmp/clean || rm /tmp/clean

exit
