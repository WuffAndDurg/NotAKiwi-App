#ifndef BASEROBOT_H
#define BASEROBOT_H

#include <QObject>
#include <QtMqtt/QtMqtt>

class BaseRobot : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name   READ getName)
    Q_PROPERTY(int     status READ getStatus NOTIFY statusChanged)
    Q_PROPERTY(QString statusMessage READ getStatusMessage NOTIFY statusMessageChanged)

public:
    explicit BaseRobot(QMqttClient *client, QString name = "NotAKiwi", QObject *parent = nullptr);
    ~BaseRobot();

    const QString getName();

    int     getStatus();
    QString getStatusMessage();

signals:
    void statusChanged(int newStatus);
    void statusMessageChanged(QString &msg);

    void dataReceived(const QString &key, const QByteArray &data);

public slots:
    void mqtt_onDataReceived(const QMqttMessage &msg);
    void mqtt_onReconnected();
    void mqtt_tryReconnect();

protected:
    QMqttClient *mqtt_client;
    QTimer       mqtt_reconnectTimer;

    const QString name;

    int         status;
    QString     statusMessage;

    void setStatus(int newStatus);
    void setStatusMessage(QString newMsg);

    void recheckStatus();
    virtual bool partialStatusCheck();
};

#endif // BASEROBOT_H
