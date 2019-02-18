defmodule DataProcessorBackend.InterSCity.JobTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias DataProcessorBackend.InterSCity.JobTemplate
  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobScript

  schema "job_templates" do
    field(:title, :string)

    field(:user_params, :map,
      default: %{
        schema: %{},
        functional_params: %{},
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
    |> cast(attrs, [:title, :user_params, :publish_strategy])
    |> validate_required([:title])
    |> cast_assoc(:job_script, with: &JobScript.changeset/2)
  end

  def create(attrs, script) do
    %JobTemplate{job_script: script}
    |> JobTemplate.changeset(attrs)
    |> Repo.insert()
  end

  def all() do
    (from u in JobTemplate)
    |> Repo.all
    |> Repo.preload(:job_script)
  end
end
