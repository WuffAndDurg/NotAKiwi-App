#ifndef SYSTEMMQTTTEST_H
#define SYSTEMMQTTTEST_H

#include <math.h>

#include <QObject>
#include <QTimer>
#include <QDebug>
#include <QJsonDocument>
#include <QtMqtt/QtMqtt>

class SystemMQTTTest : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString      who             MEMBER who WRITE setWho NOTIFY whoChanged)
    Q_PROPERTY(QVariantMap  switchDuration  MEMBER switchDuration NOTIFY switchDurationChanged)

private:
    QMqttClient *client;
    QVariantMap switchDuration;

    QTimer      reconnectTimer;
    uint16_t    connectRetries;

public:
    QString who;

    explicit SystemMQTTTest(QMqttClient *client, QObject *parent = nullptr);

    void setWho(QString next);
    QString getWho();

signals:
    void whoChanged(QString next);
    void switchDurationChanged(QVariantMap newDuration);

public slots:
    void nomData(const QMqttMessage &msg);

    void onReconnected();
    void tryReconnect();
};

#endif // SYSTEMMQTTTEST_H
