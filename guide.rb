require 'restaurant'

class Guide

  def initialize(path=nil)
    # locate the restaurant text file at path
    Restaurant.filepath = path
    if Restaurant.file_exists?
      puts "Found restaurant file"
    
    # or create file
    elseif Restaurant.create_file
      puts "No file detected, creating new file"
    
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
    #   what do you want to do> (list, find, add, quit)
    #   do thst action
    # repeat until user quits


    # conclusion
    conclusion
  end

  def welcome
    puts "\n\n***Welcome to the food finder***\n\n"
    puts "This is an interactive guide to help you decide what to eat.\n\n"
    puts "what would you like to do?\n\n"
  end

  def conclusion
    puts "\nThanks for stopping by!\n\n"
  end

end

