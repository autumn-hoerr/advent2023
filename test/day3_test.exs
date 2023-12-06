defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "create columns from a string" do
    string = "abc"
    assert Day3.create_columns_from_row(string) == ["a", "b", "c"]
  end

  test "break to matrix creates a 2d array from a 1d array" do
    arr = [
      "abc",
      "123",
      "xyz"
    ]

    assert Day3.break_input_to_matrix(arr) == [["a", "b", "c"], ["1", "2", "3"], ["x", "y", "z"]]
  end

  test "it can retrieve a given coordinate" do
    arr = [
      "abc",
      "123",
      "xyz"
    ]

    matrix = Day3.break_input_to_matrix(arr)
    assert Day3.retrieve_coordinate(matrix, {1, 1}) == "a"
    assert Day3.retrieve_coordinate(matrix, {2, 2}) == "2"
    assert Day3.retrieve_coordinate(matrix, {"2", "2"}) == "2"
  end

  test "it assembles a list of coordinate to check collision on" do
    assert Day3.coordinates_to_check_collision({1, 1}) == [
             {0, 0},
             {0, 1},
             {0, 2},
             {1, 0},
             {1, 2},
             {2, 0},
             {2, 1},
             {2, 2}
           ]
  end

  test "it can compute where there are things around a 'symbol'" do
    arr = [
      "..1",
      ".#2",
      "3.."
    ]

    matrix = Day3.break_input_to_matrix(arr)
    assert Day3.find_collisions_from_coordinate(matrix, {2, 2}) == [{1, 1}, {3, 2}, {3, 3}]
  end
end
