require_relative '../requests/FriendshipsShow'

require 'trollop'

USAGE = %Q{
get_friendships_show: Shows friendship level between given Twitter source_screen_name and target_screen_name.

Usage:
  ruby get_friendships_show.rb <options> <source_screen_name> <target_screen_name>

  <source_screen_name>: A Twitter source_screen_name.
  <target_screen_name>: A Twitter target_screen_name

The following options are supported:

  --params: An OAuth Properties File

}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_tweets 0.1 (c) 2015 Kenneth M. Anderson; Updated by Priyanka Goyal."
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:source_screen_name] = ARGV[0]
  opts[:target_screen_name] = ARGV[1]

  if opts[:source_screen_name] == nil
    Trollop::die "A source screen name is required to show friendship."
  end

  if opts[:target_screen_name] == nil
    Trollop::die "A target screen name is required to show friendship."
  end

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { source_screen_name: input[:source_screen_name], target_screen_name: input[:target_screen_name] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = FriendshipsShow.new(args)

twitter.collect do |relationship|
    source_relationship = relationship['source']
    target_relationship = relationship['target']

    source = source_relationship['screen_name']
    target = target_relationship['screen_name']

    puts "#{source} screen name is: #{source_relationship['screen_name']}"
    puts "#{source} id is: #{source_relationship['id']}"
    puts "Does #{source} follows #{target}     : #{source_relationship['following']}"
    puts "Is #{source} is followed by #{target}: #{source_relationship['followed_by']}"
    puts "Can #{source} Direct Message #{target}: #{source_relationship['can_dm']}"
    puts "Has #{source} marked #{target} as spam: #{source_relationship['marked_spam']}"
    puts
    puts "#{target} screen name is: #{target_relationship['screen_name']}"
    puts "#{target} id is: #{target_relationship['id']}"
    puts "Is #{target} is followed by #{source}: #{target_relationship['followed_by']}"
    puts "Does #{target} follows #{source}       : #{target_relationship['following']}"

  end

  puts "DONE."

end
