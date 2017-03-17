defmodule Spike.Router do
  use Plug.Router

  @random_range 1..100

  plug :match
  plug :dispatch

  get "/stable" do
    send_resp(conn, 200, "ok")
  end

  get "/slow" do
    HTTPoison.get "http://google.com"
    send_resp(conn, 200, "ok")
  end

  get "/unstable" do
    num = Enum.random(@random_range)
    if num >= Application.get_env(:spike, :threshold) do
      case HTTPoison.get "http://google.com" do
        {:ok, %HTTPoison.Response{status_code: code, body: body}} -> send_resp(conn, code, body)
        {:error, %HTTPoison.Error{reason: reason}} -> send_resp(conn, 500, to_string(reason))
      end
    else
      send_resp(conn, 200, "ok")
    end
  end
end
