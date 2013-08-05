### -*- coding: utf-8 -*-
###
### © 2012, 2013 Krux Digital, Inc.
### This software is provided under the MIT License
###
### Author: Paul Lathrop <paul@krux.com>
require 'puppet'
require 'socket'
require 'yaml'

def with_graphite(host, port)
  raise "" if host.nil? || port.nil?
  socket = TCPSocket.new(host, port)
  yield socket
  socket.close
end

Puppet::Reports.register_report(:graphite) do
  ### Get the path to the config file. This will be
  ### <puppet_config_dir>/graphite.yaml (/etc/puppet/graphite.yaml by
  ### default).
  @configfile = File.join([File.dirname(Puppet.settings[:config]), "graphite.yaml"])
  raise(Puppet::ParseError, "Graphite report config file #{@configfile} unreadable!") unless File.exists?(@configfile)
  config = YAML.load_file(@configfile)
  HOST = config[:host]
  PORT = config[:port]
  PREFIX = config[:prefix] || 'puppet'

  desc <<-DESC
  Send report metrics to graphite.
  DESC

  def process
    Puppet.debug "Sending data for #{self.host} to graphite server at #{HOST}:#{PORT}"
    timestamp = self.time.to_i
    with_graphite(HOST, PORT) { |graphite|
      self.metrics.each { |metric, data|
        path = [PREFIX, metric]
        data.values.each { |name, _, value|
          path << name
          debug = [path.join('.'), value, timestamp].join(' ')
          Puppet.debug "Sending: '#{debug}'"
          graphite.puts([path.join('.'), value, timestamp].join(' '))
          path.pop()
        }
      }
    }
  end
end
