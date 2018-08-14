#include "lasertagclient.h"

LasertagClient::LasertagClient(QMqttClient *client, QString name, QObject *parent)
    : QObject(parent), client(client), name(name),
      team(0), brightness(0), connected(false)
{
    connect(client, &QMqttClient::connected, this, &LasertagClient::onReconnected);
}

void LasertagClient::onReconnected() {
    QString topic;
    topic.append("Lasertag/Players/");
    topic.append(name);
    topic.append("/+");

    QMqttSubscription *sub = client->subscribe(topic);
    connect(sub, &QMqttSubscription::messageReceived, this, &LasertagClient::onDataReceived);
}

void LasertagClient::onDataReceived(QMqttMessage msg) {
    auto arg = msg.topic().levels()[3];

    qDebug()<<"Received key " << arg << " Data: " << msg.payload();

    if(arg == "Team") {
        auto newTeam = msg.payload().toInt();
        if(team == newTeam)
            return;
        this->team = newTeam;
        emit teamChanged(team);
    }
    else if(arg == "Brightness") {
        auto newBrightness = msg.payload().toInt();
        if(newBrightness == brightness)
            return;
        brightness = newBrightness;
        emit brightnessChanged(brightness);
    }
    else if(arg == "Connection") {
        bool newConnected = (msg.payload() == "OK");
        if(newConnected != connected) {
            connected = newConnected;
            emit connectionChanged(connected);
        }
    }
    else if(arg == "System") {
        auto map = QJsonDocument::fromJson(msg.payload()).object().toVariantMap();
        emit systemDataReceived(map);
    }
}

void LasertagClient::setTeam(uint8_t team) {
    if(team == this->team)
        return;
    if(team > 7)
        return;

    this->team = team;
    client->publish(QString("Lasertag/Players/%1/Team").arg(name), QByteArray::number(team));
    emit teamChanged(team);
}
void LasertagClient::setBrightness(uint8_t brightness) {
    if(brightness == this->brightness)
        return;
    if(brightness > 7)
        return;

    this->brightness = brightness;
    client->publish(QString("Lasertag/Players/%1/Brightness").arg(name), QByteArray::number(brightness));
    emit brightnessChanged(brightness);
}
