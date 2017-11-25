defmodule Sockwithahole.Router do
  use Maru.Router

  @assets_dir "./assets"

  @content_dir @assets_dir <> "/content"

  @root_html_file @assets_dir <> "/index.html"

  @favicon File.read!(@assets_dir <> "/favicon.png")

  @error_page File.read!(@assets_dir <> "/error.html")


  route_param :thing do
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
    page =
      @content_dir <> "/" <> thing <> "/index.html"
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
