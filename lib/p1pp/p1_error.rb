module P1Error
  def self.convert(exception)
    case exception.class.to_s
      when 'Blather::SASLError'
        "Authentication failed"
      else
        exception.to_s
    end
  end
end
