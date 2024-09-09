defmodule SbCascade.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SbCascade.Content` context.
  """

  @doc """
  Generate a comic.
  """
  def comic_fixture(attrs \\ %{}) do
    file = file_fixture()

    {:ok, comic} =
      attrs
      |> Enum.into(%{
        body: "some body",
        image_alt_text: "some image_alt_text",
        media_id: file.id,
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
        name: "some name",
        url: "/uploads/rubber-duck-icon.png"
      })
      |> SbCascade.Content.create_file()

    file
  end

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        name: "some name",
        slug: "some-slug"
      })
      |> SbCascade.Content.create_tag()

    tag
  end

  @doc """
  Generate a page.
  """
  def page_fixture(attrs \\ %{}) do
    file = file_fixture()

    {:ok, page} =
      attrs
      |> Enum.into(%{
        body: "some body",
        image_alt_text: "some image_alt_text",
        media_id: file.id,
        meta_description: "some meta_description",
        slug: "some slug",
        title: "some title"
      })
      |> SbCascade.Content.create_page()

    page
  end
end
