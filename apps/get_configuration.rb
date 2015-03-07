require_relative '../requests/Configuration'
require 'trollop'

USAGE = %Q{
get_configuration: retrieve general Twitter configuration information

Usage: ruby get_configuration <options>

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_configuration   (c) 2015 Kenneth M. Anderson; Updated by Piyush Sudip Patel"
    banner USAGE
    opt :props, "OAuth_Properties_File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "Must point to a valid oauth Properties File"
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input   = parse_command_line

  data    = { props: input[:props] }
  args    = { params: {}, data: data }

  twitter = Configuration.new(args)

  File.open('configuration.json', 'w') do |f|
    twitter.collect do |info|
      f.puts "#{info.to_json}"
    end
  end

  puts "Configuration info stored in file 'configuration.json'."
  puts "DONE."

end
