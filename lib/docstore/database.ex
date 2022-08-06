defmodule Docstore.Database do
  require :mnesia
  alias :mnesia, as: Mnesia
  def start do
    case Mnesia.create_schema([node()]) do
      {:ok} -> IO.puts("success: create schema")
      {:error, {host, {:already_exists, host}}} -> IO.puts("#{host} already exists")
      {:error, {host, {error, host}}} -> raise "host #{host}: #{error}"
    end
    case Mnesia.start() do
      :ok -> IO.puts("db started")
      _ -> raise "db could not start"
    end
    case Mnesia.create_table(:kv, [attributes: [:key, :value]]) do
      {:atomic, :ok} -> IO.puts("table created")
      _ -> raise "table was not created"
    end
  end

  def all do
    Mnesia.dirty_match_object({:kv, :_, :_})
    |> Enum.map(fn(x) ->
      {:kv, k, v} = x
      %{k=>v}
    end)
  end
  def read(key) do
    case Mnesia.dirty_read({:kv, key}) do
      [{:kv, k, v}] -> %{k => v}
      [] -> %{}
    end
  end
  def write(key, value) do
    Mnesia.dirty_write({:kv, key, value})
    %{key => value}
  end
end
