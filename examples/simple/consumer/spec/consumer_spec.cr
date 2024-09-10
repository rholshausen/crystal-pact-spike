require "./spec_helper"
require "webmock"

describe Consumer do
  describe "list command" do
    it "displays a list of todos from the provider" do
      project = Consumer::Project.new

      WebMock.stub(:get, "http://localhost:3000/").
        to_return(body: project.to_json, headers: {"Content-Type" => "application/json"})

      Consumer.list
    end
  end
end
