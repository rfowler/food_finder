### Food Finder ###
#
# Launch this from command line to start.
#

APP_ROOT = File.dirname(__FILE__)

$:.unshift(APP_ROOT)
require 'guide'

guide = Guide.new('restaurants.txt')
guide.launch

