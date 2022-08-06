defmodule Docstore.Router do
  alias Docstore.Database, as: KV
  use Plug.Router

  plug :match
  plug Plug.Parsers,
		parsers: [:urlencoded, :json],
		pass: ["application/json"],
		json_decoder: Jason
  plug :dispatch

  get "/" do
    response = KV.all()
    send_resp(conn |> put_resp_content_type("application/json"), 200, Jason.encode!(response))
  end

  get "/:key" do
    response = KV.read(key)
    send_resp(conn |> put_resp_content_type("application/json"), 200, Jason.encode!(response))
  end

	post "/:key" do
    # TODO: refactor to remove if, or don't check for existance
    if map_size(KV.read(key)) > 0 do
      send_resp(conn, 409, "exists")
    else
      value =
        case conn.body_params do
          %{"value" => v } -> v
          _ -> ""
        end
      case KV.write(key, value) do
        %{} -> "#{key} written"
      end
      send_resp(conn
        |> put_resp_content_type("application/json"), 200, Jason.encode!(%{key => value}))
    end
	end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
