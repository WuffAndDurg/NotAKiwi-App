#include "motor.h"

Motor::Motor(int id, Robot *parent) : QObject(static_cast<QObject*>(parent)),
    id(id)
{

}
