require_relative '../requests/ListMemberIds'

require 'trollop'

USAGE = %Q{
get_lists_ownerships: Returns lists owned by specified Twitter user.

Usage:
  ruby get_lists_ownerships.rb <options> <user_screen_name>

  <owner_screen_name>: The screen name of the user.

}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_lists_ownerships 0.1 (c) 2015 Ken M. Anderson; updated by Tyler Bussell"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:owner_screen_name] = ARGV[0]
  opts[:list_slug] = ARGV[1]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { owner_screen_name: input[:owner_screen_name], count:1000 }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = ListsOwnerships.new(args)

  puts "Collecting the lists owned by specific user '#{input[:list_slug]}'"

  File.open('list_ownerships.json', 'w') do |f|
    twitter.collect do |lists|
      lists.each do |list|
        f.puts "#{list.to_json}\n"
      end
    end
  end

  puts "DONE."

end
