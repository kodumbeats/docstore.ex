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
      {:aborted, {reason, table}} -> raise "#{table} was not created: #{reason}"
      _ -> raise "table was not created"
    end
  end
  def all do
    case all_function()
    |> Mnesia.transaction() do
      {:atomic, found} ->
        Enum.map(found, fn(x) ->
          {:kv, k, v} = x
          %{k=>v}
        end)
      end
    end
  def read(key) do
    case read_function(key)
    |> Mnesia.transaction() do
      {:atomic, [{:kv, k, v}]} -> %{k => v}
      {:atomic, []} -> %{}
    end
  end
  def write(key, value) do
    case write_function(key, value)
    |> Mnesia.transaction() do
      {:atomic, :ok} -> %{key => value}
    end
  end
  defp all_function() do
    fn -> Mnesia.match_object({:kv, :_, :_}) end
  end
  defp read_function(key) do
    fn -> Mnesia.read({:kv, key}) end
  end
  defp write_function(key, value) do
    fn -> Mnesia.write({:kv, key, value}) end
  end
end
