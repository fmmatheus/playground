# Playground

Personal project to test single libraries using `iex` and create POCs (Proof of Concept).

## Testing Single Libraries

Add the desired library to `mix.exs`:

```elixir
defp deps do
    [
      {:poison, "~> 3.1.0"},
      {:brod, "~> 3.15.1"}
    ]
  end
```

Then just run `iex -S mix` locally and have fun :).

## POCs

### Kafka Batch Consumer

Example of how to implement a kafka consumer that consumes messages in batches just using [brod](https://github.com/kafka4beam/brod).

Requirements:


- elixir 1.9 or superior installed
- kafka running on localhost:9092

Files:

- `lib/brod_poc/`
	- `kafka_consumer.ex`: Implementation of batch consumer using `:brod.start_link_group_subscriber_v2/1`
	- `kafka_producer.ex`: Simple producer to test messages
	- `message_processor.ex`: Module to implement business logic for testing the consumer
	- `utils.ex`: Module with utilities functions that will make your POC's life easier

Running a simple test:

1. Inside the **Playground** folder, run: 
```bash
$ iex -S mix
```

2. That will start the supervisors (consumer/producer) and you should see the following print:
```bash
Erlang/OTP 22 [erts-10.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]


17:24:23.733 [info]  [supervisor: {:local, :brod_sup}, started: [pid: #PID<0.196.0>, id: :kafka_client_producer, mfargs: {:brod_client, :start_link, [[{"localhost", 9092}], :kafka_client_producer, [endpoints: [{"localhost", 9092}], auto_start_producers: true]]}, restart_type: {:permanent, 10}, shutdown: 5000, child_type: :worker]]

17:24:23.735 [info]  [supervisor: {:local, :brod_sup}, started: [pid: #PID<0.200.0>, id: :kafka_client_consumer, mfargs: {:brod_client, :start_link, [[{"localhost", 9092}], :kafka_client_consumer, [endpoints: [{"localhost", 9092}], auto_start_producers: false]]}, restart_type: {:permanent, 10}, shutdown: 5000, child_type: :worker]]
Interactive Elixir (1.9.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

3. Start the local consumer running `$ BrodPoc.KafkaConsumer.start(nil)`:
```bash
iex(1)> BrodPoc.KafkaConsumer.start(nil)
{:ok, #PID<0.221.0>}
iex(2)>
17:29:49.028 [info]  Group member (test_topic_consumer_group_1,coor=#PID<0.222.0>,cb=#PID<0.221.0>,generation=14):
elected=true

17:29:49.036 [info]  Group member (test_topic_consumer_group_1,coor=#PID<0.222.0>,cb=#PID<0.221.0>,generation=14):
assignments received:
  test-topic:
    partition=0 begin_offset=undefined

17:29:49.043 [info]  Starting group_subscriber_worker: %{commit_fun: #Function<3.15997700/1 in :brod_group_subscriber_v2.maybe_start_worker/6>, group_id: "test_topic_consumer_group_1", partition: 0, topic: "test-topic"}
Offset: :undefined
Pid: #PID<0.226.0>


17:29:49.043 [info]  [supervisor: {#PID<0.207.0>, :brod_consumers_sup}, started: [pid: #PID<0.227.0>, id: "test-topic", mfargs: {:supervisor3, :start_link, [:brod_consumers_sup, {:brod_consumers_sup2, #PID<0.200.0>, "test-topic", [begin_offset: :latest]}]}, restart_type: {:permanent, 10}, shutdown: :infinity, child_type: :supervisor]]

17:29:49.045 [info]  [supervisor: {#PID<0.227.0>, :brod_consumers_sup}, started: [pid: #PID<0.228.0>, id: 0, mfargs: {:brod_consumer, :start_link, [#PID<0.200.0>, "test-topic", 0, [begin_offset: :latest]]}, restart_type: {:transient, 2}, shutdown: 5000, child_type: :worker]]

17:29:49.051 [info]  client :kafka_client_consumer connected to kafka:9092
```

4. Publish a chunk of 10000 test messages to see the consumption being made in batches:
```bash
$ BrodPoc.Utils.publish_batch()
```

5. Example output:
```bash
17:31:53.560 [info]  [MessageProcessor] Processing batch of 243 messages

17:31:53.565 [info]  [MessageProcessor] Finished batch process

17:31:53.565 [info]  [MessageProcessor] Processing batch of 2 messages

17:31:53.565 [info]  [MessageProcessor] Finished batch process

17:31:53.565 [info]  [MessageProcessor] Processing batch of 1 messages

17:31:53.565 [info]  [MessageProcessor] Finished batch process

17:31:54.571 [info]  [MessageProcessor] Processing batch of 938 messages

17:31:54.572 [info]  [MessageProcessor] Finished batch process

17:31:54.573 [info]  [MessageProcessor] Processing batch of 4 messages

17:31:54.573 [info]  [MessageProcessor] Finished batch process

[truncated]
```


