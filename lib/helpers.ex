defmodule Ashurbanipal.Helpers do
  @moduledoc """
  A module containing helper functions
  """

  @spec parse_pagination_value(integer()) :: integer()
  def parse_pagination_value(pagination_value) when pagination_value <= 50 and rem(pagination_value, 10) == 0, do: pagination_value

  def parse_pagination_value(_pagination_value), do: 50

  @spec parse_pagination_query(map()) :: integer()
  def parse_pagination_query(%{}), do: 50

  def parse_pagination_query(%{"paginate" => pagination_value}) do
    case Integer.parse(pagination_value) do
      {parsed_value, _} -> parsed_value
      :error -> 50
    end
  end
end
