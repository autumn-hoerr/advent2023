defmodule Day2.Round do
  defstruct(
    red: 0,
    blue: 0,
    green: 0
  )

  @blue_cubes 14
  @red_cubes 12
  @green_cubes 13
  def possible?(%Day2.Round{red: red, blue: blue, green: green}) do
    red <= @red_cubes && blue <= @blue_cubes && green <= @green_cubes
  end
end

defmodule Day2.Game do
  alias Day2.Round

  defstruct(
    id: nil,
    rounds: [],
    maxs: %{
      red: 0,
      blue: 0,
      green: 0
    },
    p?: false
  )

  def possible?(%Day2.Game{rounds: rounds}) do
    Enum.all?(rounds, &Round.possible?/1)
  end

  def get_maxes(%Day2.Game{rounds: rounds, maxs: maxs}) do
    Enum.reduce(rounds, maxs, fn x, acc ->
      %{
        acc
        | red: max(x.red, acc.red),
          blue: max(x.blue, acc.blue),
          green: max(x.green, acc.green)
      }
    end)
  end

  def save_maxes(game) do
    Map.put(game, :maxs, get_maxes(game))
  end

  def pow_of_max(%Day2.Game{maxs: %{red: red_max, blue: blue_max, green: green_max}}) do
    red_max * blue_max * green_max
  end
end

defmodule Day2 do
  alias Day2.Round
  alias Day2.Game

  def file_to_list do
    File.stream!("data/day2.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def get_game_id(str) do
    str
    |> String.split("Game ")
    |> Enum.at(1)
    |> String.split(":")
    |> Enum.at(0)
    |> String.to_integer()
  end

  def get_rounds_list(str) do
    # Game 1: 9 red, 2 green, 13 blue; 10 blue, 2 green, 13 red; 8 blue, 3 red, 6 green; 5 green, 2 red, 1 blue
    str
    |> String.split(":")
    |> Enum.at(1)
    |> String.split(";")
    |> Enum.map(&String.trim/1)
  end

  def make_color(raw_color) do
    # ["10", "blue"]
    String.split(raw_color, " ")
  end

  def parse_rounds(raw_round) do
    # 10 blue, 2 green, 13 red
    round = %Round{}

    raw_round
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(round, fn x, acc ->
      colormap = make_color(x)
      # TODO: this is ugly
      Map.put(acc, String.to_atom(Enum.at(colormap, 1)), String.to_integer(Enum.at(colormap, 0)))
    end)
  end

  def parse_game(raw_game) do
    %Game{
      id: get_game_id(raw_game),
      rounds: Enum.map(get_rounds_list(raw_game), &parse_rounds/1)
    }
  end

  def get_maxs(game) do
    game.rounds
    |> Enum.reduce(game.maxs, fn x, acc ->
      %{
        red: max(x.red, acc.red),
        blue: max(x.blue, acc.blue),
        green: max(x.green, acc.green)
      }
    end)
  end

  def find_possible_games(games) do
    Enum.filter(games, &Game.possible?/1)
  end

  def run(list) do
    list
    |> Enum.map(&parse_game/1)
    |> find_possible_games()
    |> Enum.reduce(0, fn x, acc -> acc + x.id end)
  end

  def run_part_2(list) do
    list
    |> Enum.map(&parse_game/1)
    |> Enum.map(&Game.save_maxes/1)
    |> Enum.map(&Game.pow_of_max/1)
    |> Enum.sum()
  end

  def go() do
    file_to_list()
    |> run()
    |> IO.inspect()
  end

  def gp2() do
    file_to_list()
    |> run_part_2()
    |> IO.inspect()
  end
end
