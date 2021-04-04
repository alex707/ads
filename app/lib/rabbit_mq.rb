module RabbitMq
  extend self

  @mutex = Mutex.new

  # рекомендуется держать открытым один коннекшн на процесс
  def connection
    # треды пумы будут иметь разделяемый доступ с помощью mutex
    @mutex.synchronize do
      @connection ||= Bunny.new.start
    end
  end

  # т.е. если пума в сингл моде, в ОС будет запущен один процесс с пумой,
  #   внутри которого сколько угодно тредов. будет одно соединение на процесс
  # т.е. если пума в кластер моде, в ОС будет запущен несколько процессов с пумой,
  #   и если два треда единовременно попробуют обратиться к одному connection,
  #   лишнего connection не создастся

  # рекомендуется один канал на тред
  def channel
    # для каждого треда будет создан свой собственный канал
    Thread.current[:rabbitmq_channel] ||= connection.create_channel
  end

  def consumer_channel
    # See http://rubybunny.info/articles/concurrency.html#consumer_work_pools
    Thread.current[:rabbitmq_current_channel] ||=
      connection.create_channel(
        nil,
        Settings.rabbitmq.consumer_pool
      )
  end
end
