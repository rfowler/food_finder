require 'restaurant'

class Guide
  class Config
    @@actions = ['list', 'find', 'add', 'quit']
    def self.actions; @@actions end
  end

  def initialize(path=nil)
    # locate the restaurant text file at path
    Restaurant.filepath = path
    if Restaurant.file_usable?
      puts "Found restaurant file"
    
    # or create file
    elsif Restaurant.create_file
      puts "Created restaurant file"
    
    #exit if it fails
    else
      puts "Exiting. \n\n"
      exit!
    end
  end

  def launch
    # welcome
    welcome

    # action loop
    # repeat until user quits
    result = nil
    until result == :quit

    #   what do you want to do> (list, find, add, quit)
      action = get_action

    #   do that action
      result = do_action(action)
    end

    # conclusion
    conclusion
  end

  def welcome
    puts "\n\n***Welcome to the food finder***\n\n"
    puts "This is an interactive guide to help you decide what to eat.\n\n"
    puts "what would you like to do?\n\n"
  end

  def get_action
    action = nil

    # Keep asking for input until get get something valid
    until Guide::Config.actions.include?(action) if action
      puts "Actions: " + Guide::Config.actions.join(", ")
      print "> "
      user_responce = gets.chomp
      action = user_responce.downcase.strip
    end
    action
  end

  def do_action(action)
    case action
      when 'list'
        puts "Listing..."
      when 'find'
        puts "Finding..."
      when 'add'
        puts "Adding..."
      when 'quit'
        return :quit
    end

  end

  def conclusion
    puts "\nThanks for stopping by!\n\n"
  end

end

