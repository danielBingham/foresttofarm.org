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

## Troubleshooting Vagrant

You may find that your first attempt to bring your vagrant box up with ``vagrant up`` fails with
the following error:

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
==> default:     
==> default: npm ERR! npm  v2.15.1
==> default: 
==> default:     
==> default: npm ERR! code ELIFECYCLE
==> default: 
==> default:     
==> default: 
==> default: 
==> default:     
==> default: npm ERR! phantomjs-prebuilt@2.1.12 install: `node install.js`
==> default: 
==> default:     
==> default: npm ERR! Exit status 1
==> default: 
==> default:     
==> default: npm ERR! 
==> default:     npm ERR! Failed at the phantomjs-prebuilt@2.1.12 install script 'node install.js'.
==> default:     npm ERR! This is most likely a problem with the phantomjs-prebuilt package,
==> default:     npm ERR! not with npm itself.
==> default:     npm ERR! Tell the author that this fails on your system:
==> default:     npm ERR!     node install.js
==> default:     npm ERR! You can get information on how to open an issue for this project with:
==> default:     npm ERR!     npm bugs phantomjs-prebuilt
==> default:     npm ERR! Or if that isn't available, you can get their info via:
==> default:     npm ERR! 
==> default:     npm ERR!     npm owner ls phantomjs-prebuilt
==> default:     npm ERR! There is likely additional logging output above.
```

This is due to a bug in some combination of the phantomjs-prebuilt package version
and the npm version.  The best workaround I've found so far is to just 
run ``npm install`` on your local machine and then run ``vagrant provision`` 
again. ``npm install`` should work fine on your local unless you have the same
combination of npm verison and phantomjs version as the vagrant box, and
running ``vagrant provision`` will finishing provisioning the vagrant server at
the point it left off.  Once it finishes you should be good to go.

Alternatively, if you'd like to avoid the risk of running into this bug
entirely, simply run ``npm install`` your local machine before bringing the
vagrant box up.
