defmodule BrodPoc.Utils do
  @batch_size 10000
  def publish_batch() do
    Enum.each(1..@batch_size, fn n ->
      message = %{
        event: :test,
        number: n,
        chunk_date: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus egestas suscipit sem ut ullamcorper. Donec tortor turpis, placerat a auctor sit amet, blandit a elit. Donec eget mi lectus. Mauris augue sapien, mollis sed hendrerit eu, convallis eu felis. Cras egestas sed ex a vehicula. Vivamus ultrices nulla sit amet eros blandit, quis tincidunt dolor cursus. Duis imperdiet semper tortor, sit amet convallis dui eleifend id. Sed vitae mauris viverra mi dapibus luctus. Sed lobortis, ipsum quis pellentesque pulvinar, urna lacus convallis lorem, ut imperdiet nibh ex ut lacus. Donec dictum, dolor vel pulvinar vehicula, nulla sem vehicula nulla, quis scelerisque purus metus congue metus. Sed auctor, nisi a auctor mattis, tellus mauris egestas ligula, scelerisque vulputate tortor eros nec diam. Fusce vitae risus laoreet, suscipit lorem eget, cursus purus. Mauris pulvinar porttitor augue, vitae placerat odio fringilla ac. Sed ante est, eleifend vitae tincidunt nec, aliquam at est."
      }

      BrodPoc.KafkaProducer.publish_message("test-topic", "1", message)
    end)
  end
end
