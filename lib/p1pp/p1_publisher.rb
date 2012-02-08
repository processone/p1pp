require 'rubygems'
require 'blather/client/dsl'
require 'blather/client/dsl/pubsub'

module P1Publisher
  extend Blather::DSL

  def self.pubsub_host
    "pubsub.p1pp.net"
  end

  def self.create_node(username, password, node)
    self.check_credentials(username, password)
    self.check_node(node)

    setup username, password

    when_ready {
      # puts "Connected: #{client.jid.inspect}"
      pubsub = Blather::DSL::PubSub.new(client, self.pubsub_host)
      pubsub.create(node) { |stanza|
        if stanza.error?
          error = Blather::StanzaError.import(stanza)
          puts "Pubsub error when creating node #{node}: #{error.type} (#{error.name})"
        else
          puts "Created node #{node}"
        end
        client.close
      }
    }

    EM.run {
      client.run
    }
  end

  def self.list_nodes(username, password)
    self.check_credentials(username, password)
    setup username, password

    when_ready {
      pubsub = Blather::DSL::PubSub.new(client, self.pubsub_host)
      pubsub.affiliations { |affiliation|
        owner = affiliation[:owner]
        if owner.empty?
          puts "You do not own any node"
        else
          puts "You own the following nodes:"
          owner.each { |node|
            puts " #{node}"
          }
        end
        client.close
      }
    }

    EM.run {
      client.run
    }
  end

  @private

  def self.check_credentials(username, password)
    raise "JID is mandatory to connect on your account" if username.blank?
    raise "Password is mandatory to connect on your account" if password.blank?
    puts "As user: #{username}"
  end

  def self.check_node(node)
    raise 'Node argument is mandatory' if node.blank?
  end
end
