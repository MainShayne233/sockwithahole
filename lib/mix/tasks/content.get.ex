defmodule Mix.Tasks.Content.Get do
  use Mix.Task

  @assets_dir "assets"
  @content_list_path Path.join(@assets_dir, "/list_of_things")
  @content_dir Path.join(@assets_dir, "/content")
  @github_url "https://github.com/MainShayne233"

  def run([]) do
    @content_list_path
    |> File.read!
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.each(fn repo_name ->
      local_repo_path = Path.join(@content_dir, repo_name)
      repo_url = Path.join(@github_url, repo_name)
      System.cmd("git", ["clone", repo_url, local_repo_path])
      build_path = Path.join(local_repo_path, "build.sh")
      if File.exists?(build_path) do
        System.cmd(build_path, [])
      end
    end)
  end
end
