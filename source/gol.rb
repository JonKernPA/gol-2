require 'cell'
#require 'readline'

module GameOfLife

  class Gol

    def initialize(output)
      srand
      @width = @height = 10
      @output = output
      @output.puts "Welcome to GOL"
      @output.puts "Enter Board Size: "
#      size = gets.chomp.to_i
#      if size != nil
#      else
#        size = 10
#      end
    end

    def create_world
      puts "Creating world #{@width} by #{@height}"
      @cells = Cell.randomize(@width, @height)
    end

    def display
      text = "\n" << '__'*@width << "\n"
      for i in 0...@height
        for j in 0...@width
          text << "|" << @cells[i][j].to_s
        end
        text << "|\n"
      end
      text = text << '__'*@width << "\n"
      return text
    end

    def start(size = 10)
      @width = size.to_i * 4 / 3
      @height = size.to_i
      create_world
      puts display
      @output.puts "Command Menu: S - Start, E - End"
    end

    def live_cells
      live = []
      0.upto(@height-1) do |x|
        0.upto(@width-1) do |y|
          cell = @cells[x][y]
          live << cell if cell.alive?
        end
      end
      return live
    end

    def generation
      @cells.each do |arr|
        arr.each do |c|
          c.apoptosis
        end
      end
    end

    def simulate(num_gens = 200)
      @max_generations = num_gens

      counter = 0
      static_world = 0
      population = live_cells.size
      old_world = display
      loop do
        counter += 1
        break if quit? || counter > @max_generations
        puts "Generation #{counter} alive: #{population}"

        # get new world
        generation
        new_world = display
        puts new_world
        if old_world == new_world then
          static_world += 1
          if static_world > 4 then
            puts "World is static"
            break
          end
        end
        old_world = new_world
        sleep (0.5)
      end

      puts "Oh, I quit."

    end

    private
    def quit?
      begin
        # See if a 'E has been typed yet
        while c = STDIN.read_nonblock(1)
          puts "I found a #{c}"
          return true if c == 'E'
        end
        # No 'Q' found
        false
      rescue Errno::EINTR
        puts "Well, your device seems a little slow..."
        false
      rescue Errno::EAGAIN
        # nothing was ready to be read
        #puts "Nothing to be read..."
        false
      rescue EOFError
        # quit on the end of the input stream
        # (user hit CTRL-D)
        puts "Who hit CTRL-D, really?"
        true
      end
    end


  end
end


game = GameOfLife::Gol.new(STDOUT)
game.start
#game.simulate
