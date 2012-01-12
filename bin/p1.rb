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
require 'p1pp/p1_error'

include GLI

program_desc 'This is a command-line interface tool to ProcessOne Push Platform'

version P1PP::VERSION

desc 'Your XMPP ID (JID)'
arg_name 'me@talkr.im'
flag [:j, :jid]

desc 'Your XMPP account password'
arg_name 'password'
flag [:p, :password]

# Options [host] [port]

desc 'Create a pubsub node on P1PP'
arg_name 'NodeName'
command :create do |c|
  c.action do |global_options, options, args|

    P1PP::exec {
      P1Publisher::create_node(global_options[:j], global_options[:p], args[0])
    }
  end
end

desc 'List your nodes'
command :list do |c|
  c.action do |global_options, options, args|
    P1PP::exec {
      P1Publisher::list_nodes(global_options[:j], global_options[:p])
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

desc 'Describe subscribe here'
arg_name 'Describe arguments to subscribe here'
command :subscribe do |c|
  c.action do |global_options, options, args|
  end
end

pre do |global, command, options, args|
  # Pre logic here
  # Return true to proceed; false to abort and not call the
  # chosen command
  # Use skips_pre before a command to skip this block
  # on that command only
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
