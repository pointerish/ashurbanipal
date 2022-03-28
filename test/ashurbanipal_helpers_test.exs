defmodule AshurbanipalHelpersTest do
  use ExUnit.Case

  test "Ashurbanipal.Helpers.parse_pagination_value/1 returns atom :all when passed an invalid integer" do
    assert Ashurbanipal.Helpers.parse_pagination_value(100) == :all
    assert Ashurbanipal.Helpers.parse_pagination_value(6) == :all
    assert Ashurbanipal.Helpers.parse_pagination_value(0) == :all
    assert Ashurbanipal.Helpers.parse_pagination_value(-1) == :all
  end

  test "Ashurbanipal.Helpers.parse_pagination_value/1 returns pagination_value when passed a valid integer" do
    assert Ashurbanipal.Helpers.parse_pagination_value(1) == 1
    assert Ashurbanipal.Helpers.parse_pagination_value(2) == 2
    assert Ashurbanipal.Helpers.parse_pagination_value(3) == 3
    assert Ashurbanipal.Helpers.parse_pagination_value(4) == 4
    assert Ashurbanipal.Helpers.parse_pagination_value(5) == 5
  end

  test "Ashurbanipal.Helpers.parse_pagination_query/1 returns valid response" do
    assert Ashurbanipal.Helpers.parse_pagination_query(%{}) == :all
    assert Ashurbanipal.Helpers.parse_pagination_query(%{"other_key" => "1"}) == :all
    assert Ashurbanipal.Helpers.parse_pagination_query(%{"page" => "2"}) == 2
  end

  test "Ashurbanipal.Helpers.parse_story_id_from_path/1 returns valid response" do
    assert Ashurbanipal.Helpers.parse_story_id_from_path(%{}) == :error
    assert Ashurbanipal.Helpers.parse_story_id_from_path(%{"story_id" => "1234"}) == 1234
    assert Ashurbanipal.Helpers.parse_story_id_from_path(%{"other_key" => "1234"}) == :error
  end
end
