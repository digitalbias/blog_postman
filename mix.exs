defmodule BlogPostman.MixProject do
  use Mix.Project

  def project do
    [
      app: :blog_postman,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :timex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:neuron, "~> 1.1.1"},
      {:timex, "~> 3.5"}
    ]
  end
end
