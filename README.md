puppet-module-graphite
======================

Description
-----------
A Puppet report processor for sending metrics to a [graphite][graphite] server.

Requirements
------------

* Puppet
* A [graphite][graphite] server.

Installation & Usage
--------------------
1.  Install `puppet-module-graphite` as a module in your Puppet
    master's module path (`puppet master --genconfig | 'modulepath ='`)

2.  Update the `host`, `port`, and `prefix` settings in the
    `<puppet_config_dir>/graphite.yaml` file (example:
    `/etc/puppet/graphite.yaml`) with your graphite server's
    hostname/IP, the port graphite is listening on, and (optionally) a
    prefix you'd like added to the path of the metrics sent by the
    report processor. By default, metrics are prefixed with
    'puppet'. An example configuration file is included in
    `graphite-example.yaml`.

3.  Enable `pluginsync` and reports in `puppet.conf` (for your master
    and your agents.) Add `graphite` to the `reports` setting. Your
    `puppet.conf` might look something like this:
```conf
[master]
pluginsync = true
report = true
reports = store,graphite

[agent]
pluginsync = true
report = true
```
4.  Run Puppet on your master the usual way to get the report sync'ed
    as a plugin.

[graphite]: http://graphite.wikidot.com/
