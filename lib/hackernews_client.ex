defmodule Ashurbanipal.HNClient do
  @moduledoc """
  A thin-wrapper that retrieves Hacker News top stories' data
  """

  @doc """
  It retrieves HN's top-stories data
  """
  @spec get_stories_data() :: {:ok, map()} | {:error, :hn_api_error}
  def get_stories_data do
    case get_stories_ids() do
      {:error, :hn_api_error} ->
        {:error, :hn_api_error}
      {:ok, ids} ->
        stories =
          ids
          |> Enum.take(50)
          |> Enum.chunk_every(10)
          |> Enum.with_index(1)
          |> Enum.reduce(%{}, fn {ids, pagination_index}, acc ->
            stories = build_stories_map(ids)
            Map.put_new(acc, pagination_index, stories)
          end)

        Map.put_new(stories, :all, merge_pages(stories))
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

  defp consume_hackernews_stories do
    HTTPoison.get("https://hacker-news.firebaseio.com/v0/topstories.json")
  end

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

  defp merge_pages(stories) do
    Map.merge(Map.get(stories, 1), Map.get(stories, 2))
    |> Map.merge(Map.get(stories, 3))
    |> Map.merge(Map.get(stories, 4))
    |> Map.merge(Map.get(stories, 5))
  end
end
