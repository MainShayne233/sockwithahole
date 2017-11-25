defmodule Mix.Tasks.Content.Get do
  use Mix.Task

  @root_url "http://sockwithahole.website"
  @assets_dir "assets"
  @content_list_path Path.join(@assets_dir, "/list_of_things")
  @content_dir Path.join(@assets_dir, "/content")
  @github_url "https://github.com/MainShayne233"

  def run([]) do
    get_content_from_github()
    |> create_home_page
  end

  defp create_home_page(pages) do
    page = """
    <title>sock &#60;- hole</title>

    #{Enum.map(pages, &render_page/1)}
    """
    @content_dir
    |> Path.join("index.html")
    |> File.write(page)
  end

  defp render_page(page_name) do
    """
    <p><a href="#{Path.join(@root_url, page_name)}">#{page_name}</a></p>

    <iframe
      src="#{Path.join([@root_url, page_name, "preview"])}">
    </iframe>

    <hr/>
    """
  end

  defp get_content_from_github do
    @content_list_path
    |> File.read!
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn repo_name ->
      local_repo_path = Path.join(@content_dir, repo_name)
      repo_url = Path.join(@github_url, repo_name)
      System.cmd("rm", ["-rf", local_repo_path])
      System.cmd("git", ["clone", repo_url, local_repo_path])
      build_path = Path.join(local_repo_path, "build.sh")
      if File.exists?(build_path) do
        System.cmd(build_path, [])
      end
      repo_name
    end)
  end
end
