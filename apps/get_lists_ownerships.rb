require_relative '../requests/ListsOwnerships'

require 'trollop'

USAGE = %Q{
get_lists_ownerships: Returns lists owned by specified Twitter user.

Usage:
  ruby get_lists_ownerships.rb <options> <screen_name>

  <screen_name>: The screen name of the user.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_lists_ownerships 0.1 (c) 2015 Kenneth M. Anderson; updated by Tyler Bussell"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:screen_name] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { screen_name: input[:screen_name] }
  data   = { props: input[:props] }

  args   = { params: params, data: data }

  twitter = ListsOwnerships.new(args)

  puts "Collecting the lists owned by user '#{input[:screen_name]}'"

  File.open('list_ownerships.json', 'w') do |f|
    twitter.collect do |lists|
      lists.each do |list|
        f.puts "#{list.to_json}\n"
      end
    end
  end

  puts "Lists stored in file 'list_ownerships.json'."
  puts "DONE."

end
