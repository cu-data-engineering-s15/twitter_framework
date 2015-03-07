require_relative '../requests/BlocksIds'

require 'trollop'

USAGE = %Q{
get_blocks_ids: Returns an array of numeric user ids that the authenticating user is blocking.

Usage:
  ruby get_blocks_ids.rb <options> <screen_name>

  <screen_name>: A Twitter screen_name.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_blocks_ids 0.1 (c) 2015 Ken Anderson; Updated by Jonathan Song"
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

  input  = parse_command_line
  data   = { props: input[:props] }

  args     = { params: {}, data: data }

  twitter = BlockIds.new(args)

  puts "Collecting your blocked Ids"
  
  File.open('blocks_id.txt', 'w') do |b|
    twitter.collect do |ids|
      ids.each do |id|
        b.puts "#{id}\n"
      end
    end
  end


  puts "DONE."

end
