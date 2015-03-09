require_relative '../requests/ListBlocks'

require 'trollop'

USAGE = %Q{
get_blocks: Retrieve Twitter users blocked by the current user.

Usage:
  ruby get_blocks_list.rb <options>

The following options are supported:
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

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  data   = { props: input[:props] }

  args     = { params: {}, data: data }

  twitter = ListBlocks.new(args)

  puts "Retrieving the Twitter users blocked by the current user."
  puts
  twitter.collect do |users|
    users.each do |user|
      puts "#{user['screen_name']}: #{user['id']}"
    end
  end

  puts "DONE."

end
