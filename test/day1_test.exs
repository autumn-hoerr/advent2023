defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "get_first_num finds first digit in string" do
    assert Day1.get_first_num("abc123mnb") == "1"
  end

  test "get_last_num finds last digit in string" do
    assert Day1.get_last_num("kjh123yui") == "3"
  end

  test "get_num_from_string converts string to integer" do
    assert Day1.get_num_from_string("123") == 13
  end

  test "replace text nums changes digits in string" do
    assert Day1.replace_text_nums("one") == "1"
    assert Day1.replace_text_nums("two") == "2"
    assert Day1.replace_text_nums("three") == "3"
    assert Day1.replace_text_nums("four") == "4"
    assert Day1.replace_text_nums("five") == "5"
    assert Day1.replace_text_nums("six") == "6"
    assert Day1.replace_text_nums("seven") == "7"
    assert Day1.replace_text_nums("eight") == "8"
    assert Day1.replace_text_nums("nine") == "9"
    assert Day1.replace_text_nums("abconetwo34abthree78abc") == "abc1234ab378abc"
  end

  test "the output of replace can be piped to get num from string" do
    assert Day1.replace_text_nums("one") |> Day1.get_num_from_string() == 11
    assert Day1.replace_text_nums("abconetwo34abthree78abc") |> Day1.get_num_from_string() == 18
  end

  test "run takes a list and does the thing" do
    testlist = [
      # 13
      "abc123lkj",
      # 81
      "oneight987askjdhasd321",
      # 32
      "yoiun3249two",
      # 22
      "vhpttjh2"
    ]

    assert Day1.run(testlist) == 13 + 11 + 32 + 22
  end
end
