defmodule Sockwithahole.Router do
  use Maru.Router

  @assets_dir "./assets"

  @content_dir @assets_dir <> "/content"

  @root_html_file @content_dir <> "/index.html"

  @favicon File.read!(@assets_dir <> "/favicon.png")

  @error_page File.read!(@assets_dir <> "/error.html")


  route_param :thing do

    get :preview do
      params
      |> Map.get(:thing)
      |> handle_request_for_thing_preview(conn)
    end

    get do
      params
      |> Map.get(:thing)
      |> handle_request_for_thing(conn)
    end
  end

  get do
    page = File.read!(@root_html_file)
    html(conn, page)
  end

  defp handle_request_for_thing("favicon.ico", conn) do
    text(conn, @favicon)
  end

  defp handle_request_for_thing(thing, conn) do
    [@content_dir, thing, "index.html"]
    |> Path.join
    |> render_page(conn)
  end

  defp handle_request_for_thing_preview(thing, conn) do
    [@content_dir, thing, "preview.html"]
    |> Path.join
    |> render_page(conn)
  end

  defp render_page(path, conn) do
    page =
      path
      |> File.read
      |> case do
        {:ok, page} ->
          page
        _other ->
          @error_page
      end
    html(conn, page)
  end
end
