MAP_HEIGHT = 25
MAP_WIDTH = 50

TOTAL_CELLS = MAP_HEIGHT * MAP_WIDTH

CELL_WIDTH = 10
CELL_HEIGHT = 10

PADDING = 10

CTRL_HEIGHT = 200
CTRL_WIDTH = MAP_WIDTH * CELL_WIDTH

SCREEN_HEIGHT = MAP_HEIGHT * CELL_HEIGHT
SCREEN_WIDTH = CTRL_WIDTH

WINDOW_WIDTH = SCREEN_WIDTH + PADDING * 2
WINDOW_HEIGHT = SCREEN_HEIGHT + CTRL_HEIGHT + PADDING * 2

Shoes.app :width => WINDOW_WIDTH, :height => WINDOW_HEIGHT, :resizable => true do

  def seed_map(width, height)
    ret = []
    height.times do
      ret << []
      width.times do
        ret[-1] << {alive: rand(2), rect: nil}
      end
    end
    return ret
  end

  def draw_screen
    @map.size.times do |i|
      @map[0].size.times do |j|
        cell = @map[i][j]
        if r = cell[:rect] then
          new_style = r.style.dup
          if cell[:alive] == 1 then
            new_style[:fill] = black
          else
            new_style[:fill] = white
          end
          r.style new_style
        else

          stroke black
          if cell[:alive] == 1 then
            fill black
          else
            fill white
          end
          cell[:rect] = rect top: i*CELL_HEIGHT,
                             left: j*CELL_WIDTH,
                             width: CELL_WIDTH,
                             height: CELL_HEIGHT
        end
      end
    end
  end

  def count_alive_neighbours(cell_x,cell_y)
    neighbours = [
      [-1, 1],[0, 1],[1, 1],
      [-1, 0],       [1, 0],
      [-1,-1],[0,-1],[1,-1]
    ]

    neighbours.map do |mod_x,mod_y|
      x = cell_x + mod_x
      y = cell_y + mod_y
      if coords_in_range?(x,y)
        @map[y][x][:alive]
      else
        0
      end
    end.inject(0,:+)
  end

  def live(cell_x,cell_y)
    alive_neighbours = count_alive_neighbours cell_x,cell_y
    cell_alive = @map[cell_y][cell_x][:alive]
    if cell_alive == 1 then
      #CELL IS ALIVE
      case
      when alive_neighbours < 2
        #Dies
        @map[cell_y][cell_x][:alive] = 0
      when (2..3).cover?(alive_neighbours)
        #Lives on
      when alive_neighbours > 3
        #Dies
        @map[cell_y][cell_x][:alive] = 0
      end
    else
      #CELL IS DEAD
      if alive_neighbours == 3 then
        #Revive
        @map[cell_y][cell_x][:alive] = 1
        cell_alive = 1
      end
    end
    cell_alive
  end

  def update_life
    width = @map[0].size
    height = @map.size
    @alive = 0
    height.times do |i|
      width.times do |j|
        @alive += live(j,i)
      end
    end

  end

  def update_info(t_life,t_draw)
    total = TOTAL_CELLS
    @info_para.text = "#{MAP_WIDTH}x#{MAP_HEIGHT}\nAlive : #{@alive}/#{total - @alive} (#{total})\nt_life: #{t_life}\nt_draw: #{t_draw}"

  end

  def coords_in_range?(x, y)
    (x >= 0 && y >= 0) && (x < MAP_WIDTH && y < MAP_HEIGHT)
  end

  def step
    t_life = Time.now
    update_life
    t_life = Time.now - t_life
    t_draw = Time.now
    draw_screen
    t_draw = Time.now - t_draw
    update_info t_life, t_draw
  end

  @map = seed_map(MAP_WIDTH, MAP_HEIGHT)
  @alive = 0
  #stack(width: WINDOW_WIDTH, height: WINDOW_HEIGHT,top: PADDING, left: PADDING) do
  flow(top: PADDING, left: PADDING) do
    @main_stack = stack(width: SCREEN_WIDTH, height: SCREEN_HEIGHT) do
      draw_screen
    end
    #@control_stack = flow(width: CTRL_WIDTH, height: CTRL_HEIGHT) do
    @control_stack = stack do
      @info_para = para "#{MAP_WIDTH}x#{MAP_HEIGHT}\nAlive : #{@alive}/#{TOTAL_CELLS - @alive} (#{TOTAL_CELLS})\nTime used: n/A"
      button "Step" do
        step
      end
      button "Restart" do
        @map = seed_map MAP_WIDTH, MAP_HEIGHT
        draw_screen
      end
      button "Cycle" do
        if not @timer then
          @timer = every(0.5) do
            step
          end
        else
          @timer.start
        end
      end
      button "Stop" do
        @timer.stop if @timer
      end
    end
  end
end
