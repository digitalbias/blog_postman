defmodule BlogPostman do
  @moduledoc """
  Documentation for BlogPostman.
  """

  def run do
    token = Application.get_env(:blog_postman, :token)
    owner = Application.get_env(:blog_postman, :owner)
    repo_name = Application.get_env(:blog_postman, :repo_name)

    update_site(token, owner, repo_name)
  end

  def update_site(token, owner, repo_name) do
    BlogPostman.Client.query_for_repo(token, owner, repo_name)
    branch_name = generate_branch_name()

    IO.puts "Getting site repository"
    repo_id = extract_repo_id(BlogPostman.Client.query_for_repo(token, owner, repo_name))
    IO.puts "Creating pull request for merge..."
    pr_id = extract_pr_id(BlogPostman.Client.create_pull_request(token, repo_id, branch_name))
    IO.puts "Merging new post..."
    merge_status = extract_merge_status(BlogPostman.Client.merge_pull_request(token, pr_id))
    IO.puts "Merge returned with status of: #{merge_status}"
  end

  def formated_date do
    Timex.now
    |> Timex.format!("{YYYY}-{0M}-{D}")
  end

  def generate_branch_name do
    "Scheduled(" <> formated_date() <> ")"
  end

  def extract_repo_id(%{"data" => %{"repository" => %{"id" => repo_id}}}) do
    repo_id
  end

  def extract_pr_id(%{"data" => %{"createPullRequest" => %{"pullRequest" => %{"id" => id }}}}) do
    id
  end

  def extract_merge_status(%{"data" => %{"mergePullRequest" => %{"pullRequest" => %{"state" => state }}}}) do
    state
  end
end
