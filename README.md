# Docstore

Very basic in-memory KV store HTTP API.

**if this sentence is present, assume this is incomplete software**

## USE

```
get "/" all()
get "/key" read(key)
post "/key?value=$value" write(key,value)

```

## TODO
- [x] POST
- [x] GET
- [x] ALL
- [ ] UPDATE
- [ ] DELETE

- [ ] transactions
- [ ] tests

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `docstore` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:docstore, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/docstore>.

