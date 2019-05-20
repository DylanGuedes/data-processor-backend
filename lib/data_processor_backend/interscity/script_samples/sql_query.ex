defmodule DataProcessorBackend.InterSCity.ScriptSamples.SqlQuery do
  alias DataProcessorBackend.InterSCity.ScriptSamples.CodeGen
  alias DataProcessorBackend.InterSCity.ScriptSamples.Operation
  @behaviour Operation
  use CodeGen

  def gen_operation do
    """
    \    queries = params["interscity"]["sql_queries"]
    \    for q in queries:
    \        spark.sql(q)
    """
  end

  def default_params do
    %{
      schema: discover_schema("city_traffic"),
      functional: %{},
      interscity: %{
        capability: "city_traffic"
      }
    }
  end
end
