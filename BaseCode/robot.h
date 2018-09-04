#ifndef ROBOT_H
#define ROBOT_H

#include <QObject>

#include <QtMqtt/QtMqtt>

#include "baserobot.h"
#include "motor.h"

class Robot : public BaseRobot
{
    Q_OBJECT

    Q_PROPERTY(bool   motorPower   MEMBER motorPower   WRITE setMotors NOTIFY motorPowerChanged)

    Q_PROPERTY(QVariantMap position MEMBER robotPosition NOTIFY robotPositionChanged)

public:
    explicit Robot(QMqttClient *client, QString name = "NotAKiwi", QObject *parent = nullptr);
    ~Robot();

    Q_INVOKABLE Motor *getMotor(int i);
    Q_INVOKABLE void  setMotors(bool power);
    Q_INVOKABLE void  setJoystick(float x, float y, float r);

    bool motorPower;
    QVariantMap robotPosition;

signals:
    void motorPowerChanged(bool newPower);

    void robotPositionChanged(QVariantMap nextPosition);

public slots:
    void processData(const QString &key, const QByteArray &data);

private:
    QString ESPStatus;

    Motor *motors[4];

    bool partialStatusCheck();
};

#endif // ROBOT_H
