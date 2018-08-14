#include "systemmqtttest.h"

SystemMQTTTest::SystemMQTTTest(QMqttClient *client, QObject *parent)
    : QObject(parent), client(client), switchDuration(),
      reconnectTimer(), connectRetries(0),
      who("none")
{
    reconnectTimer.setSingleShot(true);

    connect(client, &QMqttClient::connected, this, &SystemMQTTTest::onReconnected);
    connect(client, &QMqttClient::connected, &reconnectTimer, &QTimer::stop);

    connect(client, &QMqttClient::disconnected, this, &SystemMQTTTest::tryReconnect);
    connect(&reconnectTimer, &QTimer::timeout, this, &SystemMQTTTest::tryReconnect);
}

void SystemMQTTTest::setWho(QString next) {
    client->publish(QString("Personal/Xasin/Switching/Who"), next.toUtf8(), 0, true);
    this->who = next;

    emit whoChanged(next);
}

void SystemMQTTTest::nomData(const QMqttMessage &msg) {

    if(msg.topic() == QMqttTopicName("Personal/Xasin/Switching/Who")) {
        this->who = QString(msg.payload());
        emit whoChanged(who);
    }
    else if(msg.topic() == QMqttTopicName("Personal/Xasin/Switching/Data")) {
        qDebug()<<"Switch data is: " << msg.payload();

        this->switchDuration = QJsonDocument::fromJson(msg.payload())[QString("percentage")].toObject().toVariantMap();
        emit switchDurationChanged(switchDuration);

        qDebug()<<"Switch durations are: " << switchDuration.size();
    }
}
void SystemMQTTTest::onReconnected() {
    qDebug()<<"Reconnected!";
    connectRetries = 0;

    QMqttSubscription *sub = client->subscribe(QMqttTopicFilter("Personal/Xasin/Switching/Who"));
    connect(sub, &QMqttSubscription::messageReceived, this, &SystemMQTTTest::nomData);

    sub = client->subscribe(QMqttTopicFilter("Personal/Xasin/Switching/Data"));
    connect(sub, &QMqttSubscription::messageReceived, this, &SystemMQTTTest::nomData);
}
void SystemMQTTTest::tryReconnect() {
    qDebug()<<"Trying to reconnect!";

    if(client->state() == QMqttClient::Connected)
        return;

    connectRetries++;
    client->connectToHost();

    reconnectTimer.start(qBound(100, 100 * connectRetries, 10000));
}
