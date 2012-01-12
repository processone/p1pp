require 'p1pp/p1_error'

module P1PP
  VERSION = '0.0.1'

  def self.exec
    begin
      yield
    rescue Exception => e
      raise P1Error::convert(e)
    end
  end
end
