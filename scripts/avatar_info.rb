#!ruby

require 'chunky_png'
require 'pp'

file = '_my_avatar.png'

# Accessing metadata
image = ChunkyPNG::Image.from_file file

pp image.metadata
