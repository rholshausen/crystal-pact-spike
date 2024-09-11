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

        Consumer.list "http://localhost:3000/"
      end
    end
  end

  describe "list command pact test" do
    before_each do
      WebMock.allow_net_connect = true
    end

    it "displays a list of todos from the provider" do
      provider = Pact::Crystal::Consumer::Dsl::PactBuilder.new("todo-consumer", "todo-provider")
      provider
        .http_interaction("a request for all todos") do |interaction|
          interaction
            .given("there are todos")
            .with_request("GET", "/") do |req|
              req.header("accept", "application/json")
            end
            .will_response_with do |resp|
              resp.status(200)
                .header("content-type", "application/json")
                .json_body({ 
                  # "todos" => Pact::Crystal::Consumer::Matchers.each_like({
                  #   "id" => 1
                  # } of String => Object)
                  "todos" => [] of Int8
                })
    #          res.body = json_body
    #            .each_like({
    #              id => integer(1),
    #              name => string("Project 1"),
    #              due => datetime("yyyy-MM-dd'T'HH:mm:ss.SSSX", "2016-02-11T09:46:56.023Z"),
    #              tasks => at_least_one_like({
    #                id => integer(),
    #                name => string("Do the laundry"),
    #                done => boolean(true)
    #              }, 4)
    #            })
            end
        end

      mock_provider = provider.start_mock_server

      Consumer.list(mock_provider.url.to_s)
    end
  end
end
