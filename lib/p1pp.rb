require 'lib/p1pp/p1_error'

module P1PP
  VERSION = '0.0.1'

  def self.exec
    begin
      yield
    rescue Exception => e
      raise P1Error::convert(e)
    end
  end

  def self.pubsub_host
    "pubsub.p1pp.net"
  end

  def self.check_credentials(username, password)
    raise "JID is mandatory to connect on your account" if username.blank?
    raise "Password is mandatory to connect on your account" if password.blank?
    puts "As user: #{username}"
  end

  def self.check_node(node)
    raise 'Node argument is mandatory' if node.blank?
  end
end
