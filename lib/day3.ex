defmodule Day3 do
  def file_to_list do
    File.stream!("data/day3.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  @spec create_columns_from_row(binary()) :: [binary()]
  def create_columns_from_row(row) do
    String.split(row, "", trim: true)
  end

  @spec break_input_to_matrix([binary()]) :: list()
  def break_input_to_matrix(one_dimensional_list) do
    Enum.map(one_dimensional_list, &create_columns_from_row/1)
  end

  @spec retrieve_coordinate([[binary()]], {integer(), integer()}) :: binary()
  def retrieve_coordinate(list, {x, y}) do
    # I want to specify coords as not zero-indexed
    # so we account for that here
    # y first because of how the one-d arrays come in from the file
    Enum.at(list, y - 1)
    |> Enum.at(x - 1)
  end

  @spec coordinates_to_check_collision({binary(), binary()}) :: list()
  def coordinates_to_check_collision({x, y}) do
    x = String.to_integer(x)
    y = String.to_integer(y)
    x_coords = [x - 1, x, x + 1]
    y_coords = [y - 1, y, y + 1]

    for x <- x_coords, y <- y_coords, do: {x, y}
  end
end
