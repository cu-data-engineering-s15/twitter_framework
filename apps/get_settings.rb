require_relative '../requests/AccountSettings'

require 'trollop'

USAGE = %Q{
get_settings: Retrieve the account settings of the current Twitter user.

Usage:
  ruby get_settings.rb <options>

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_settings 0.1 (c) 2015 Kenneth M. Anderson; Updated by Dustin Taylor"
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
  data   = { props: input[:props] }

  args     = { params: {}, data: data }

  twitter = AccountSettings.new(args)

  puts "Getting the account settings of the current Twitter user."

  File.open('settings.json', 'w') do |f|
    twitter.collect do |settings|
      f.puts "#{settings.to_json}\n"
    end
  end

  puts "Settings saved to settings.json."
  puts "DONE."

end
