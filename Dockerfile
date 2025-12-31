FROM rabbitmq:4.0.2-management

# 安装延迟消息交换插件
# 使用 wget 并添加重试机制以提高下载可靠性
RUN apt-get update && apt-get install -y wget && \
    wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 --tries=5 \
        -O $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-4.0.2.ez \
        https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v4.0.2/rabbitmq_delayed_message_exchange-4.0.2.ez && \
    chown rabbitmq:rabbitmq $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-4.0.2.ez && \
    chmod 644 $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-4.0.2.ez && \
    apt-get remove -y wget && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# 启用插件
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
