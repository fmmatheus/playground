defmodule BrodPoc.KafkaConsumer do
  require Record
  require Logger

  alias BrodPoc.MessageProcessor

  Record.defrecord(:kafka_message, Record.extract(:kafka_message, from_lib: "brod/include/brod.hrl"))

  def init(_group_id, callback_init_args) do
    {:ok, callback_init_args}
  end

  def start(_opts) do
    :brod.start_link_group_subscriber_v2(subscriber_config())
  end

  def handle_message(kafka_message_set, state) do
    messages = handle_message_set(kafka_message_set)

    Logger.info("[MessageProcessor] Processing batch of #{inspect(Enum.count(messages))} messages")

    MessageProcessor.handle_batch(messages)

    Logger.info("[MessageProcessor] Finished batch process")

    {:ok, :ack, state}
  catch
    _type, reason ->
      handle_error(reason, __MODULE__, __STACKTRACE__)
  end

  def handle_message_set({_type, _topic, _partition, _high_wm_offset, messages} = _kafka_message_set), do: messages

  defp subscriber_config, do:
    %{
      client: :kafka_client_consumer,
      group_id: "test_topic_consumer_group_1",
      topics: ["test-topic"],
      cb_module: __MODULE__,
      init_data: [],
      message_type: :message_set,
      consumer_config: [{:begin_offset, :latest}],
      group_config: group_config()
    }

  defp group_config, do:
    [
      offset_commit_policy: :commit_to_kafka_v2,
      offset_commit_interval_seconds: 5,
      rejoin_delay_seconds: 30,
      reconnect_cool_down_seconds: 30
    ]

  defp handle_error(reason, module, stacktrace) do
    Logger.error("#{module} with error, reason: #{inspect(reason)}, stacktrace: #{inspect(stacktrace)}")
  end
end
