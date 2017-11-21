Hands-On UNIX SysAdmin DeCal puppet
===================================

## Boostrapping a new host

To bootstrap a new host on AWS, first spin up the host and give it a DNS entry
so it has something like `<username>.decal.xcf.sh`. Then, run the
`bootstrap.sh` script in this repo and input the correct hostname into the
script when prompted. This will set the hostname, search domain, restart
`dhclient`, and create a certificate. On the puppet master
(`puppet.decal.xcf.sh`), sign the certificate with `sudo puppet cert sign
<fqdn>`, and on the original host run `sudo puppet agent -t`, and it should be
fully set up! Puppet will run every 10 minutes on each host, so once it is set
up the first time, any changes should get propagated out to all VMs.

## Making changes

Clone this repo into `/etc/puppet/code/environments/<your username>` on the staff VM,
and make changes there. To change the environment of a host, edit
`/etc/puppet/puppet.conf` to include a line `environment = <your username>`
under `[agent]`. If `[agent]` doesn't already exist, just create it as a new
config section. To test your changes, run `puppet agent -t` on the host that is
on your environment, and check the output. Make sure to change back to the
`production` environment when you are done testing, otherwise it will not get
any updates pushed by others.

## Propagating changes

After you commit your changes to master, it is necessary to pull from upstream on the
staff VM, e.g. `cd /etc/puppet/code/environments/production && git pull origin master`
in order for Puppet to begin updating the student machines.
