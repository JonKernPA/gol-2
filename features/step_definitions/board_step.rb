Given /^a new game$/ do
  @game = GameOfLife::Gol.new(output)
end

When /^I enter a board of size = "([^\"]*)"$/ do |size|
  @game.start(size)
end

Then /^I should see a grid of "([^\"]*)" by "([^\"]*)"$/ do |x, y|
  text = @game.display
  @generation = text
  dead = text.split(" |").size
  live = text.split("*|").size
  (dead+live).should == x.to_i*y.to_i + 2
end

# Scenario: show the user a menu
Given /^a new started game$/ do
  Given "a new game"
  When "I start the game"

end


# Scenario: populate the world
Then /^some cells should be populated$/ do
  @game.display.should include('*')
end

# Scenario: run a generation
When /^a generation occurs$/ do
  @game.generation

end

Then /^I should see a different population$/ do
  new_generation = @game.display
  new_generation.should_not == @generation
end

# Scenario: simulating multiple generations
When /^I enter menu choice "([^\"]*)"$/ do |menu_item|
  case menu_item
    when "S"
      @game.simulate(2)
    else
      puts "UNKNOWN Menu choice"
  end

end

Then /^it should run through generations$/ do
  pending # express the regexp above with the code you wish you had
end
