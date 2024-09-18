defmodule SbCascade.Helpers.Slug do
  @moduledoc """
  This module generates slugs.
  """

  @ignore_words ~w(an and as at be by for in is it its of on the to)

  @doc """
  Generate a slug from a string.

  ## Examples

      iex> alias SbCascade.Helpers.Slug
      iex> Slug.generate("Hello World")
      "hello-world"
      iex> Slug.generate("I have    an   apple!")
      "have-apple"
      iex> Slug.generate("I'm a single letter")
      "im-single-letter"
      iex> Slug.generate("Give me 3 tacos.")
      "give-me-3-tacos"
      iex> Slug.generate(" Please ignore leading and trailing spaces. ")
      "please-ignore-leading-trailing-spaces"

  """
  def generate(nil), do: ""

  def generate(source) do
    source
    |> String.trim()
    |> String.downcase()
    |> String.replace(~r/[^\w\d\s]/, "")
    |> String.split(~r/\W+/)
    |> Enum.reject(fn word -> single_letter?(word) or word in @ignore_words end)
    |> Enum.join("-")
  end

  defp single_letter?(word), do: String.match?(word, ~r/^[a-z]$/)
end
