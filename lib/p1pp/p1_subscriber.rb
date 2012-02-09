require 'rubygems'
require 'blather/client/dsl'
require 'blather/client/dsl/pubsub'

module P1Subscriber
  extend Blather::DSL

  def self.subscribe(username, password, node)
    P1PP::check_credentials(username, password)
    P1PP::check_node(node)

    setup username, password

    when_ready {
      pubsub = Blather::DSL::PubSub.new(client, P1PP::pubsub_host)
      pubsub.subscribe(node) { |stanza|
        if stanza.error?
          error = Blather::StanzaError.import(stanza)
          puts "Pubsub error when subscribing to node #{node}: #{error.type} (#{error.name})"
        else
          puts "Subscribed to node: #{node}"
        end
        client.close
      }
    }

    EM.run {
      client.run
    }
  end

  def self.unsubscribe(username, password, node)
    P1PP::check_credentials(username, password)
    P1PP::check_node(node)

    setup username, password

    when_ready {
      pubsub = Blather::DSL::PubSub.new(client, P1PP::pubsub_host)
      pubsub.subscribe(node) { |stanza|
        if stanza.error?
          error = Blather::StanzaError.import(stanza)
          puts "Pubsub error when unsubscribing from node #{node}: #{error.type} (#{error.name})"
        else
          puts "Unsubscribed from node: #{node}"
        end
        client.close
      }
    }

    EM.run {
      client.run
    }
  end

end
