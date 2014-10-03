require 'pry'
require 'awesome_print'

MAP_HEIGHT = 100
MAP_WIDTH = 100

CELL_WIDTH = 10
CELL_HEIGHT = 10

SCREEN_HEIGHT = MAP_HEIGHT * CELL_HEIGHT
SCREEN_WIDTH = MAP_WIDTH * CELL_WIDTH

def seed_map(width, height)
  ret = []
  height.times do
    ret << []
    width.times do
      ret[-1] << rand(2)
    end
  end   
  return ret 
end

def find_neighbours(cell_x,cell_y)
  neighbours = [
    [-1, 1],[0, 1],[1, 1],
    [-1, 0],       [1, 0],
    [-1,-1],[0,-1],[1,-1]
  ]

  binding.pry

  neighbours.map do |mod_x,mod_y|
    ret = 0
    x = cell_x + mod_x
    y = cell_y + mod_y
    ret = @map[cell_y + mod_y][cell_x + mod_x] if coords_in_range?(x,y)
  end

end

def coords_in_range?(x, y)
  (x >= 0 && y >= 0) && (x < MAP_WIDTH && y < MAP_HEIGHT)
end


small_map = [
  [ 1, 2, 3, 4, 5],
  [ 6, 7, 8, 9,10],
  [11,12,13,14,15],
  [16,17,18,19,20],
  [21,22,23,24,25]
]

@map=seed_map MAP_WIDTH,MAP_HEIGHT
binding.pry
"bla"