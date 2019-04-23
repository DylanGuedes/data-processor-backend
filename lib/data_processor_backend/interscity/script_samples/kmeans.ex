defmodule DataProcessorBackend.InterSCity.ScriptSamples.Kmeans do
  def code do
    """
from pyspark.sql.types import StructType, StructField, ArrayType, StringType, DoubleType, IntegerType, DateType
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, col
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.regression import LinearRegression
from pyspark.ml.clustering import KMeans
import requests
import os

import sys

if __name__ == '__main__':
\    os.environ['PYSPARK_PYTHON'] = '/usr/bin/python3'
\    # Loading the dataset
\    my_uuid = str(sys.argv[1])

\    url = "#{DataProcessorBackendWeb.Endpoint.url}" + '/api/job_templates/{0}'.format(my_uuid)
\    response = requests.get(url)
\    params = response.json()["data"]["attributes"]["user-params"]

\    functional_params = params["functional"]
\    capability = params["interscity"]["capability"]

\    features = list(map(lambda a: a.strip(), functional_params["features"].split(",")))
\    MASTER_URL = #{System.get_env("SPARK_MASTER")}
\    conf = (SparkConf()
\     .set("spark.eventLog.enabled", "true")
\     .set("spark.history.fs.logDirectory", "/tmp/spark-events")
\     .set("spark.app.name", "step2-datacollector-extraction(dataprocessor)")
\     .set("spark.jars.packages", "org.mongodb.spark:mongo-spark-connector_2.11:2.4.0")
\     .setMaster(MASTER_URL))
\    sc = SparkContext(conf=conf)
\    spark = SparkSession(sc)
\    spark.sparkContext.setLogLevel("INFO")
\    DEFAULT_URI = "mongodb://#{System.get_env("DATA_COLLECTOR_MONGO")}/data_collector_development"
\    DEFAULT_COLLECTION = "sensor_values"
\    pipeline = "{'$match': {'capability': '"+capability+"'}}"
\    schema_params = params["schema"]
\    sch = StructType()
\    sch.add("uuid", StringType())
\    for k,v in schema_params.items():
\        if (k=="string"):
\            sch.add(k, StringType())
\        elif (k=="double"):
\            sch.add(k, DoubleType())
\        elif (k=="integer"):
\            sch.add(k, LongType())
\    df = (spark
\            .read
\            .format("com.mongodb.spark.sql.DefaultSource")
\            .option("spark.mongodb.input.uri", "{0}.{1}".format(DEFAULT_URI, DEFAULT_COLLECTION))
\            .option("pipeline", pipeline)
\            .schema(sch)
\            .load())

\    assembler = VectorAssembler(inputCols=features, outputCol="features")
\    assembled_df = assembler.transform(df).select("features")

\    # Running KMeans
\    how_many_clusters = int(functional_params.get("k", 2))
\    seed_to_use = functional_params.get("seed", 1)
\    kmeans = KMeans().setK(how_many_clusters).setSeed(seed_to_use)
\    model = kmeans.fit(assembled_df)

\    publish_strategy = params["publish_strategy"]
\    model_host = functional_params.get("model_host", "/tmp/data/")
\    model_file_path = publish_strategy["path"]
\    model.write().overwrite().save(model_host + model_file_path)

\    centers = []
\    for k in model.clusterCenters():
\        centers.append(k.tolist())

\    center_host = functional_params.get("centers_host", "/tmp/data/")
\    center_path = functional_params.get("centers_path", None)
\    centers_df = spark.createDataFrame(centers, features)

\    if (center_path != None):
\        centers_df.write.mode("overwrite").save(center_host + center_path)
\    else:
\        centers_df.show(truncate=False)
\    spark.stop()
\    sc.stop()
    """
  end

  def example_title do
    """
    InterSCity Temperature KMeans
    """
  end

  def language do
    "python"
  end

  def example_user_params do
    %{
      schema: %{temperature: "double"},
      functional: %{k: 3, features: "temperature"},
      interscity: %{capability: "temperature"}
    }
  end
end
