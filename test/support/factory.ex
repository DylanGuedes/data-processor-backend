defmodule DataProcessorBackend.Factory do
  use ExMachina.Ecto, repo: DataProcessorBackend.Repo

  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackend.InterSCity.JobScript
  alias DataProcessorBackend.InterSCity.ProcessingJob

  def job_template_factory do
    %JobTemplate{
      title: "KMeans Template",
      user_params: %{
        schema: %{temperature: "double"},
        interscity: %{capability: "temperature"}
      },
      publish_strategy: %{
        format: "csv"
      },
      job_script: build(:job_script)
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

  def processing_job_factory do
    %ProcessingJob{
      uuid: "abc-123",
      job_template: build(:job_template),
      job_state: "ready"
    }
  end
end
