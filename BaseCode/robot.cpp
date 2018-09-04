#include "robot.h"

Robot::Robot(QMqttClient *client, QString name, QObject *parent) :
    BaseRobot (client, name, parent),
    motorPower(false),
    ESPStatus("")
{
    connect(this, &BaseRobot::dataReceived, this, &Robot::processData);

    for(uint8_t i=0; i<4; i++)
        motors[i] = new Motor(i, this);

    robotPosition["x"] = 0;
    robotPosition["y"] = 0;
    robotPosition["r"] = 0;
}
Robot::~Robot() {
    for(uint8_t i=0; i<4; i++)
        delete motors[i];
}

Motor *Robot::getMotor(int i) {
    if(i > 4 || i < 0)
        return nullptr;

    return motors[i];
}

void Robot::setMotors(bool power) {
    if(power == motorPower)
        return;

    motorPower = power;
    mqtt_client->publish(QString("Robots/%1/MotorPower").arg(name), power ? "1" : "0");
    emit motorPowerChanged(power);
}
void Robot::setJoystick(float x, float y, float r) {
#pragma pack(1)
    short data[3] = {static_cast<short>(x*1000), static_cast<short>(y*1000), static_cast<short>(r*1000)};
#pragma pack()
    QByteArray outData = QByteArray(static_cast<char *>(static_cast<void *>(&data)), sizeof(data));

    qDebug()<<"Sending joystick data:"<<outData<<" (size:"<<outData.length()<<")";
    mqtt_client->publish(QString("Robots/%1/Joystick").arg(name), outData);
}

void Robot::processData(const QString &key, const QByteArray &data) {
    if(key == "Status") {
        ESPStatus = QString(data);
        qDebug()<<"Next ESP-Status is" << ESPStatus;
        recheckStatus();
    }
    else if(key == "MotorPower") {
        bool nextPower = (QString(data) == "1");
        if(nextPower == motorPower)
            return;
        motorPower = nextPower;
        emit motorPowerChanged(motorPower);
    }
    else if(key == "Position") {
#pragma pack(1)
        const void  *vData = data.constData();
        const float *fData = static_cast<const float *>(vData);

        robotPosition["x"] = fData[0];
        robotPosition["y"] = fData[1];
        robotPosition["r"] = fData[2];
#pragma pack()

        emit robotPositionChanged(robotPosition);
    }
}

bool Robot::partialStatusCheck() {
    if(BaseRobot::partialStatusCheck())
        return true;

    else if(ESPStatus == "") {
        setStatus(-2);
        setStatusMessage("Waiting on ESP ...");
        return true;
    }
    else if(ESPStatus == "NO BOT") {
        setStatus(1);
        setStatusMessage("Waiting on Robot ...");

        return true;
    }

    return false;
}
