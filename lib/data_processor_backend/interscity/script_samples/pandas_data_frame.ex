defmodule DataProcessorBackend.InterSCity.ScriptSamples.PandasDataFrame do
  alias DataProcessorBackend.InterSCity.ScriptSamples.CodeGen
  alias DataProcessorBackend.InterSCity.ScriptSamples.Operation
  @behaviour Operation
  use CodeGen

  def gen_operation do
    """
    \    df.write.format("parquet").save("myquery.parquet")
    """
  end

  def default_params(capability, _query)do
    %{
      "schema" => discover_schema(capability),
      "functional" => %{},
      "interscity" => %{
        "capability" => capability
      }
    }
  end
end
