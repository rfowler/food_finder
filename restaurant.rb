require 'support/number_helper'
class Restaurant
  include NumberHelper

  @@filepath = nil

  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT, path)
  end

  attr_accessor :name, :cuisine, :price, :distance, :rating

  def self.file_exists?
    # class should know if file exists
    if @@filepath && File.exists?(@@filepath)
      return true
    else
      return false
    end
  end

  def self.file_usable?
    return false unless @@filepath
    return false unless File.exists?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end

  def self.create_file
    # create the restaurant file
    File.open(@@filepath, 'w') unless file_exists?
    return file_usable?
  end

  def self.saved_restaurants
    restaurants = []
    if file_usable?
      file = File.new(@@filepath, 'r')
      file.each_line do |line|
        restaurants << Restaurant.new.import_line(line.chomp)
      end
      file.close
    end
    return restaurants
  end

  def self.build_with_questions
    args = {}

    print "Restaurant Name: "
    args[:name] = gets.chomp.strip

    print "Cuisine: "
    args[:cuisine] = gets.chomp.strip

    print "Average Price: "
    args[:price] = gets.chomp.strip

    print "Distance: "
    args[:distance] = gets.chomp.strip

    print "Rating: "
    args[:rating] = gets.chomp.strip

    return self.new(args)
  end

  def initialize(args={})
    @name     = args[:name]     || ""
    @cuisine  = args[:cuisine]  || ""
    @price    = args[:price]    || ""
    @distance = args[:distance] || ""
    @rating   = args[:rating]   || ""
  end

  def import_line(line)
    line_array = line.split("\t")
    @name, @cuisine, @price, @distance, @rating = line_array
    self
  end

  def save
    return false unless Restaurant.file_usable?
    File.open(@@filepath, 'a') do |file|
      file.puts "#{[@name, @cuisine, @price, @distance, @rating].join("\t")}\n"
    end
    true
  end

  def formatted_price
    number_to_currency(@price)
  end

end