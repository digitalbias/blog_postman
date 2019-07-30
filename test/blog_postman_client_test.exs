defmodule BlogPostmanClientTest do
  use ExUnit.Case
  doctest BlogPostman

  test "gets the id for the repo with a simple query" do
    token = Application.get_env(:blog_postman, :token)
    owner = Application.get_env(:blog_postman, :owner)
    repo_name = Application.get_env(:blog_postman, :repo_name)

    %{"data" => %{"repository" => %{"id" => id}}} = BlogPostman.Client.query_for_repo(token, owner, repo_name)
    assert id == "MDEwOlJlcG9zaXRvcnkzOTcyNDExNw=="
  end

  test "creates a pull request for the branch and then merges it" do
    token = Application.get_env(:blog_postman, :token)
    repo_id = "MDEwOlJlcG9zaXRvcnkzOTcyNDExNw=="
    branch_name = "Scheduled(2019-05-08)"
    %{"data" => %{"createPullRequest" => %{"pullRequest" => %{"id" => pr_id}}}} = BlogPostman.Client.create_pull_request(token, repo_id, branch_name)
    assert pr_id

    %{"data" => %{"mergePullRequest" => %{"pullRequest" => %{"id" => new_pr_id, "state" => state }}}} = BlogPostman.Client.merge_pull_request(token, pr_id)
    assert pr_id == new_pr_id
    assert state == "MERGED"
  end
end
