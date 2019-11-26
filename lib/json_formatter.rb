# frozen_string_literal: true

# Handling Json Data
class JsonFormatter
  def self.parse(data)
    JSON.parse(format(data))
  end
end
