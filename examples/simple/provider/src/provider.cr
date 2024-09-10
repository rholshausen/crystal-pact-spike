require "kemal"
require "log"
require "json"

module Provider
  VERSION = "0.1.0"

  class Task
    include JSON::Serializable

    @id : UInt32
    @done : Bool = false
    @name : String

    def initialize(id : UInt32, name : String)
      @id = id
      @name = name
    end
  end

  class Todo
    include JSON::Serializable

    @id : UInt32
    @name : String
    @type : String = "activity"
    @due : Time?
    @tasks : Array(Task) = [] of Task

    def initialize(id : UInt32, name : String)
      @id = id
      @name = name
    end
  end

  class Project
    include JSON::Serializable

    @todos = [] of Todo

    def initialize
    end
  end
end

Log.setup_from_env
project = Provider::Project.new

get "/" do |env|
  env.response.content_type = "application/json"
  project.to_json
end

Kemal.run
