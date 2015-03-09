require_relative '../requests/Languages'

require 'trollop'

USAGE = %Q{
get_languages: Retrieves a list of languages and language codes supported by Twitter.

Usage:
  ruby get_languages.rb <options>

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_languages 0.1 (c) 2015 Kenneth M. Anderson; Modified by Heather Witte"
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

  input = parse_command_line
  data = {props: input[:props] }

  args = {params: {}, data: data}
  twitter = Languages.new(args)

  File.open('languages.txt', 'w') do |f|
    twitter.collect do |languages|
      languages.each do |language|
        f.puts "#{language['name']} (#{language["code"]})"
      end
    end
  end

  puts "Language information stored in 'languages.txt'."
  puts "DONE"

end
