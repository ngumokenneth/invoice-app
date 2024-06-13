defmodule GithubWorkflows do
  def get do
    %{
      "main.yml" => main_workflow(),
      "pr.yml" => pr_workflow()
    }
  end


  defp main_workflow do
    [
      [
        name: "Main",
        on: [
          push: [
            branches: ["main"]
          ]
        ],
        jobs: [
          test: test_job(),
          deploy: [
            name: "Deploy",
            needs: :test,
            steps: [
              checkout_step(),
              [
                name: "Deploy",
                run: "make deploy"
              ]
            ]
          ]
        ]
      ]
    ]
  end


  defp pr_workflow do
    [
      [
        name: "PR",
        on: [
          pull_request: [
            branches: ["main"]
          ]
        ],
        jobs: [
          test: test_job()
        ]
      ]
    ]
  end


  defp test_job do
    [
      name: "Test",
      steps: [
        checkout_step(),
        [
          name: "Run tests",
          run: "make test"
        ]
      ]
    ]
  end


  defp checkout_step do
    [
      name: "Checkout",
      uses: "actions/checkout@v4"
    ]
  end
end
