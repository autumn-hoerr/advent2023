defmodule Day1 do
  @moduledoc """
  Documentation for `Day1`.
  """
  @regex ~r/(\d).*/

  def file_to_list do
    File.stream!("data/day1.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  def get_first_num(str) do
    Regex.run(@regex, str)
    |> Enum.at(1)
  end

  def get_last_num(str) do
    reversed = String.reverse(str)

    @regex
    |> Regex.run(reversed)
    |> Enum.at(1)
  end

  def get_num_from_string(str) do
    "#{get_first_num(str)}#{get_last_num(str)}"
    |> String.to_integer()
  end

  def replace_text_nums(str) do
    str
    |> String.replace("oneight", "18")
    |> String.replace("sevenine", "79")
    |> String.replace("eightwo", "82")
    |> String.replace("eighthree", "83")
    |> String.replace("threeight", "38")
    |> String.replace("nineight", "98")
    |> String.replace("twone", "21")
    |> String.replace("one", "1")
    |> String.replace("two", "2")
    |> String.replace("three", "3")
    |> String.replace("four", "4")
    |> String.replace("five", "5")
    |> String.replace("six", "6")
    |> String.replace("seven", "7")
    |> String.replace("eight", "8")
    |> String.replace("nine", "9")
  end

  def run(list) do
    list
    |> Enum.map(fn x -> replace_text_nums(x) end)
    |> Enum.map(fn x -> get_num_from_string(x) end)
    |> Enum.sum()
  end
end
