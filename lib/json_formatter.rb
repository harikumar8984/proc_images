# frozen_string_literal: true

# Handling Json Data
class JsonFormatter
  def self.parse(data)
    binding.pry
    JSON.parse(format(data))
  end
end
