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

    IO.puts "Checking for existing PR"
    pr_id = extract_node_pr_id(BlogPostman.Client.find_existing_pull_request(token, owner, repo_name, branch_name))

    pr_id = case pr_id do 
      {:ok, id} -> {:ok, id}
      {:not_found} -> create_pull_request(token, owner, repo_name, branch_name)
    end

    case pr_id do
      {:ok, id} -> merge_post(token, id)
      {:error, errors} -> display_errors(errors)
    end
  end

  def create_pull_request(token, owner, repo_name, branch_name) do
    IO.puts "Getting site repository"
    repo_id = extract_repo_id(BlogPostman.Client.query_for_repo(token, owner, repo_name))
    IO.puts "Creating pull request for merge..."
    extract_pr_id(BlogPostman.Client.create_pull_request(token, repo_id, branch_name))
  end

  def formated_date do
    Timex.now(Timex.Timezone.Local.lookup())
    |> Timex.format!("{YYYY}-{0M}-{0D}")
  end

  def generate_branch_name do
    "Scheduled(" <> formated_date() <> ")"
  end

  def extract_repo_id(%{"data" => %{"repository" => %{"id" => repo_id}}}) do
    repo_id
  end

  def extract_node_pr_id(%{"data" => %{"search" => %{"edges" => [%{"node" => %{"id" => id, "state" => "OPEN"}}]}}}) do
    {:ok, id}
  end

  def extract_node_pr_id(%{"data" => %{"search" => %{"edges" => []}}}) do
    {:not_found}
  end

  def extract_pr_id(%{"data" => %{"createPullRequest" => %{"pullRequest" => %{"id" => id }}}}) do
    {:ok, id}
  end

  def extract_pr_id(%{"errors" => errors}) do
    {:error, errors}
  end

  def extract_merge_status(%{"data" => %{"mergePullRequest" => %{"pullRequest" => %{"state" => state }}}}) do
    state
  end

  def extract_merge_status(%{"data" => %{"mergePullRequest" => nil}, "errors" => [%{"locations" => _, "message" => message, "type" => type}]}) do
    type <> ": " <> message
  end

  def merge_post(token, pr_id) do
    IO.puts "Merging new post..."
    merge_status = extract_merge_status(BlogPostman.Client.merge_pull_request(token, pr_id))
    IO.puts "Merge returned with status of: #{merge_status}"
  end

  def display_errors(errors) do
    IO.puts "Unable to merge branch due to the following errors"
    Enum.each(errors, fn error ->
      IO.puts "---> " <> error["message"]
    end)
  end
end
