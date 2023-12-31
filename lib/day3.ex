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
    Enum.reverse(one_dimensional_list)
    |> Enum.map(&create_columns_from_row/1)
  end

  # for now, I'm going to assume that if x is a string, y is also a string.
  def retrieve_coordinate(list, {x, y}) when is_binary(x) do
    retrieve_coordinate(list, {String.to_integer(x), String.to_integer(y)})
  end

  @spec retrieve_coordinate([[binary()]], {integer(), integer()}) :: binary()
  def retrieve_coordinate(list, {x, y}) when is_integer(x) do
    # I want to specify coords as not zero-indexed
    # so we account for that here
    # y first because of how the one-d arrays come in from the file
    Enum.at(list, y - 1)
    |> Enum.at(x - 1)
  end

  def coordinate_to_check_collision({x, y}) when is_binary(x) do
    x = String.to_integer(x)
    y = String.to_integer(y)
    coordinate_to_check_collision({x, y})
  end

  @distance_to_search 1
  def coordinates_to_check_collision({x, y}) when is_integer(x) do
    range_to_search = Enum.to_list((@distance_to_search * -1)..@distance_to_search)

    x_coords = Enum.map(range_to_search, fn r -> x + r end)
    y_coords = Enum.map(range_to_search, fn r -> y + r end)

    # filter out the original coordinates. We should know that's a symbol already.
    for lx <- x_coords, ly <- y_coords, {x, y} != {lx, ly}, do: {lx, ly}
  end

  def find_collisions_from_coordinate(list, {x, y}) do
    coordinates_to_check_collision({x, y})
    |> Enum.filter(fn x -> retrieve_coordinate(list, x) != "." end)
    |> List.delete(x)
  end
end
