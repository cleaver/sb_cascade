defmodule SbCascade.Helpers.SlugTest do
  use ExUnit.Case

  alias SbCascade.Helpers.Slug

  doctest(SbCascade.Helpers.Slug)

  describe "generate/1" do
    test "empty string returns empty string" do
      assert Slug.generate("") == ""
    end

    test "nil returns empty string" do
      assert Slug.generate(nil) == ""
    end
  end
end
