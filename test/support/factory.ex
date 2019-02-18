defmodule DataProcessorBackend.Factory do
  use ExMachina.Ecto, repo: DataProcessorBackend.Repo

  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackend.InterSCity.JobScript

  def job_template_factory do
    %JobTemplate{
      title: "KMeans Template",
      user_params: %{
        schema: %{temperature: "double"},
        interscity: %{capability: "temperature"}
      },
      publish_strategy: %{
        format: "csv"
      }
    }
  end

  def job_script_factory do
    %JobScript{
      title: "KMeans script",
      code: "blalb",
      language: "python",
      path: "spark_jobs/python/kmeans.py"
    }
  end
end
