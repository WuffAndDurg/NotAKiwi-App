
#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlEngine>
#include <QQuickStyle>
#include <QQmlContext>

#include <QtMqtt/QtMqtt>

#include "MQTTEst/systemmqtttest.h"
#include "LZRTag/lasertagclient.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    QQuickView viewer;

    QMqttClient mqttClient;
    mqttClient.setHostname("xasin.hopto.org");
    mqttClient.setUsername("Xasin");
    mqttClient.setPassword(PASSWD);
    mqttClient.setPort(1883);

    mqttClient.connectToHost();

    SystemMQTTTest test(&mqttClient);
    viewer.engine()->rootContext()->setContextProperty("system", &test);

    LasertagClient blue(&mqttClient, "Blue");
    viewer.engine()->rootContext()->setContextProperty("blue", &blue);

    QQuickStyle::setStyle("Material");

    viewer.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    viewer.setTitle("Wuff's butt");
    viewer.setWidth(360);
    viewer.setHeight(592);
    viewer.show();

    return app.exec();
}
