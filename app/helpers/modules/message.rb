# frozen_string_literal: true

# Include this module to play with messages to the user
module Message
  def self.ask(message, options = {})
    puts message
    options.each { |key, value| puts "Press #{key} to #{value}" }
    gets.chomp.downcase
  end

  def self.stop
    puts 'Bye!'
  end

  def self.hello
    puts 'Welcome to the vending machine'
    print_30_lines
  end

  def self.print_30_lines
    30.times {print '-' }
    puts
  end
end
