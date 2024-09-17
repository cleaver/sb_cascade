defmodule SbCascade.SiteTest do
  alias SbCascade.Site.SettingsGroup
  use SbCascade.DataCase

  import SbCascade.SiteFixtures

  alias SbCascade.Site
  alias SbCascade.Site.Setting

  describe "settings" do
    @invalid_attrs %{value: nil, key: nil}

    test "list_settings/0 returns all settings" do
      setting = setting_fixture()
      assert Site.list_settings() == [setting]
    end

    test "get_setting!/1 returns the setting with given id" do
      setting = setting_fixture()
      assert Site.get_setting!(setting.id) == setting
    end

    test "create_setting/1 with valid data creates a setting" do
      valid_attrs = %{value: "some value", key: "some key"}

      assert {:ok, %Setting{} = setting} = Site.create_setting(valid_attrs)
      assert setting.value == "some value"
      assert setting.key == "some key"
    end

    test "create_setting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Site.create_setting(@invalid_attrs)
    end

    test "update_setting/2 with valid data updates the setting" do
      setting = setting_fixture()
      update_attrs = %{value: "some updated value", key: "some updated key"}

      assert {:ok, %Setting{} = setting} = Site.update_setting(setting, update_attrs)
      assert setting.value == "some updated value"
      assert setting.key == "some updated key"
    end

    test "update_setting/2 with invalid data returns error changeset" do
      setting = setting_fixture()
      assert {:error, %Ecto.Changeset{}} = Site.update_setting(setting, @invalid_attrs)
      assert setting == Site.get_setting!(setting.id)
    end

    test "delete_setting/1 deletes the setting" do
      setting = setting_fixture()
      assert {:ok, %Setting{}} = Site.delete_setting(setting)
      assert_raise Ecto.NoResultsError, fn -> Site.get_setting!(setting.id) end
    end

    test "change_setting/1 returns a setting changeset" do
      setting = setting_fixture()
      assert %Ecto.Changeset{} = Site.change_setting(setting)
    end
  end

  describe "settings group" do
    test "get_settings_group/0 returns settings in an embedded schema" do
      test_settings_group = settings_group_fixture()

      assert setting = Site.get_setting!("site_title")
      assert setting.value == "some title"

      assert settings_group = Site.get_settings_group()
      assert settings_group.site_title == test_settings_group["site_title"]
      assert settings_group.meta_title == test_settings_group["meta_title"]
      assert settings_group.meta_description == test_settings_group["meta_description"]
    end

    test "update_settings_group/2 with valid data updates the settings group" do
      _settings_group_fixture = settings_group_fixture()
      settings_group = Site.get_settings_group()

      update_attrs = %{
        "site_title" => "some updated title",
        "meta_title" => "some updated meta title",
        "meta_description" => "some updated meta description"
      }

      assert {:ok, _changes} = Site.update_settings_group(settings_group, update_attrs)

      settings_group = Site.get_settings_group()

      assert settings_group.site_title == "some updated title"
      assert settings_group.meta_title == "some updated meta title"
      assert settings_group.meta_description == "some updated meta description"
    end

    test "change_settings_group/1 returns a SettingsGroup changeset" do
      _settings_group_fixture = settings_group_fixture()

      settings_group = Site.get_settings_group()

      changeset =
        Site.change_settings_group(settings_group, %{
          "site_title" => "some updated title",
          "meta_title" => "some updated meta title",
          "meta_description" => "some updated meta description"
        })

      assert %SettingsGroup{} = changeset
      assert(map_size(changeset.changes) == 3)
    end
  end
end
