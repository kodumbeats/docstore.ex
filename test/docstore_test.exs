defmodule DocstoreTest do
  use ExUnit.Case
  doctest Docstore

  test "greets the world" do
    assert Docstore.hello() == :world
  end
end
