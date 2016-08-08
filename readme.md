# Forest to Farm

Forest to Farm is an online, open source database of useful plants based on
data assembled by Eric Toesenmeier and Dave Jacke in Edible Forest Gardens 
Vol. 2.  It is intended to help permaculturists, agro-ecologists, and home
gardeners in assembling permaculture systems and practicing restoration
agriculture. 

The current version of Forest to Farm may be used here at
[foresttofarm.org](http://foresttofarm.org).

## Helping Out

Forest to Farm is an open source project and we appreciate any help offered. If
you'd like to help develop it, take a look at the code standards document, and
then spend a little time reading through the issues and milestones to get a
feeling for where your efforts would be best spent.  

## Setting Up a Development Environment 

The source includes a vagrant file and chef code to provision a full
development vm.  To use it, you'll need to download and install
[Vagrant](https://www.vagrantup.com/), the Vagrant
[Berkshelf](http://berkshelf.com/) plugin, and the [Chef
DK](https://www.chef.io/). Please see the Vagrant, Berkshelf, and Chef websites
for installation instructions. 

Once you have vagrant and vagrant-berkshelf installed, you can just 
type ``vagrant up`` in the repository directory (the same one as the vagrant file
and this README) to bring up your development vm.  

The vm is configured to have a static private ip on your local network
(192.168.34.34).  To view your development version of Forest to Farm in a web
browser edit your hosts file and add a line to point ``foresttofarm.local`` to 
this ip address.

```
192.168.34.34   foresttofarm.local
```

You can now develop code locally in your favorite editor or IDE and test it
using your vagrant vm.  The code will be shared with the vm from your local
machine through the magic of vagrant shared folders.

You're now ready to hack away on Forest to Farm.

## Code Documentation

TODO

