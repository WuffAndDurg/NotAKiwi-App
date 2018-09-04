#include "baserobot.h"

BaseRobot::BaseRobot(QMqttClient *client, QString name, QObject *parent) :
    QObject(parent),
    mqtt_client(client), mqtt_reconnectTimer(),
    name(name),
    status(-2), statusMessage("Loading...")
{
    connect(client, &QMqttClient::connected, this, &BaseRobot::mqtt_onReconnected);
    connect(client, &QMqttClient::connected, &mqtt_reconnectTimer, &QTimer::stop);
    connect(client, &QMqttClient::disconnected,     this, &BaseRobot::mqtt_tryReconnect);
    connect(&mqtt_reconnectTimer, &QTimer::timeout, this, &BaseRobot::mqtt_tryReconnect);

    mqtt_reconnectTimer.setSingleShot(true);
    mqtt_reconnectTimer.start(100);
}
BaseRobot::~BaseRobot() {
}

const QString BaseRobot::getName() {
    return this->name;
}

int BaseRobot::getStatus() {
    return this->status;
}
QString BaseRobot::getStatusMessage() {
    return this->statusMessage;
}

void BaseRobot::mqtt_onDataReceived(const QMqttMessage &msg) {
    if(msg.topic().levelCount() < 2)
        return;

    auto key = msg.topic().levels()[2];

    emit dataReceived(key, msg.payload());
}
void BaseRobot::mqtt_onReconnected() {
    recheckStatus();

    auto sub = mqtt_client->subscribe(QString("Robots/%1/#").arg(name));
    connect(sub, &QMqttSubscription::messageReceived, this, &BaseRobot::mqtt_onDataReceived);
}
void BaseRobot::mqtt_tryReconnect() {
    recheckStatus();

    if(mqtt_client->state() == QMqttClient::Connected)
        return;

    mqtt_client->connectToHost();

    mqtt_reconnectTimer.start(1000);

    qDebug()<<"Trying to reconnect ...";
}

void BaseRobot::setStatus(int newStatus) {
    if(newStatus == status)
        return;

    status = newStatus;
    emit statusChanged(status);
}
void BaseRobot::setStatusMessage(QString newMsg) {
    if(newMsg == statusMessage)
        return;

    statusMessage = newMsg;
    emit statusMessageChanged(statusMessage);
}

void BaseRobot::recheckStatus() {
    qDebug()<<"Checking next status...";
    if(this->partialStatusCheck())
        return;

    setStatus(0);
    setStatusMessage("Connected");
}
bool BaseRobot::partialStatusCheck() {
    if(mqtt_client->state() != QMqttClient::Connected) {
        setStatus(2);
        setStatusMessage("Disconnected!");

        return true;
    }

    return false;
}
