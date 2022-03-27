defmodule Ashurbanipal.Helpers do
  @moduledoc """
  A module containing helper functions
  """

  def parse_pagination_value(:all), do: :all

  def parse_pagination_value(pagination_value) when pagination_value <= 5, do: pagination_value

  def parse_pagination_value(_pagination_value), do: :all

  def parse_pagination_query(%{"page" => pagination_value}) do
    case Integer.parse(pagination_value) do
      {parsed_value, _} -> parsed_value
      :error -> :all
    end
  end

  def parse_pagination_query(%{}), do: :all
end
