import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    ColumnLayout {
         CircularGauge {
            id: randomGauge

            maximumValue: 360
            minimumValue: 0

            Behavior on value {
                SpringAnimation {
                    damping: 0.19
                    spring:  1
                    mass: 3
                }
            }

            value: inputDial.value*360;
        }

         Dial {
            id: inputDial
            live: false
         }
  }
}