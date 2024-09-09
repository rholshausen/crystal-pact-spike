require "option_parser"

module Consumer
  extend self

  VERSION = "0.1.0"

  enum Command
    List
  end

  def list

  end
end

command = nil
parser = OptionParser.parse do |parser|
  parser.banner = "Welcome to The Simple Todo App!"

  parser.on "-v", "--version", "Show version" do
    puts "version #{Consumer::VERSION}"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
  parser.on("list", "List all current todos") do
    command = Consumer::Command::List
    parser.banner = "Usage: consumer list"
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
  parser.missing_option do |option|
    STDERR.puts "ERROR: #{option} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
  parser.unknown_args do |args|
    unless args.empty?
      STDERR.puts "ERROR: #{args} is not valid command."
      STDERR.puts parser
      exit(1)
    end
  end
end

case command
  when Consumer::Command::List
    Consumer.list()
  else
    puts parser
end
