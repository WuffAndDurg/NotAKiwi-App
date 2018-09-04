import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.2

import "QML/Views"

GridLayout {
    columns: 2

//    Timer {
//        repeat:     true
//        running:    true
//        interval:   200

//        onTriggered: {
//            motorGauge.displayValue += inputDial.value*100;
//            motorGauge.speed = Math.abs(inputDial.value*1000);
//        }
//    }

    Repeater {
        model: 4

        MotorGauge {
            Layout.fillWidth:  true
            Layout.fillHeight: true

            Layout.preferredHeight: 70
            Layout.preferredWidth:  50

            property real maxSize: Math.min(width, height) * 1.2;
            Layout.maximumHeight: maxSize;
            Layout.maximumWidth:  maxSize;

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
        Layout.columnSpan: 2

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
