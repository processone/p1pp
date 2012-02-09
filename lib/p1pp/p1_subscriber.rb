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
      # We subscribe to presence so that it is allowed to receive message on Gtalk
      presence = Blather::Stanza::Presence::Subscription.new("pubsub.p1pp.net", :subscribe)
      write_to_stream presence

      # Actual Pubsub subscribe:
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

  # TODO:
  # Filter: Only payload or full stanza.
  # Other option: parameter
  def self.listen(username, password)
    P1PP::check_credentials(username, password)
    setup username, password

    pubsub_event { |m|
      if m.from == P1PP::pubsub_host
        m.items.each { |item|
          puts "#{item.payload}"
        }
      end
    }

    EM.run {
      client.run
    }
  end

end
