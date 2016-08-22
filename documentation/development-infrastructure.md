# Development Infrastructure

## Setting Up a Development Environment 

The source includes a vagrant file and chef code to provision a full
development vm.  To use it, you'll need to download and install
[Vagrant](https://www.vagrantup.com/) and the Vagrant
[Berkshelf](http://berkshelf.com/) plugin.  Please see the Vagrant and
Berkshelf websites for installation instructions. 

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

## Testing the Code

The chef which provisions the Vagrant vm will install NodeJS, Grunt, PHPUnit,
and all of the various software required to build and test Forest to Farm.  You
can use ``vagrant ssh`` typed from the directory that contains 
your ``Vagrantfile`` to ssh into your vm.  Once in your vm, you can ``cd
/srv/www/foresttofarm.org/`` to get to your source directory.  From there you
can run ``grunt`` to perform a build and run the unit tests.

You may decide to install the test code locally rather than through the vm
itself.  In that case you'll need to install Grunt, which depends on NodeJS,
and PHPUnit, which depends on PHP on your local machine.  Please see those
projects respective websites for installation instructions.

