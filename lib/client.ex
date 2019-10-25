defmodule BlogPostman.Client do
  @moduledoc """
  Documentation for Client.
  """

  def query(token, query_body) do
    Neuron.Config.set(url: "https://api.github.com/graphql")
    Neuron.Config.set(headers: headers(token))
    {:ok, %Neuron.Response{body: body}} = Neuron.query(query_body)
    body
  end

  def query_for_repo(token, owner, repo_name) do
    query(token, repo_query(owner, repo_name))
  end

  def find_existing_pull_request(token, owner, repo_name, branch_name) do
    query(token, find_existing_pull_request(owner, repo_name, branch_name))
  end

  def create_pull_request(token, repo_id, branch_name) do
    query(token, create_pull_request_query(repo_id, branch_name))
  end

  def merge_pull_request(token, pr_id) do
    query(token, merge_pull_request_query(pr_id))
  end

  def repo_query(owner, repo_name) do
    """
      query {
        repository(owner: "$owner", name: "$repo_name") {
          nameWithOwner id
        }
      }
    """
    |> String.replace("$owner", owner)
    |> String.replace("$repo_name", repo_name)
  end

  def find_existing_pull_request(owner, repo_name, branch_name) do
    """
    {
      search(query: "repo:$owner/$repo_name is:pr $branch_name in:title state:open", type: ISSUE, last: 1) {
        edges {
          node {
            ... on PullRequest {
              id
              state
            }
          }
        }
      }
    }
    """
    |> String.replace("$owner", owner)
    |> String.replace("$repo_name", repo_name)
    |> String.replace("$branch_name", branch_name)    
  end

  def create_pull_request_query(repo_id, branch_name) do
    """
      mutation {
        createPullRequest(input:{
          baseRefName:"master",
          headRefName:"$branch_name",
          repositoryId: "$repo_id",
          title: "Publishing new post for $branch_name"
        }) {
          clientMutationId,
          pullRequest {
            id
            state
          }
        }
      }
    """
    |> String.replace("$repo_id", repo_id)
    |> String.replace("$branch_name", branch_name)
  end

  def merge_pull_request_query(pr_id) do
    """
      mutation {
        mergePullRequest(input:{pullRequestId:"$pr_id"}) {
          clientMutationId,
          pullRequest {
            id
            state
          }
        }
      }
    """
    |> String.replace("$pr_id", pr_id)
  end

  def headers(token) do
    [
      "Authorization": "bearer #{token}",
      "Content-Type": "application/json"
    ]
  end
end
