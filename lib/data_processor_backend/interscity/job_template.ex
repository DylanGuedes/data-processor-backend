defmodule DataProcessorBackend.InterSCity.JobTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  use DataProcessorBackend.InterSCity.Model
  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackend.InterSCity.ProcessingJob
  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobScript

  schema "job_templates" do
    field(:title, :string)

    field(:user_params, :map,
      default: %{
        schema: %{},
        functional: %{},
        interscity: %{}
      }
    )

    field(:publish_strategy, :map, null: false, default: %{
      format: "csv"
    })

    belongs_to(:job_script, JobScript)

    timestamps()
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:title, :user_params, :publish_strategy, :id])
    |> assoc_constraint(:job_script)
    |> cast_assoc(:job_script, with: &JobScript.changeset/2)
    |> validate_required([:title])
  end

  def create(attrs, script) do
    %JobTemplate{job_script: script}
    |> JobTemplate.changeset(attrs)
    |> Repo.insert()
  end

  def clone(id) when is_integer(id),
    do: JobTemplate.find!(id) |> clone()
  def clone(id) when is_binary(id),
    do: String.to_integer(id) |> clone()
  def clone(%JobTemplate{}=template) do
    template
    |> Repo.preload(:job_script)
    |> clone_changeset(%{})
    |> Repo.insert!
  end

  def clone_changeset(%JobTemplate{}=template, attrs\\%{}) do
    title = Map.get(attrs, :title, template.title)
    user_params = Map.get(attrs, :user_params, template.user_params)
    publish_strategy = Map.get(attrs, :publish_strategy, template.publish_strategy)
    job_script = Map.get(attrs, :job_script, template.job_script) |> Map.from_struct()
    params = %{
      title: title,
      user_params: user_params,
      publish_strategy: publish_strategy,
      job_script: job_script
    }
    empty_changeset = JobTemplate.changeset(empty(), params)
  end

  def schedule_job(%JobTemplate{}=template) do
    ProcessingJob.create(template)
  end
end
