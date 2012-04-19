require "restaurant"
require "support/string_extend"

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
      action, args = get_action

    #   do that action
      result = do_action(action, args)
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
    args = nil
    # Keep asking for input until get get something valid
    until Guide::Config.actions.include?(action)
      puts "Actions: " + Guide::Config.actions.join(", ") if action
      print "> "
      user_responce = gets.chomp
      args = user_responce.downcase.strip.split(' ')
      action = args.shift
    end
    return action, args
  end

  def do_action(action, args=[])
    case action
      when 'list'
        list(args)
      when 'find'
        keyword = args.shift
        find(keyword)
      when 'add'
        add
      when 'quit'
        return :quit
    end

  end

  def list(args=[])
    sort_order = args.shift
    sort_order = args.shift if sort_order == 'by'
    sort_order ||= "name"
    sort_order = "name" unless ['name', 'cuisine', 'price'].include?(sort_order)

    output_action_header("Restaurant List")

    restaurants = Restaurant.saved_restaurants
    restaurants.sort! do |r1, r2|
      case sort_order
        when 'name'
          r1.name.downcase <=> r2.name.downcase
        when 'cuisine'
          r1.cuisine.downcase <=> r2.cuisine.downcase
        when 'price'
          r1.price.to_i <=> r2.price.to_i
      end
    end
    output_action_table(restaurants)
    puts "Sort using; 'list cuisine', 'list price', 'list price', 'list by #'\n\n"
  end

  def find(keyword="")
    output_action_header("Find a restaurant")
    if keyword
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |rest|
        rest.name.downcase.include?(keyword.downcase) ||
        rest.cuisine.downcase.include?(keyword.downcase) ||
        rest.rating.downcase.include?(keyword.downcase) ||
        rest.price.to_i <= keyword.to_i
      end
      output_action_table(found)
    else
      puts "Find using a key phrase to search the restaurant"
      puts "Example: 'find chipotle', 'find Mexican'\n\n"
    end
  end

  def add
    output_action_header("Add a new restaurant")

    restaurant = Restaurant.build_with_questions

    if restaurant.save
       puts "\nRestaurant Added\n\n"
    else
      puts "\nSave error: restaurant not added\n\n"
    end
  end

  def conclusion
    output_action_header("Thanks for stopping by!")
  end

  private

  def output_action_header(text)
    puts "\n#{text.upcase.center(75)}\n\n"
  end

  def output_action_table(restaurants=[])
    print "" + "Name".ljust(30)
    print " " + "Cuisine".ljust(20)
    print " " + "Rating".ljust(6)
    print " " + "Distance".rjust(8)
    print " " + "Price".rjust(7) + "\n"
    puts "-" * 75

    restaurants.each do |rest|
      line = "" << rest.name.titleize.ljust(30)
      line << " " + rest.cuisine.titleize.ljust(20)
      line << " " + rest.rating.ljust(6)
      line << " " + rest.formatted_distance.rjust(8)
      line << " " + rest.formatted_price.rjust(7)
      puts line
    end
    puts "No restaurants found" if restaurants.empty?
    puts "-" * 75
  end

end
