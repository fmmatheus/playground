defmodule BrodPoc.KafkaProducer do
  def publish_message(topic, partition_key, msg) do
    case :brod.get_partitions_count(:kafka_client_producer, topic) do
      {:ok, count} ->
        :brod.produce_sync(
          :kafka_client_producer,
          topic,
          :erlang.phash2(partition_key, count),
          partition_key,
          msg
        )

      {:error, reason} ->
        {:error, reason}
    end
  end
end
