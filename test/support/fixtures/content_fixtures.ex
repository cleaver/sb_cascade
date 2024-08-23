defmodule SbCascade.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SbCascade.Content` context.
  """

  @doc """
  Generate a comic.
  """
  def comic_fixture(attrs \\ %{}) do
    {:ok, comic} =
      attrs
      |> Enum.into(%{
        body: "some body",
        image_alt_text: "some image_alt_text",
        meta_description: "some meta_description",
        post_date: ~D[2024-07-16],
        published: true,
        slug: "some slug",
        title: "some title"
      })
      |> SbCascade.Content.create_comic()

    comic
  end

  @doc """
  Generate a file.
  """
  def file_fixture(attrs \\ %{}) do
    {:ok, file} =
      attrs
      |> Enum.into(%{
        height: 42,
        name: "some name",
        url: "/uploads/rubber-duck-icon.png",
        width: 42
      })
      |> SbCascade.Content.create_file()

    file
  end
end
