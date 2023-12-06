defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "it returns the game id" do
    assert Day2.get_game_id("Game 1: 2 blue, 3 red") == 1
  end

  test "it finds each round in a game" do
    game = "Game 1: 2 red, 3 blue; 4 red, 2 blue, 6 green"
    assert Day2.get_rounds_list(game) == ["2 red, 3 blue", "4 red, 2 blue, 6 green"]
  end

  test "it makes a list from a color string" do
    assert Day2.make_color("10 blue") == ["10", "blue"]
  end

  test "each round is parsed into a struct" do
    rounds = "4 red, 2 blue, 6 green"
    assert Day2.parse_rounds(rounds) == %Day2.Round{red: 4, blue: 2, green: 6}
  end

  test "it turns a line into a Game struct w nested Round structs" do
    game =
      "Game 1: 9 red, 2 green, 13 blue; 10 blue, 2 green, 13 red; 8 blue, 3 red, 6 green; 5 green, 2 red, 1 blue"

    assert Day2.parse_game(game) == %Day2.Game{
             id: 1,
             rounds: [
               %Day2.Round{red: 9, blue: 13, green: 2},
               %Day2.Round{red: 13, blue: 10, green: 2},
               %Day2.Round{red: 3, blue: 8, green: 6},
               %Day2.Round{red: 2, blue: 1, green: 5}
             ]
           }
  end

  test "a round can determine if it is possible" do
    # @blue_cubes 14
    # @red_cubes 12
    # @green_cubes 13
    round = %Day2.Round{red: 9, blue: 13, green: 2}
    round2 = %Day2.Round{red: 13, blue: 13, green: 2}
    round3 = %Day2.Round{red: 9, blue: 15, green: 2}
    round4 = %Day2.Round{red: 9, blue: 13, green: 14}
    assert Day2.Round.possible?(round) == true
    assert Day2.Round.possible?(round2) == false
    assert Day2.Round.possible?(round3) == false
    assert Day2.Round.possible?(round4) == false
  end

  test "a game is only possible when all its rounds are possible" do
    game = %Day2.Game{
      id: 1,
      rounds: [
        %Day2.Round{red: 9, blue: 13, green: 2},
        # red 13 here makes it not possible
        %Day2.Round{red: 13, blue: 10, green: 2},
        %Day2.Round{red: 3, blue: 8, green: 6},
        %Day2.Round{red: 2, blue: 1, green: 5}
      ]
    }

    assert Day2.Game.possible?(game) == false

    game2 = %Day2.Game{
      id: 2,
      rounds: [
        %Day2.Round{red: 9, blue: 13, green: 2},
        %Day2.Round{red: 12, blue: 10, green: 2},
        %Day2.Round{red: 3, blue: 8, green: 6},
        %Day2.Round{red: 2, blue: 1, green: 5}
      ]
    }

    assert Day2.Game.possible?(game2) == true
  end

  test "a game can find the max nums for each dice color" do
    game = %Day2.Game{
      id: 2,
      rounds: [
        %Day2.Round{red: 9, blue: 13, green: 2},
        %Day2.Round{red: 12, blue: 10, green: 2},
        %Day2.Round{red: 3, blue: 8, green: 6},
        %Day2.Round{red: 2, blue: 1, green: 5}
      ]
    }

    assert Day2.Game.get_maxes(game) == %{
             red: 12,
             blue: 13,
             green: 6
           }
  end

  test "a game can find the power of max dice" do
    game = %Day2.Game{
      id: 1,
      maxs: %{
        red: 12,
        blue: 13,
        green: 6
      },
      rounds: [
        %Day2.Round{red: 9, blue: 13, green: 2},
        %Day2.Round{red: 12, blue: 10, green: 2},
        %Day2.Round{red: 3, blue: 8, green: 6},
        %Day2.Round{red: 2, blue: 1, green: 5}
      ]
    }

    assert Day2.Game.pow_of_max(game) == 12 * 13 * 6
  end

  test "a game can save the max values to itself" do
    game = %Day2.Game{
      id: 2,
      rounds: [
        %Day2.Round{red: 9, blue: 13, green: 2},
        %Day2.Round{red: 12, blue: 10, green: 2},
        %Day2.Round{red: 3, blue: 8, green: 6},
        %Day2.Round{red: 2, blue: 1, green: 5}
      ]
    }

    assert Day2.Game.save_maxes(game) == %Day2.Game{
             id: 2,
             maxs: %{
               red: 12,
               blue: 13,
               green: 6
             },
             rounds: [
               %Day2.Round{red: 9, blue: 13, green: 2},
               %Day2.Round{red: 12, blue: 10, green: 2},
               %Day2.Round{red: 3, blue: 8, green: 6},
               %Day2.Round{red: 2, blue: 1, green: 5}
             ]
           }
  end

  test "it sums the IDs of all possible games with run" do
    games_list = [
      # false
      "Game 1: 9 red, 2 green, 13 blue; 10 blue, 2 green, 13 red; 8 blue, 3 red, 6 green; 5 green, 2 red, 1 blue",
      # false
      "Game 2: 2 green, 2 blue, 16 red; 14 red; 13 red, 13 green, 2 blue; 7 red, 7 green, 2 blue",
      # true
      "Game 3: 6 red, 4 green, 7 blue; 7 blue, 9 red, 3 green; 2 red, 4 green; 6 red, 2 blue; 7 blue, 9 red, 5 green"
    ]

    assert Day2.run(games_list) == 3

    games_list2 = [
      # false
      "Game 1: 9 red, 2 green, 13 blue; 10 blue, 2 green, 13 red; 8 blue, 3 red, 6 green; 5 green, 2 red, 1 blue",
      # true
      "Game 2: 2 green, 2 blue, 12 red; 12 red; 12 red, 13 green, 2 blue; 7 red, 7 green, 2 blue",
      # true
      "Game 3: 6 red, 4 green, 7 blue; 7 blue, 9 red, 3 green; 2 red, 4 green; 6 red, 2 blue; 7 blue, 9 red, 5 green"
    ]

    assert Day2.run(games_list2) == 5
  end

  test "run part 2 finds sum of power of max dice" do
    games_list = [
      # 13 red, 13 blue, 6 green = 1014
      "Game 1: 9 red, 2 green, 13 blue; 10 blue, 2 green, 13 red; 8 blue, 3 red, 6 green; 5 green, 2 red, 1 blue",
      # 12 red, 2 blue, 13 green = 312
      "Game 2: 2 green, 2 blue, 12 red; 12 red; 12 red, 13 green, 2 blue; 7 red, 7 green, 2 blue",
      # 9 red, 7 blue, 5 green = 315
      "Game 3: 6 red, 4 green, 7 blue; 7 blue, 9 red, 3 green; 2 red, 4 green; 6 red, 2 blue; 7 blue, 9 red, 5 green"
    ]

    assert Day2.run_part_2(games_list) == 1014 + 312 + 315
  end
end
