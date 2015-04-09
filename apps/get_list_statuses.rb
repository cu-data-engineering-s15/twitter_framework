require_relative '../requests/ListsStatuses'

require 'trollop'

USAGE = %Q{
get_list_members: Retrieve members of a given Twitter list.

Usage:
  ruby get_list_members.rb <options> <owner_screen_name> <list_slug>

  <owner_screen_name>: The screen name of the list owner.
  <list_slug>: The slug of the list.
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_list_members 0.1 (c) 2015 Kenneth M. Anderson; Updated by David Aragon"
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
  params = { slug: input[:list_slug], owner_screen_name: input[:owner_screen_name] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = ListsStatuses.new(args)

  puts "Retrieving the lastest tweets for list #{input[:list_slug]}"

  File.open('list_tweets.json', 'w') do |f|
    twitter.collect do |tweets|
      tweets.each do |tweet|
        f.puts "#{tweet}\n"
      end
    end
  end

  puts "DONE."

end
