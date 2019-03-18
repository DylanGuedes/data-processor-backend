defmodule DataProcessorBackend.InterSCity.ProcessingJob do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  use DataProcessorBackend.InterSCity.Model

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.ProcessingJob
  alias DataProcessorBackend.InterSCity.JobTemplate

  schema "processing_jobs" do
    field(:uuid, :string)
    field(:job_state, :string)
    belongs_to(:job_template, JobTemplate)

    timestamps()
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:uuid, :job_state])
    |> assoc_constraint(:job_template)
    |> cast_assoc(:job_template, with: &JobTemplate.changeset/2)
  end

  def create(template) do
    template = template |> Repo.preload(:job_script)

    %ProcessingJob{job_template: template}
    |> ProcessingJob.changeset(%{uuid: Ecto.UUID.generate})
    |> Repo.insert!()
  end

  def _script_full_path(script) do
    script_root_path = System.get_env("SPARK_SCRIPTS_PATH")
    File.mkdir_p(script_root_path)
    file_path = script.path
    Enum.join([script_root_path, "/", file_path])
  end

  def ensure_script_exist(processing_job) do
    template = JobTemplate.find!(processing_job.job_template_id)
    script = template |> Repo.preload(:job_script) |> Map.get(:job_script)
    path = _script_full_path(script)
    script_content = script.code
    {:ok, file} = File.open(path, [:write])
    IO.binwrite(file, script_content)
    File.close(file)
    processing_job
  end

  def _submit_script_to_spark(job, "docker") do
    script = job.job_template.job_script
    spark_container = "master"
    full_file_path = _script_full_path(script)

    docker_arguments = [
      "exec",
      spark_container,
      "/spark/bin/spark-submit",
      "--packages",
      "org.mongodb.spark:mongo-spark-connector_2.11:2.3.1",
      full_file_path,
      job.uuid
    ]

    pid = self()

    spawn(fn ->
      {log, status} = System.cmd("docker", docker_arguments, stderr_to_stdout: true)
      IO.puts "\n\n\n\n\n### [LOG] ###"
      IO.inspect log
      IO.puts "\n\n\n\n\n### [LOG] ###"

      status_text =
        case status do
          0 -> "finished"
          _ -> "error"
        end

      job
      |> ProcessingJob.changeset(%{"log" => log, "job_status" => status_text})
      |> Repo.update()
    end)
  end
  def _submit_script_to_spark(job, _default) do
    script = job.job_template.job_script
    full_file_path = _script_full_path(script)

    spark_args = ["--packages",
      "org.mongodb.spark:mongo-spark-connector_2.11:2.3.1",
      full_file_path,
      job.uuid
    ]

    pid = self()

    spawn(fn ->
      {log, status} = System.cmd("spark-submit", spark_args, stderr_to_stdout: true)
      IO.puts "\n\n\n\n\n### [LOG] ###"
      IO.inspect log
      IO.puts "\n\n\n\n\n### [LOG] ###"

      status_text =
        case status do
          0 -> "finished"
          _ -> "error"
        end

      job
      |> ProcessingJob.changeset(%{"log" => log, "job_status" => status_text})
      |> Repo.update()
    end)
  end
  def submit_script_to_spark(job) do
    strategy_to_use = System.get_env("STRATEGY_TO_USE")
    _submit_script_to_spark(job, strategy_to_use)
  end

  def run(processing_job) do
    processing_job
    |> ensure_script_exist()
    |> submit_script_to_spark()
  end
end
