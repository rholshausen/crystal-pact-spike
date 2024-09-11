require "log"
require "json"

module Pact::Crystal::Consumer::Bodies
 extend self

  def self.generate_json_body(body : Hash(String, Object)) : String
    JSON.build do |json|
      json.object do
        body.each do |key, value|
          json.field(key) do
            case value
              when Hash
              when Array
                json.array do
                  value.each do |item|
                    build_json(json, item)
                  end
                end
              else
                json.scalar(value)
            end
          end  
        end
      end
    end
  end

  def build_json(json : JSON::Builder, value)
    case value
      when Hash
      when Array
      else
        json.scalar(value)
    end
  end
end
