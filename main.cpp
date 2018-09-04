
#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlEngine>
#include <QQuickStyle>
#include <QQmlContext>

#include <QtMqtt/QtMqtt>

#include "BaseCode/robot.h"
#include "LZRTag/lasertagclient.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    QQuickView viewer;

    QMqttClient mqttClient;
    mqttClient.setHostname("mqtt.local");
    mqttClient.setPort(1883);
    mqttClient.setKeepAlive(5000);

    mqttClient.connectToHost();

    Robot robot(&mqttClient);
    viewer.engine()->rootContext()->setContextProperty("robot", &robot);
    qmlRegisterType<Motor>();

    QQuickStyle::setStyle("Material");

    viewer.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    viewer.setTitle("Wuff's butt");
    viewer.setWidth(360);
    viewer.setHeight(592);
    viewer.show();

    return app.exec();
}
