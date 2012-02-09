require 'rubygems'
require 'blather/client/dsl'
require 'blather/client/dsl/pubsub'

module P1Publisher
  extend Blather::DSL

  def self.create_node(username, password, node)
    P1PP::check_credentials(username, password)
    P1PP::check_node(node)

    setup username, password

    when_ready {
      pubsub = Blather::DSL::PubSub.new(client, P1PP::pubsub_host)
      pubsub.create(node) { |stanza|
        if stanza.error?
          error = Blather::StanzaError.import(stanza)
          puts "Pubsub error when creating node #{node}: #{error.type} (#{error.name})"
        else
          puts "Created node: #{node}"
        end
        client.close
      }
    }

    EM.run {
      client.run
    }
  end

  def self.list_nodes(username, password)
    P1PP::check_credentials(username, password)
    setup username, password

    when_ready {
      pubsub = Blather::DSL::PubSub.new(client, P1PP::pubsub_host)
      pubsub.affiliations { |affiliation|
        owner = affiliation[:owner]
        if owner.nil? || owner.empty?
          puts "You do not own any node"
        else
          puts "You own the following nodes:"
          owner.each { |node|
            puts " #{node}"
          }
        end
        puts ""
        pubsub.subscriptions { |subscriptions|
          if subscriptions.nil? || subscriptions.empty?
            puts "You are not subscribed to any node"
          else
            puts "You are subscribed to the following nodes:"
            subscribed = subscriptions[:subscribed]
            subscribed.each { |item|
              puts " #{item[:node]} (subid: #{item[:subid]})"
            }
          end
          client.close
        }
      }
    }

    EM.run {
      client.run
    }
  end

  def self.delete_node(username, password, node)
    P1PP::check_credentials(username, password)
    P1PP::check_node(node)

    setup username, password

    when_ready {
      pubsub = Blather::DSL::PubSub.new(client, P1PP::pubsub_host)
      pubsub.delete(node) { |stanza|
        if stanza.error?
          error = Blather::StanzaError.import(stanza)
          puts "Pubsub error when deleting node #{node}: #{error.type} (#{error.name})"
        else
          puts "Deleted node: #{node}"
        end
        client.close
      }
    }

    EM.run {
      client.run
    }
  end

  def self.publish(username, password, node)
    P1PP::check_credentials(username, password)
    P1PP::check_node(node)

    setup username, password

    when_ready {
      pubsub = Blather::DSL::PubSub.new(client, P1PP::pubsub_host)

      i = 0
      $stdin.each { |line|
        i = i +1
        puts "#{line}"
        payload = "<p1pp-raw xmlns='p1pp'>#{line}</p1pp-raw>"
        pubsub.publish(node, payload) { |stanza|
          if stanza.error?
            error = Blather::StanzaError.import(stanza)
            puts "Pubsub error when publishing on #{node}: #{error.type} (#{error.name})"
            puts "Content:\n#{line}"
          end
          i = i - 1
          client.close if $stdin.eof && i == 0
        }
      }
    }

    EM.run {
      client.run
    }
  end
end
