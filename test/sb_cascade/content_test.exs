defmodule SbCascade.ContentTest do
  use SbCascade.DataCase

  alias SbCascade.Content

  describe "comics" do
    alias SbCascade.Content.Comic

    import SbCascade.ContentFixtures

    @invalid_attrs %{
      title: nil,
      body: nil,
      slug: nil,
      published: nil,
      post_date: nil,
      meta_description: nil,
      image_alt_text: nil
    }

    test "list_comics/0 returns all comics" do
      comic = comic_fixture()
      assert Content.list_comics() == [comic]
    end

    test "get_comic!/1 returns the comic with given id" do
      comic = comic_fixture()
      assert Content.get_comic!(comic.id) == comic
    end

    test "create_comic/1 with valid data creates a comic" do
      valid_attrs = %{
        title: "some title",
        body: "some body",
        slug: "some slug",
        published: true,
        post_date: ~D[2024-07-16],
        meta_description: "some meta_description",
        image_alt_text: "some image_alt_text"
      }

      assert {:ok, %Comic{} = comic} = Content.create_comic(valid_attrs)
      assert comic.title == "some title"
      assert comic.body == "some body"
      assert comic.slug == "some slug"
      assert comic.published == true
      assert comic.post_date == ~D[2024-07-16]
      assert comic.meta_description == "some meta_description"
      assert comic.image_alt_text == "some image_alt_text"
    end

    test "create_comic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_comic(@invalid_attrs)
    end

    test "update_comic/2 with valid data updates the comic" do
      comic = comic_fixture()

      update_attrs = %{
        title: "some updated title",
        body: "some updated body",
        slug: "some updated slug",
        published: false,
        post_date: ~D[2024-07-17],
        meta_description: "some updated meta_description",
        image_alt_text: "some updated image_alt_text"
      }

      assert {:ok, %Comic{} = comic} = Content.update_comic(comic, update_attrs)
      assert comic.title == "some updated title"
      assert comic.body == "some updated body"
      assert comic.slug == "some updated slug"
      assert comic.published == false
      assert comic.post_date == ~D[2024-07-17]
      assert comic.meta_description == "some updated meta_description"
      assert comic.image_alt_text == "some updated image_alt_text"
    end

    test "update_comic/2 with invalid data returns error changeset" do
      comic = comic_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_comic(comic, @invalid_attrs)
      assert comic == Content.get_comic!(comic.id)
    end

    test "delete_comic/1 deletes the comic" do
      comic = comic_fixture()
      assert {:ok, %Comic{}} = Content.delete_comic(comic)
      assert_raise Ecto.NoResultsError, fn -> Content.get_comic!(comic.id) end
    end

    test "change_comic/1 returns a comic changeset" do
      comic = comic_fixture()
      assert %Ecto.Changeset{} = Content.change_comic(comic)
    end
  end
end
