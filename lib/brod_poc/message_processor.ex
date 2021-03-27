defmodule BrodPoc.MessageProcessor do
  def handle_batch(batch) do
    for message <- batch do
      handle_message(message)
    end
  end

  defp handle_message({_type, _offset, _partition_key, message, _action, _timestamp, context} = _kafka_message) do
    Poison.decode(message)
    {:ok, :ack, context}
  end
end
