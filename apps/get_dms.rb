require_relative '../requests/DirectMessages'

require 'trollop'

USAGE = %Q{
get_friends: Retrieve direct messages of the current Twitter user.

Usage:
  ruby get_dms.rb <options>

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_dms 0.1 (c) 2015 Kenneth M. Anderson; Updated by Phil Leonowens"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input   = parse_command_line

  data    = { props: input[:props] }
  args    = { params: {}, data: data }

  twitter = DirectMessages.new(args)

  puts "Collecting your direct messages"

  File.open('dms.txt', 'w') do |f|
    twitter.collect do |searches|
      searches.each do |search|
        f.puts "#{search['sender_screen_name']}: #{search['text']}\n"
      end
    end
  end

  puts "Messages placed in the file 'dms.txt'."
  puts "DONE."

end
