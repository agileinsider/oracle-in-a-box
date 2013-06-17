Oracle In A Box
=========

Veewee/Vagrant/Puppet configuration to install an oracle database on CentOS 6.4

Prerequisites
-------------

 - [Veewee](https://github.com/jedi4ever/veewee) (*can be skipped if using prebuilt box)
 - [Vagrant](http://www.vagrantup.com/)
 - [VirtualBox](http://www.virtualbox.org/)
 - [Oracle 11g Database Installer](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/112010-linx8664soft-100572.html) - store these in `downloads`

Please note, getting veewee, vagrant and virtual box to play nicely can be fun and is left as an exercise for the reader.

Steps
-----

1. Create the Vagrant/VirtualBox CentOS 6.4 basebox
 - `veewee vbox build centos-6.4`
 - `veewee vbox validate centos-6.4`
 - `veewee vbox export centos-6.4`
2. Add basebox to Vagrant 
 - `vagrant box add centos-6.4 centos-6.4.box`
 - You can skip the veewee build by issuing `vagrant box add centos-6.4 http://share.agile.ly/centos-6.4.box`
3. Using Vagrant, start an instance of the basebox which will install oracle (using puppet)
 - `vagrant up`
4. Login to the box and check oracle install
 - `vagrant ssh`
 - `sudo -i`
 - `su - oracle`
 - `sqlplus sys/password as sysdba`

You can if you want export this as a box to save the time required to install oracle ;)
1. Export the box and create new instance
 - `vagrant export --output oracle-vm.box`
 - `vagrant box add oracle-vm oracle-vm.box`
 - `vagrant destroy`
2. Try your shiny new oracle box
 - `mkdir instance`
 - `cd instance`
 - `vagrant init oracle-vm`
 - `vagrant up`

I would publish the prebuilt oracle-vm.box, but since I had to agree to the OTN restrictions to get the oracle installers I would be violating the agreement by doing so.

I may add some more detailed documentation to describe what is going on, but essentially, we are creating a standard vagrant basebox (that's the veewee part, which includes all the stuff to create the VM, run kickstart and install the minimal software).  We then use vagrant to install oracle using puppet.  The puppet module has been deliberately kept simple and self-contained to make it easy for a newcomer to understand and also easy for a DBA to review.
