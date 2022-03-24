defmodule Ashurbanipal.HNClient do
  @moduledoc """
  A thin-wrapper that retrieves Hacker News top stories' data
  """
  @hn_api_url "https://hacker-news.firebaseio.com/v0/topstories.json"

  @doc """
  It retrieves HN's top-stories data
  """
  @spec get_stories_data() :: {:ok, map()} | {:error, :hn_api_error}
  def get_stories_data do
    case get_stories_ids() do
      {:error, :hn_api_error} ->
        {:error, :hn_api_error}
      {:ok, ids} ->
        ids |> Enum.take(50) |> build_stories_map()
    end
  end

  defp get_stories_ids do
    case consume_hackernews_stories() do
      {:ok, %{body: body}} ->
        {:ok, Poison.decode!(body)}
      {:error, _} ->
        {:error, :hn_api_error}
    end
  end

  defp consume_hackernews_stories, do: HTTPoison.get(@hn_api_url)

  defp consume_hackernews_story(story_id) do
    case HTTPoison.get("https://hacker-news.firebaseio.com/v0/item/#{story_id}.json") do
      {:ok, %{body: body}} ->
        Poison.decode!(body)
      {:error, _} ->
        {:error, :stale_story}
    end
  end

  defp include_story?({:error, :stale_story}), do: false
  defp include_story?(_response), do: true

  defp build_stories_map(stories_ids) do
    stories_ids
    |> Enum.reduce(%{}, fn id, acc ->
      story_data = consume_hackernews_story(id)
      if include_story?(story_data) do
        Map.put_new(acc, id, story_data)
      end
    end)
  end
end
