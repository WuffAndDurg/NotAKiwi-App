#include "motor.h"

Motor::Motor(int id, BaseRobot *parent) : QObject(parent),
    robot(parent), id(id),
    currentRotation(0), currentSpeed(0),
    currentStatus(-2), currentStatusMsg("Loading"), lastStatusCode(127)
{
    connect(parent, &BaseRobot::dataReceived, this, &Motor::onDataReceived);
}

float Motor::rotation() {
    return this->currentRotation;
}
float Motor::speed() {
    return this->currentSpeed;
}
int Motor::status() {return currentStatus;}
QString Motor::statusMsg() {return currentStatusMsg;}

void Motor::onDataReceived(const QString &key, const QByteArray &data) {
    if(key != "Motors")
        return;

    if(data.length() < ((id+1)*(sizeof(DataPack)))) {
        processStatusCode(-100);
        return;
    }

    const void * rawData = data.data();
    rawData += id*sizeof(DataPack);
    const DataPack * dataPack = static_cast<const DataPack *>(rawData);

    this->currentRotation = dataPack->rotation;
    this->currentSpeed    = dataPack->speed;

    emit dataChanged(currentRotation, currentSpeed);
    processStatusCode(dataPack->statusCode);
}

void Motor::processStatusCode(int8_t code) {
    if(lastStatusCode == code)
        return;
    lastStatusCode = code;

    switch(code) {
    case 0:
        currentStatus = 0;
        currentStatusMsg = "OK";
    break;
    case 1:
        currentStatus = -1;
        currentStatusMsg = "OFF";
    break;
    case -1:
        currentStatus = 3;
        currentStatusMsg = "OVERHEAT";
    break;
    case -100:
        currentStatus = -2;
        currentStatusMsg = "NO DATA";
    break;
    case -101:
        currentStatus = 2;
        currentStatusMsg = "INVALID DATA";
    break;
    default:
        currentStatus = 2;
        currentStatusMsg = "UNKNOWN";
    }

    emit statusChanged(currentStatus, currentStatusMsg);
}
