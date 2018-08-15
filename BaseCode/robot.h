#ifndef ROBOT_H
#define ROBOT_H

#include <QObject>

#include <QtMqtt/QtMqtt>

#include "motor.h"

class Robot : public QObject
{
    Q_OBJECT
public:
    explicit Robot(QMqttClient *client, QString name = "NotAKiwi", QObject *parent = nullptr);
    explicit Robot~();

    Motor *getMotor(int i);

signals:
    void statusChanged(int newStatus);
    void statusMessageChanged(QString &msg);

    void dataReceived(const QString &key, const QByteArray);

public slots:
    void mqtt_onDataReceived(const QMqttMessage &msg);
    void mqtt_onReconnected();
    void mqtt_tryReconnect();

private:
    QMqttClient   *mqtt_client;
    QTimer mqtt_reconnectTimer;

    QString name;

    QString ESPStatus;

    Motor *motors[4];

    int status;
    QString statusMessage;

    void recheckStatus();
};

#endif // ROBOT_H
