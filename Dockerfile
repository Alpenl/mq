FROM rabbitmq:4.0-management

# 下载并安装延迟消息交换插件
# 插件版本需要与 RabbitMQ 版本匹配
ADD https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v4.0.2/rabbitmq_delayed_message_exchange-4.0.2.ez \
    $RABBITMQ_HOME/plugins/

# 启用插件
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
