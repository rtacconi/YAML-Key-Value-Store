require 'rubygems'
require 'yaml'

class Storage
  attr_accessor :data
  
  def initialize
    @data = begin
      YAML.load(File.open("storage.yml"))
    rescue ArgumentError => e
      puts "Could not parse YAML: #{e.message}"
    end
  end
  
  def store
    File.open("storage.yml", "w") {|f| f.write(@data.to_yaml) }
  end

  def get_value(key)
    @data[key]
  end

  def set_value(key, value)
    @data[key] = value
    store
  end

  def delete_value(key)
    @data.delete(key)
    store
  end

  def print_all
    puts @data.inspect
  end
end

commands = %w{get set delete quit print_all}
puts "YAML Key Value Store v0.1 - Riccardo Tacconi"
puts "Please enter one of the following commans: #{commands.join(' ')}"
puts "Example1: set color white"
puts "Example 2: get color # => white"
puts "Example 3: print_all # => {\"color\" => \"white\"}"

loop do
  begin
    print '> '
    from_cli = gets.chomp
    cmds = from_cli.split(' ')
    cmd = cmds[0] # command
    key = cmds[1] if cmds[1] # key
    # value - take all token if there is more than one work in double quotes
    if cmds[2]
      if cmds.length > 3
        value = from_cli.scan(/"([^"]*)"/).first.to_s
      else
        value = cmds[2]
      end
    end
    
    s = Storage.new
  
    case cmd
    when 'get'
      puts s.get_value(key)
    when 'set'
      s.set_value(key, value)
    when 'delete'
      s.delete_value(key)
    when 'print_all'
      s.print_all
    when 'quit'
      break
    end
  rescue
    puts "Error #{e.message}"
  end
end