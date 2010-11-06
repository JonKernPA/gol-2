Feature: The Game Of Life 
GOL is visualized in a 2D matrix, known colloquially as a "Board"
Each cell in the board represents a cell in the game. The board starts out with
a random population. Each new generation allows for some cells to live on and others
to die off.


  Scenario: Start the Game of Life
    When I start the game
    Then I should see "Welcome to GOL"
    And I should see: "Enter Board Size: "
    And I should see menu: "Command Menu: S - Start, E - End"

  Scenario: submit size
    Given a new started game
    And I enter a board of size = "10"
    Then I should see a grid of "13" by "10"

  Scenario: populate the world
    Given a new started game
    Then some cells should be populated

  Scenario: run a generation
    Given a new started game
    And a generation occurs
    Then I should see a different population

  Scenario: simulating multiple generations
    Given a new started game
    When I enter menu choice "S"
    Then I should see a different population
    