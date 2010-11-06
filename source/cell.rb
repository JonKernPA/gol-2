module GameOfLife
  class Matrix < Array
    def initialize (rows, columns)
      super(rows)
      self.each_index { |i|
        self[i] = Array.new(columns)
        self[i].each_index { |j| self[i][j] = Cell.new(rand(2)) }
      }
    end
  end

  class Cell

    STATE = [DEAD = 0, LIVE = 1]
    attr_accessor :neighbors

    def initialize state=LIVE
      @state = state
      @neighbors = []
    end

    def place(x,y)
      @x = x
      @y = y
    end

    # NW | N | NE
    # W  | * |  E
    # SW | S | SE
    def self.set_neighbors(cells)
      rows = cells.size
      cols = cells[0].size
      0.upto(rows-1) do |x|
        0.upto(cols-1) do |y|
          cell = cells[x][y]
          neighbors = []

          # Now look all around this cell for neighbors
          -1.upto(1) do |y_offset|
            -1.upto(1) do |x_offset|
              # don't do myself
              next if y_offset == 0 && x_offset == 0
              xx = x+x_offset
              yy = y+y_offset
              # don't do beyond borders
              next if xx < 0 || xx == rows || yy < 0 || yy == cols
              begin
                neighbors << cells[xx][yy]
              rescue
                puts "Cell doesn't exist at [#{xx},#{yy}]"
              end
            end
          end
          cell.neighbors = neighbors
        end
      end

    end

    def self.randomize(width, height)
#      cells = Matrix.new(rows,cols)
      cells = Array.new(height)
      0.upto(height-1) do |x|
        cells[x] = Array.new(width)
        0.upto(width-1) do |y|
          if rand(5) > 3 then
            state = LIVE
          else
            state = DEAD
          end
          new_cell = Cell.new(state)
          new_cell.place(x,y)
          cells[x][y] = new_cell
        end
      end
      self.set_neighbors(cells)
      return cells
    end

    def to_s
      if @state ==LIVE then
        '*'
      else
        ' '
      end
    end

    def alive?
      return @state == LIVE
    end

    def neighbors
      @neighbors ||= []
    end

    def live_count
      arr = @neighbors.find_all {|c| c.alive?}
      arr.size
    end

    def dead_count
      arr = @neighbors.find_all {|c| !c.alive?}
      arr.size
    end

    # Determine cell's regeneration potential, aka Programmed Cell Death
    def apoptosis
      live_neighbors = live_count
      dead_neighbors = dead_count
      if @state == LIVE then
        # 1. Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
        # 2. Any live cell with more than three live neighbours dies, as if by overcrowding.
        # 3. Any live cell with two or three live neighbours lives on to the next generation.
        if live_neighbors < 2 || live_neighbors > 3 then
          @state = DEAD
        end
      else
        # 4. Any dead cell with exactly three live neighbours becomes a live cell.
        if live_neighbors == 3
          @state = LIVE
        end
      end
    end
  end
end
