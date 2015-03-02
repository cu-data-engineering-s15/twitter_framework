require_relative '../requests/ListBlocks'

require 'trollop'

USAGE = %Q{
get_blocks: Retrieve blocked Twitter members.

Usage:
  ruby get_blocks_list.rb <options> <screen_name> <list_slug>

  <screen_name>: Screen name of owner who is blocking.
  
  <slug>: The slug belonging to the list.
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_blocks_list 0.1 (c) 2015 Kenneth M. Anderson; updated by Ian Moore"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:screen_name] = ARGV[0]
  opts[:slug] = ARGV[1]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { slug: input[:slug], screen_name: input[:screen_name] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = ListBlocks.new(args)

  puts "Collecting the ids of the Twitter users that are blocked by '#{input[:slug]}'"

  File.open('blocks_list_ids.txt', 'w') do |f|
    twitter.collect do |ids|
      ids.each do |id|
        f.puts "#{id}\n"
      end
    end
  end

  puts "DONE."

end
