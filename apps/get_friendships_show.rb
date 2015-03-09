require_relative '../requests/FriendshipsShow'

require 'trollop'

USAGE = %Q{
get_friendships_show: Shows the relationships between two Twitter users.

Usage:
  ruby get_friendships_show.rb <options> <source_screen_name> <target_screen_name>

  <source_screen_name>: A Twitter screen name.
  <target_screen_name>: A second Twitter screen name

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_friendships_show 0.1 (c) 2015 Kenneth M. Anderson; Updated by Priyanka Goyal."
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:source] = ARGV[0]
  opts[:target] = ARGV[1]

  if opts[:source].nil?
    Trollop::die "A source screen name is required."
  end

  if opts[:target].nil?
    Trollop::die "A target screen name is required."
  end

  if opts[:source].downcase == opts[:target].downcase
    Trollop::die "Two different screen names are required."
  end

  opts
end

def describe_source(source, target, source_info)
  puts "The source is #{source}."
  puts "#{source}'s id is #{source_info['id']}."
  puts "#{source} follows #{target}       : #{source_info['following']}"
  puts "#{source} is followed by #{target}: #{source_info['followed_by']}"
  puts "#{source} can direct message #{target}: #{source_info['can_dm']}"
  puts "#{source} marked #{target} as spam?: #{source_info['marked_spam']}"
end

def describe_target(target, source, target_info)
  puts "The target is #{target}."
  puts "#{target}'s id is #{target_info['id']}."
  puts "#{target} follows #{source}       : #{target_info['following']}"
  puts "#{target} is followed by #{source}: #{target_info['followed_by']}"
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line

  params = {}
  params[:source_screen_name] = input[:source]
  params[:target_screen_name] = input[:target]

  data = { props: input[:props] }

  args = { params: params, data: data }

  twitter = FriendshipsShow.new(args)

  twitter.collect do |info|
    source_info = info['source']
    target_info = info['target']

    source = source_info['screen_name']
    target = target_info['screen_name']

    describe_source(source, target, source_info)
    puts
    describe_target(target, source, target_info)

  end

  puts "DONE."

end
