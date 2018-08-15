#ifndef MOTOR_H
#define MOTOR_H

#include <QObject>

#include "robot.h"

class Robot;

class Motor : public QObject
{
    Q_OBJECT
public:
    explicit Motor(int id, Robot *parent = nullptr);

signals:

public slots:
    void onDataReceived(QString key, QByteArray data);

private:
    int id;
};

#endif // MOTOR_H
