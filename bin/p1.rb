#!/usr/bin/env ruby
# 1.9 adds realpath to resolve symlinks; 1.8 doesn't
# have this method, so we add it so we get resolved symlinks
# and compatibility
unless File.respond_to? :realpath
  class File #:nodoc:
    def self.realpath path
      return realpath(File.readlink(path)) if symlink?(path)
      path
    end
  end
end
$: << File.expand_path(File.dirname(File.realpath(__FILE__)) + '/../lib')

require 'rubygems'
require 'gli'
require 'p1pp'
require 'p1pp/p1_publisher'
require 'p1pp/p1_subscriber'
require 'p1pp/p1_error'

include GLI

program_desc 'This is a command-line interface tool to ProcessOne Push Platform'

version P1PP::VERSION

config_file '.p1pp.conf'

desc 'Your XMPP ID (JID)'
arg_name 'me@talkr.im'
flag [:jid, :j]

desc 'Your XMPP account password'
arg_name 'password'
flag [:password, :p]

desc 'XMPP debug mode'
arg_name 'debug'
switch [:debug]

# TODO: Options [host] [port]

desc 'Create a pubsub node'
arg_name 'NodeName'
command :create do |c|
  c.action do |global_options, options, args|

    P1PP::exec {
      P1Publisher::create_node(global_options[:jid], global_options[:password], args[0])
    }
  end
end

desc 'List your pubsub nodes'
command :list do |c|
  c.action do |global_options, options, args|
    P1PP::exec {
      P1Publisher::list_nodes(global_options[:jid], global_options[:password])
    }
  end
end

desc 'Delete a pubsub node'
arg_name 'NodeName'
command :delete do |c|
  c.action do |global_options, options, args|

    P1PP::exec {
      P1Publisher::delete_node(global_options[:jid], global_options[:password], args[0])
    }
  end
end

desc 'Subscribe to a node'
arg_name 'NodeName'
command :subscribe do |c|
  c.action do |global_options, options, args|
    P1PP::exec {
      P1Subscriber::subscribe(global_options[:jid], global_options[:password], args[0])
    }
  end
end

desc 'Unsubscribe from a node'
arg_name 'NodeName'
command :unsubscribe do |c|
  c.action do |global_options, options, args|
    P1PP::exec {
      P1Subscriber::unsubscribe(global_options[:jid], global_options[:password], args[0])
    }
  end
end


desc 'Describe publish here'
arg_name 'Describe arguments to publish here'
command :publish do |c|
  c.desc 'Describe a switch to publish'
  c.switch :s

  c.desc 'Describe a flag to publish'
  c.default_value 'default'
  c.flag :f
  c.action do |global_options, options, args|
  end
end

desc 'Describe listen here'
arg_name 'Describe arguments to listen here'
command :listen do |c|
  c.action do |global_options, options, args|
  end
end

pre do |global, command, options, args|
  debug = global[:debug]
  Blather.logger.level = Logger::DEBUG if debug
  true
end

post do |global, command, options, args|
  # Post logic here
  # Use skips_post before a command to skip this
  # block on that command only
end

on_error do |exception|
  # Error logic here
  # return false to skip default error handling
  true
end

exit GLI.run(ARGV)
