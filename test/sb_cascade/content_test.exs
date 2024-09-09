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
      comic = comic_fixture() |> Repo.preload([:comic_tags])
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
      comic = comic_fixture() |> Repo.preload([:comic_tags])
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

  describe "files" do
    alias SbCascade.Content.File

    import SbCascade.ContentFixtures

    @invalid_attrs %{name: nil, url: nil}

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert Content.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert Content.get_file!(file.id) == file
    end

    test "create_file/1 with valid data creates a file" do
      valid_attrs = %{name: "some name", url: "/uploads/image.png"}

      assert {:ok, %File{} = file} = Content.create_file(valid_attrs)
      assert file.name == "some name"
      assert file.url == "/uploads/image.png"
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      file = file_fixture()

      update_attrs = %{
        name: "some updated name",
        url: "/uploads/image.png"
      }

      assert {:ok, %File{} = file} = Content.update_file(file, update_attrs)
      assert file.name == "some updated name"
      assert file.url == "/uploads/image.png"
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_file(file, @invalid_attrs)
      assert file == Content.get_file!(file.id)
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %File{}} = Content.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> Content.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Content.change_file(file)
    end
  end

  describe "tags" do
    alias SbCascade.Content.Tag

    import SbCascade.ContentFixtures

    @invalid_attrs %{name: nil, slug: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Content.list_tags() == [tag]
    end

    test "list_tag_options/0 returns all tags as options" do
      tag = tag_fixture()
      assert Content.list_tag_options() == [{tag.name, tag.id}]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Content.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{name: "some name", slug: "some-slug"}

      assert {:ok, %Tag{} = tag} = Content.create_tag(valid_attrs)
      assert tag.name == "some name"
      assert tag.slug == "some-slug"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Tag{} = tag} = Content.update_tag(tag, update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_tag(tag, @invalid_attrs)
      assert tag == Content.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Content.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Content.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Content.change_tag(tag)
    end
  end

  describe "pages" do
    alias SbCascade.Content.Page

    import SbCascade.ContentFixtures

    @invalid_attrs %{title: nil, body: nil, slug: nil, meta_description: nil, image_alt_text: nil}

    test "list_pages/0 returns all pages" do
      page = page_fixture()
      assert Content.list_pages() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture() |> Repo.preload([:media])
      assert Content.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      valid_attrs = %{
        title: "some title",
        body: "some body",
        slug: "some slug",
        meta_description: "some meta_description",
        image_alt_text: "some image_alt_text"
      }

      assert {:ok, %Page{} = page} = Content.create_page(valid_attrs)
      assert page.title == "some title"
      assert page.body == "some body"
      assert page.slug == "some slug"
      assert page.meta_description == "some meta_description"
      assert page.image_alt_text == "some image_alt_text"
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()

      update_attrs = %{
        title: "some updated title",
        body: "some updated body",
        slug: "some updated slug",
        meta_description: "some updated meta_description",
        image_alt_text: "some updated image_alt_text"
      }

      assert {:ok, %Page{} = page} = Content.update_page(page, update_attrs)
      assert page.title == "some updated title"
      assert page.body == "some updated body"
      assert page.slug == "some updated slug"
      assert page.meta_description == "some updated meta_description"
      assert page.image_alt_text == "some updated image_alt_text"
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture() |> Repo.preload([:media])
      assert {:error, %Ecto.Changeset{}} = Content.update_page(page, @invalid_attrs)
      assert page == Content.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Content.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Content.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Content.change_page(page)
    end
  end
end
