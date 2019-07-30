defmodule BlogPostmanTest do
  use ExUnit.Case
  doctest BlogPostman

  @tag :skip
  test "updates website" do
    token = Application.get_env(:blog_postman, :token)
    owner = Application.get_env(:blog_postman, :owner)
    repo_name = Application.get_env(:blog_postman, :repo_name)

    assert BlogPostman.update_site(token, owner, repo_name) == {:ok, :success}
  end
end

# BRANCH_NAME_TEMPLATE='Scheduled(%)'
# DATE_FORMAT='%Y-%m-%d'
