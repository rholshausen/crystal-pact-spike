require "./spec_helper"
require "webmock"
require "pact-crystal"

describe Consumer do
  describe "list command" do
    it "displays a list of todos from the provider" do
      project = Consumer::Project.new

      WebMock.wrap do
        WebMock.stub(:get, "http://localhost:3000/").
          to_return(body: project.to_json, headers: {"Content-Type" => "application/json"})

        Consumer.list
      end
    end
  end

  describe "list command pact test" do
    before_all do
      Pact::Crystal.init
    end

    before_each do
      WebMock.allow_net_connect = true
    end

    it "displays a list of todos from the provider" do
      project = Consumer::Project.new

      Consumer.list
    end
  end
end
