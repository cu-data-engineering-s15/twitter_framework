require_relative '../requests/ListMembersShow'

require 'trollop'

USAGE = %Q{
get_list_members_show: Check if the specified user is a member of the specified list.

Usage:
  ruby get_list_members.rb <options> <owner_screen_name> <list_slug> <screen_name>

  <owner_screen_name>: The screen name of the list owner.
  <screen_name>: The user screen name
  <list_slug>: The slug of the list.
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_list_members_show 0.1 (c) 2015 Kenneth M. Anderson; Updated by Nathan Lapinski"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:owner_screen_name] = ARGV[0]
  opts[:list_slug] = ARGV[1]
  opts[:screen_name] = ARGV[2]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { slug: input[:list_slug], owner_screen_name: input[:owner_screen_name], screen_name: input[:screen_name] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = ListMembersShow.new(args)

  puts "Checking to see if '#{input[:screen_name]}' is a member of list '#{input[:list_slug]}'"

  File.open('get_list_members_show.txt', 'w') do |f|
    twitter.collect do |ids|
      ids.each do |id|
        f.puts "#{id}\n"
      end
    end
  end

  puts "DONE."

end
