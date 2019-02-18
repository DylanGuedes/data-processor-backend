defmodule DataProcessorBackend.InterSCity.JobScript do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias DataProcessorBackend.Repo
  alias DataProcessorBackend.InterSCity.JobScript

  schema "job_scripts" do
    field(:title, :string)
    field(:language, :string)
    field(:code, :string)
    field(:path, :string)

    timestamps()
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:title, :language, :code, :path])
    |> validate_required([:title, :language, :code, :path])
  end

  def create(attrs) do
    %JobScript{}
    |> JobScript.changeset(attrs)
    |> Repo.insert()
  end

  def all() do
    fields_to_use = [:title, :language, :code, :path, :id]
    (from u in JobScript, select: ^fields_to_use)
    |> Repo.all
  end
end
