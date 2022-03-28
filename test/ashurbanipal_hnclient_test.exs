defmodule AshurbanipalHNClientTest do
  use ExUnit.Case

  @invalid_hnapi_url "https://hacker-news.firebaseio.com/12/topstories.json"

  setup_all do
    hnclient_invalid_response = Ashurbanipal.HNClient.get_stories_data(@invalid_hnapi_url)
    hnclient_valid_response = Ashurbanipal.HNClient.get_stories_data()

    %{valid_response: hnclient_valid_response, invalid_response: hnclient_invalid_response}
  end

  test "HNClient returns correct values when HN API is down", %{invalid_response: hnclient_invalid_response} do
    assert hnclient_invalid_response == {:error, :hn_api_error}
  end

  test "HNClient returns correct values when HN API is up", %{valid_response: hnclient_valid_response} do
    assert Map.keys(hnclient_valid_response) == [1, 2, 3, 4, 5, :all]
    assert Map.get(hnclient_valid_response, :all) |> Map.to_list() |> length() == 50
  end

  test "HNClient response contains a correct numbers of stories per page", %{valid_response: hnclient_valid_response} do
    hnclient_valid_response
    |> Enum.each(fn {key, value} ->
      if not is_atom(key) do
        assert value |> Map.to_list() |> length() == 10
      end
    end)
  end
end
