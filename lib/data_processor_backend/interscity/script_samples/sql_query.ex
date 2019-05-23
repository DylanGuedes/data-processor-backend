defmodule DataProcessorBackend.InterSCity.ScriptSamples.SqlQuery do
  alias DataProcessorBackend.InterSCity.ScriptSamples.CodeGen
  alias DataProcessorBackend.InterSCity.ScriptSamples.Operation
  @behaviour Operation
  use CodeGen

  def gen_operation do
    """
    \    df.createOrReplaceTempView(capability)
    \    queries = params["interscity"]["sql_queries"]
    \    if (isinstance(queries, list)):
    \        for q in queries:
    \            df = spark.sql(q)
    \    else:
    \        df = spark.sql(queries)
    """
  end

  def default_params(capability, query)do
    %{
      "schema" => discover_schema(capability),
      "functional" => %{},
      "interscity" => %{
        "capability" => capability,
        "sql_queries" => String.split(query, "\n")
      }
    }
  end
end
