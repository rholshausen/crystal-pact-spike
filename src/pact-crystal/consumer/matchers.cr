module Pact::Crystal::Consumer::Matchers
  extend self

  module Matcher
  end

  def self.each_like(example : Hash(String, Object)) : Matcher
    EachLikeMatcher.new(example)
  end

  class EachLikeMatcher
    include Matcher

    def initialize(@example : Hash(String, Object))
    end
  end
end
