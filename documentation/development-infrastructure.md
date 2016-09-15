# Development Infrastructure

## Setting Up a Development Environment 

The source includes a vagrant file and chef code to provision a full
development vm.  To use it, you'll need to download and install
[Vagrant](https://www.vagrantup.com/) and the Vagrant
[Berkshelf](http://berkshelf.com/) plugin.  You'll also need to install
[NodeJS](https://nodejs.org/en/) and NPM.  Please see the Vagrant and Berkshelf
websites for installation instructions. 

Once you have everything installed, you'll need to run ``npm install`` in your
source directory to install the node dependencies.  Then you can just 
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

The chef which provisions the Vagrant vm will install NodeJS, Grunt, RSpec,
and all of the various software required to build and test Forest to Farm.  You
can use ``vagrant ssh`` typed from the directory that contains 
your ``Vagrantfile`` to ssh into your vm.  Once in your vm, you can ``cd
/srv/www/application/`` to get to your source directory.  From there you
can run ``grunt`` to perform a build and run the unit tests.

You may decide to install the test code locally rather than through the vm
itself.  In that case you'll need to install Grunt, which depends on NodeJS,
and RSpec, which depends on Ruby on your local machine.  Please see those
projects respective websites for installation instructions.

## Troubleshooting Vagrant

### PhantomJS Fails to Install

If you forget to run ``npm install`` prior to running ``vagrant up`` then you
may find that your first attempt to bring your vagrant box up fails with the
following error:

``` 
==> default:     Error executing action `run` on resource 'execute[Run 'npm install' in the project directory]'
```

If you scroll down through the error output you'll find this:

```
==> default:     Phantom installation failed { [Error: EACCES, mkdir '/srv/www/foresttofarm.org/node_modules/grunt-contrib-jasmine/node_modules/grunt-lib-phantomjs/node_modules/phantomjs-prebuilt/lib/phantom']
==> default:       errno: 3,
==> default:       code: 'EACCES',
==> default:       path: '/srv/www/foresttofarm.org/node_modules/grunt-contrib-jasmine/node_modules/grunt-lib-phantomjs/node_modules/phantomjs-prebuilt/lib/phantom' } Error: EACCES, mkdir '/srv/www/foresttofarm.org/node_modules/grunt-contrib-jasmine/node_modules/grunt-lib-phantomjs/node_modules/phantomjs-prebuilt/lib/phantom'
==> default:     npm ERR! Linux 3.13.0-93-generic
==> default:     npm ERR! argv "/usr/bin/node" "/usr/bin/npm" "install"
==> default:     npm ERR! node v0.10.46
==> default:     npm ERR! npm  v2.15.1
```

This is due to a bug in some combination of the phantomjs-prebuilt package
version, the npm version, and vagrant.  The best workaround I've found so far
is to just run ``npm install`` on your local machine before running ``vagrant
up``.  

In the case that you forget and hit this error, you can run ``npm install`` on
your local and then run ``vagrant provision``. Running ``vagrant provision``
will finish provisioning the vagrant server at the point it left off.  Once it
finishes you should be good to go.

