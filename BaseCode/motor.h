#ifndef MOTOR_H
#define MOTOR_H

#include <QObject>

#include "baserobot.h"

class Motor : public QObject
{
    Q_OBJECT

    Q_PROPERTY(float rotation READ rotation NOTIFY dataChanged)
    Q_PROPERTY(float speed    READ speed    NOTIFY dataChanged)

    Q_PROPERTY(int      status READ status  NOTIFY statusChanged)
    Q_PROPERTY(QString  statusMsg READ statusMsg NOTIFY statusChanged)

public:
#pragma pack(1)
    struct DataPack {
        int8_t statusCode;
        float  rotation;
        float  speed;
    };
#pragma pack()

    explicit Motor(int id, BaseRobot *parent = nullptr);

    float rotation();
    float speed();

    int status();
    QString statusMsg();

signals:
    void dataChanged(float rotation, float speed);
    void statusChanged(int statusCode, QString statusMsg);

public slots:
    void onDataReceived(const QString &key, const QByteArray &data);

private:
    BaseRobot *robot;
    int id;

    float currentRotation;
    float currentSpeed;

    int     currentStatus;
    QString currentStatusMsg;

    int8_t lastStatusCode;

    void processStatusCode(int8_t code);
};

#endif // MOTOR_H
