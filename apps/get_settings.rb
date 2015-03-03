require_relative '../requests/AccountSettings'

require 'trollop'

USAGE = %Q{
get_settings: Retrieve trending terms for a given Where On Earth ID.

Usage:
  ruby get_trends.rb <options> <WOEID>

  <WOEID>: A Where On Earth ID (http://developer.yahoo.com/geo/geoplanet/)

  Example: 23424977 is the WOEID for the United States

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_settings 0.1 (c) 2015 Dustin Taylor;"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid file"
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = {}
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = AccountSettings.new(args)

  puts "Getting the current user settings"

  File.open('settings.json', 'w') do |f|
    twitter.collect do |settings|
        f.puts "#{settings.to_json}\n"
    end
  end

  puts "DONE."

end
