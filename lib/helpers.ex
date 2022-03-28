defmodule Ashurbanipal.Helpers do
  @moduledoc """
  A module containing helper functions
  """

  @spec parse_pagination_value(atom() | integer()) :: :all | integer()
  def parse_pagination_value(:all), do: :all

  def parse_pagination_value(0), do: :all

  def parse_pagination_value(pagination_value) when pagination_value <= 5 and pagination_value >= 1, do: pagination_value

  def parse_pagination_value(_pagination_value), do: :all

  @spec parse_pagination_query(map()) :: :all | integer()
  def parse_pagination_query(%{"page" => pagination_value}) do
    case Integer.parse(pagination_value) do
      {parsed_value, _} -> parsed_value
      :error -> :all
    end
  end

  def parse_pagination_query(%{}), do: :all

  @spec parse_story_id_from_path(map()) :: :error | integer()
  def parse_story_id_from_path(%{"story_id" => id}) do
    case Integer.parse(id) do
      {parsed_value, _} -> parsed_value
      :error -> :error
    end
  end

  def parse_story_id_from_path(%{}), do: :error
end
