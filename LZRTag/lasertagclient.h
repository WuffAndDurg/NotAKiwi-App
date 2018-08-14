#ifndef LASERTAGCLIENT_H
#define LASERTAGCLIENT_H

#include <QObject>
#include <QtMqtt/QtMqtt>

class LasertagClient : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int   team         MEMBER team         WRITE setTeam       NOTIFY teamChanged)
    Q_PROPERTY(int   brightness   MEMBER brightness   WRITE setBrightness NOTIFY brightnessChanged)
    Q_PROPERTY(bool  connected    MEMBER connected    NOTIFY connectionChanged)

public:
    explicit LasertagClient(QMqttClient *client, QString name, QObject *parent = nullptr);

signals:
    void teamChanged(int newTeam);
    void brightnessChanged(int newBrightness);
    void connectionChanged(bool newConnection);

    void systemDataReceived(QVariantMap data);

public slots:
    void onReconnected();
    void onDataReceived(QMqttMessage msg);

    void setTeam(uint8_t newTeam);
    void setBrightness(uint8_t newBrightness);

private:
    QMqttClient *client;
    QString name;

    int team;
    int brightness;
    bool    connected;
};

#endif // LASERTAGCLIENT_H
