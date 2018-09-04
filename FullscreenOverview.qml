
import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.2

import "QML/Views"

Item {
    width: 1300
    height: 800
    ColumnLayout {
        anchors.fill: parent

        Label {
            id: label
            color: Material.foreground
            text: qsTr("Robot Overview")

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font.pixelSize: 40

            Layout.preferredHeight: 40
            Layout.fillWidth: true

            BusyIndicator {
                id: busyIndicator
                x: 8
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.bottomMargin: -5
                anchors.bottom: parent.bottom
                anchors.top: parent.top

                running: robot.status !== 0
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 3

            color: Material.primary;
        }

        GridLayout {
            id: gridLayout
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillHeight: true
            Layout.fillWidth: true

            Material.elevation: 5

            GroupBox {
                id: motorGroupBox
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.margins: 10

                Material.elevation: 5

                title: qsTr("Motors")
                label: Label {
                    x:     motorGroupBox.leftPadding
                    width: motorGroupBox.availableWidth
                    text:  motorGroupBox.title
                    color: Material.foreground;

                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 24
                }

                GridLayout {
                    columns: 2

                    Repeater {
                        model: 4

                        MotorGauge {
                            Material.elevation: 2

                            Layout.preferredHeight: 180
                            Layout.preferredWidth:  180

                            displayValue: robot.getMotor(index).rotation;
                            speed: robot.getMotor(index).speed;

                            alarmColor: robot.getMotor(index).status;
                            statusMessage: robot.getMotor(index).statusMsg;
                        }
                    }

                    DelayButton {
                        id: delayButton
                        text: qsTr("Motor Power")
                        Layout.fillWidth: true

                        Material.accent: Material.Green

                        onCheckedChanged: robot.setMotors(checked);
                        Connections {
                            target: robot
                            onMotorPowerChanged: {
                                delayButton.checked = robot.motorPower;
                            }
                        }
                    }
                }
            }

            GroupBox {
                id: positionGB
                title: qsTr("Robot Position")

                Material.elevation: 5

                label: Label {
                    x:     positionGB.leftPadding
                    width: positionGB.availableWidth
                    text:  positionGB.title
                    color: Material.foreground;

                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 24
                }

                Layout.preferredHeight: motorGroupBox.height;
                Layout.preferredWidth:  0.8 * height;

                ColumnLayout {
                    anchors.fill: parent;

                    PositionChart {
                        id: fsPosChart

                        Layout.fillHeight: true
                        Layout.fillWidth:  true

                        robotXPos: robot.position["x"];
                        robotYPos: robot.position["y"];

                        Connections {
                            target: robot
                            onRobotPositionChanged: fsPosChart.updatePoint();
                        }
                    }

                    Button {
                        text: "Clear"
                        Layout.fillWidth: true

                        onClicked: {
                            fsPosChart.clear();
                        }
                    }
                }
            }
        }

    }

}

/*##^## Designer {
    D{i:5;anchors_height:95;anchors_width:95;anchors_x:8;anchors_y:8}D{i:1;anchors_height:100;anchors_width:100;anchors_x:281;anchors_y:145}
}
 ##^##*/
