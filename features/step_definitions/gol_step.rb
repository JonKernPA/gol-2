class Output
  def messages
    @messages ||= []
  end
  def puts(message)
    messages << message
  end
end
def output
  @output ||= Output.new
end


Given /^Cell is alive$/ do
  @cell = GameOfLife::Cell.new
  @cell.alive?.should == true
end

And /^Cell has "([^\"]*)" neighbors$/ do |n|
  n.to_i.times do
    @cell.neighbors << GameOfLife::Cell.new
  end
end

When /^I go to the next generation$/ do
  @cell.apoptosis
end

Then /^Cell should be dead$/ do
  @cell.alive?.should == false
end

#     Scenario: Cell survives to the next generation
Then /^Cell should be alive$/ do
  @cell.alive?.should == true
end

#   Scenario: Empty cell has a birth
Given /^Cell is dead$/ do
  @cell = GameOfLife::Cell.new GameOfLife::Cell::DEAD
end

# Scenario: Start Life
When /^I start the game$/ do
  @game = GameOfLife::Gol.new(output)
  @game.start(10)
end

Then /^I should see "([^\"]*)"$/ do |msg|
  output.messages.should include(msg)
end

And /^I should see: "([^\"]*)"$/ do |msg|
  output.messages.should include(msg)
end
And /^I should see menu: "([^\"]*)"$/ do |msg|
  output.messages.should include(msg)
end


