use Mix.Config

config :brod,
    clients: [
      kafka_client_producer: [
        endpoints: [{"localhost", 9092}],
        auto_start_producers: true
      ],
      kafka_client_consumer: [
        endpoints: [{"localhost", 9092}],
        auto_start_producers: false
      ]
    ]
