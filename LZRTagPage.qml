import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Extras 1.4 as Extras
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

GridLayout {

    columns: (width < height) ? 1 : 2

    Item {
        Layout.preferredHeight: 10
        Layout.preferredWidth:  10
        Layout.fillHeight: true
        Layout.fillWidth: true

        GroupBox {
            id: groupBox2
            anchors.fill: parent
            title: qsTr("System Data")

            Extras.Gauge {
                id: pingGauge
                anchors.fill: parent;

                orientation: (width < height) ? Qt.Vertical : Qt.Horizontal

                minimumValue: 10
                maximumValue: 1000

                tickmarkStepSize: 100

                Connections {
                    target: blue
                    onSystemDataReceived: function(newData) {
                        pingGauge.value = newData["ping"] / 1000;
                    }
                }

                Behavior on value {
                    SmoothedAnimation {
                        velocity: -1
                        duration: 500
                    }
                }
            }
        }
    }

    Item {
        Layout.preferredHeight: 15
        Layout.preferredWidth:  20
        Layout.fillHeight: true
        Layout.fillWidth: true

        AnchorAnimation {}

        GroupBox {
            id: groupBox1

            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 10

            width: parent.width/2 - anchors.margins*2

            title: qsTr("Team")

            Tumbler {
                id: teamTumbler
                anchors.fill: parent
                model: 7

                Connections {
                    target: teamTumbler
                    onCurrentIndexChanged: {
                        blue.team = teamTumbler.currentIndex;
                    }
                }
            }
        }

        GroupBox {
            anchors.left: groupBox1.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10

            title: qsTr("Brightness")

            Tumbler {
                id: brightnessTumbler
                anchors.fill: parent
                model: 7

                Connections {
                    target: brightnessTumbler
                    onCurrentIndexChanged: {
                        blue.brightness = brightnessTumbler.currentIndex;
                    }
                }
            }
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
