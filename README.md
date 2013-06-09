Oracle In A Box
=========

Veewee/Vagrant/Puppet configuration to install an oracle database on CentOS 6.4

Prerequisites
-------------

 - [Veewee](https://github.com/jedi4ever/veewee)
 - [Vagrant](http://www.vagrantup.com/)
 - [VirtualBox](http://www.virtualbox.org/)
 - [Oracle 11g Database Installer](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/112010-linx8664soft-100572.html) - store these in `downloads`

Steps
-----

1. Create the Vagrant/VirtualBox CentOS 6.4 basebox
 - `veewee vbox build centos-6.4`
 - `veewee vbox validate centos-6.4`
 - `veewee vbox export centos-6.4`
2. Add basebox to Vagrant 
 - `vagrant box add centos-6.4 centos-6.4.box`
3. Using Vagrant, start an instance of the basebox which will install oracle (using puppet)
 - `vagrant up`

