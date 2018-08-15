#include "robot.h"

Robot::Robot(QMqttClient *client, QString name, QObject *parent) : QObject(parent),
    mqtt_client(client), mqtt_reconnectTimer(),
    name(name),
    ESPStatus(""), status(-2), statusMessage("Loading...")
{
    connect(client, &QMqttClient::connected, this, &Robot::mqtt_onReconnected);
    connect(client, &QMqttClient::connected, &mqtt_reconnectTimer, &QTimer::stop);
    connect(client, &QMqttClient::disconnected,     this, &Robot::mqtt_tryReconnect);
    connect(&mqtt_reconnectTimer, &QTimer::timeout, this, &Robot::mqtt_tryReconnect);

    mqtt_reconnectTimer.setSingleShot(true);

    for(uint8_t i=0; i<4; i++)
        motors[i] = new Motor(i, this);
}
Robot::~Robot() {
    for(uint8_t i=0; i<4; i++)
        delete motors[i];
}

void Robot::mqtt_onDataReceived(const QMqttMessage &msg) {
    auto key = msg.topic().levels()[2];

    emit dataReceived(key, msg.payload());
}
void Robot::mqtt_onReconnected() {
    recheckStatus();

    auto sub = mqtt_client->subscribe(QString("Robots/%1").arg(name));
    connect(sub, &QMqttSubscription::messageReceived, this, &Robot::mqtt_onDataReceived);
}
void Robot::mqtt_tryReconnect() {
    recheckStatus();

    if(mqtt_client->state() == QMqttClient::Connected)
        return;

    mqtt_client->connectToHost();

    mqtt_reconnectTimer.start(500);
}

void Robot::recheckStatus() {
    int     nextStatus = 0;
    QString nextMsg("Connected");

    if(mqtt_client->state() != QMqttClient::Connected) {
        nextStatus = 2;
        nextMsg = "Disconnected!";
    }
    else if(ESPStatus == "") {
        nextStatus = -2;
        nextMsg = "Waiting on ESP ...";
    }
    else if(ESPStatus == "NO BOT") {
        nextStatus = 1;
        nextMsg = "Waiting on Robot ...";
    }

    if(nextStatus != status) {
        status = nextStatus;
        emit statusChanged(status);
    }
    if(nextMsg != statusMessage) {
        statusMessage = nextMsg;
        emit statusMessageChanged(statusMessage);
    }
}
