require_relative '../requests/ListFollowersIds'

require 'trollop'

USAGE = %Q{
get_list_friends: Retrieve user ids that follow a given Twitter list.

Usage:
  ruby get_list_followers.rb <options> <screen_name>

  <screen_name>: A Twitter screen_name.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_list_followers 0.1 (c) 2015 Kenneth M. Anderson; Updated by Priya Sudendra"
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

  twitter = ListFollowerss.new(args)

  puts "Collecting the followers of the specified list '#{input[:list_slug]}'"

  File.open('list_followerss.txt', 'w') do |f|
    twitter.collect do |ids|
      ids.each do |id|
        f.puts "#{id}\n"
      end
    end
  end

  puts "DONE."

end
