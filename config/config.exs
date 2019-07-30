# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# These are the primary varaibles which need to be set for each environment.
# config :blog_postman, token: ""
# config :blog_postman, owner: ""
# config :blog_postman, repo_name: ""

# You can also configure a third-party app:
#
#     config :logger, level: :info
#

config :blog_postman,
  token: System.get_env("BLOG_TOKEN"),
  owner: System.get_env("BLOG_OWNER"),
  repo_name: System.get_env("BLOG_REPO_NAME")

import_config "#{Mix.env()}.exs"
