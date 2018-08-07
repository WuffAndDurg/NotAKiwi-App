import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    ColumnLayout {
        anchors.fill: parent

        MotorGauge {
            id: motorGauge
            displayValue: 0

            Layout.fillWidth: true
            Layout.preferredHeight: 200
        }

        Timer {
            interval: 200
            repeat:   true
            running:  true

            onTriggered: {
                motorGauge.displayValue += inputDial.value*36
            }
        }

        Dial {
            id: inputDial
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            tickmarksVisible: true
        }

    }
}
