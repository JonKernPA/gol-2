require 'spec_helper'

module GameOfLife
  describe Gol do
    let(:output) {double('output').as_null_object}
    let(:game)   do
      Gol.new(output)
    end

    describe "#start" do
#      before(:each) do
#        @output = double('output').as_null_object
#        @game = Gol.new(@output)
#      end

      it "sends a welcome message" do
        output.should_receive(:puts).with('Welcome to GOL')
        game.start
      end

      it "prompts for board size" do
        output.should_receive(:puts).with('Enter Board Size: ')
        game.start
      end
    end

    describe "#randomize" do
      it "will prepopulate the grid with a random mix of live and dead cells" do
        game.start(10)
        game.display.should include('|*|')
        game.display.should include('| |')
      end
    end

    describe "#display" do
      it "outputs a text grid" do
        game.start(10)
        game.display.should include('|*|')
      end
    end

    describe "#generation" do
      it "runs through each cell and asks for its next generation" do
        game.start
        gen_1 = game.display
        game.generation
        gen_2 = game.display
        gen_2.should_not == gen_1
      end
    end

    describe "#live_cells" do
      it "should return all of the live cells on the board" do
        game.start
        game.live_count.should > 0
      end
    end

    describe "#live_count" do
      it "should return the number of live cells neighboring me" do
        cells = [
                [Cell.new(1),Cell.new(0),Cell.new(0)],
                [Cell.new(0),Cell.new(1),Cell.new(1)],
                [Cell.new(0),Cell.new(0),Cell.new(0)]
        ]
        Cell.set_neighbors(cells)
        cells[0][0].live_count.should == 1
        cells[0][1].live_count.should == 3
        cells[0][2].live_count.should == 2

        cells[1][0].live_count.should == 2
        cells[1][1].live_count.should == 2
        cells[1][2].live_count.should == 1

        cells[2][0].live_count.should == 1
        cells[2][1].live_count.should == 2
        cells[2][2].live_count.should == 2
      end
    end

    describe "#dead_count" do
      it "should return the number of dead cells neighboring me" do
        cells = [
                [Cell.new(1),Cell.new(0),Cell.new(0)],
                [Cell.new(0),Cell.new(1),Cell.new(1)],
                [Cell.new(0),Cell.new(0),Cell.new(0)]
        ]
        Cell.set_neighbors(cells)
        cells[0][0].dead_count.should == 2
        cells[0][1].dead_count.should == 2
        cells[0][2].dead_count.should == 1

        cells[1][0].dead_count.should == 3
        cells[1][1].dead_count.should == 6
        cells[1][2].dead_count.should == 4

        cells[2][0].dead_count.should == 2
        cells[2][1].dead_count.should == 3
        cells[2][2].dead_count.should == 1
      end
    end

    describe "#simulate" do
      it "should run through a certain number of generations" do
        game.start
        gen_1 = game.display
        game.simulate(1)
        gen_2 = game.display
        gen_2.should_not == gen_1
      end
    end
  end
end