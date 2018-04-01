# TODO: find out a way to do this without having to make this manifest get
# loaded last
# A manual lookup and include is used to make it possible to override the
# default classes by specifying more specific classes lists
$classes = lookup('classes', Array, 'first')
include $classes

# By default, the cron type won't reset attributes if you don't specify them.
# (e.g. if you only set "minute => '0'", it won't reset hour to '*')
# This is bad behavior because the resource is only partially managed by Puppet.
# Change the defaults to make the cron type behave reasonably in our manifests.
#
# Also set the PATH environment variable to be the same as in /etc/crontab.
# The default PATH is only /usr/bin:/bin, which lacks a lot of commands.
Cron {
  special => 'absent',
  minute => '*',
  hour => '*',
  weekday => '*',
  month => '*',
  monthday => '*',
  environment => 'PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'
}
