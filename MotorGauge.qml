import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.11

Item {
    id: rootItem
    property real displayValue

    CircularGauge {
        id: hundredsGauge
        stepSize: 0

        anchors.fill: parent;

        maximumValue: 100
        minimumValue: 0

        value: displayValue/360

        style: CircularGaugeStyle {
            minimumValueAngle: 0
            maximumValueAngle: 360

            tickmarkStepSize: 0

            needle: Shape {

            }
        }

        Behavior on value {
            SpringAnimation {
                id: smoothAnimation
                damping: 0.08
                spring:  3
                mass:    0.3

                modulus: 100
        }}
    }

    CircularGauge {
        id: tensGauge
        stepSize: 0

        anchors.fill: parent;

        maximumValue: 10
        minimumValue: 0

        value: displayValue/360

        style: CircularGaugeStyle {
            minimumValueAngle: 0
            maximumValueAngle: 360

            tickmarkStepSize: 1
        }

        Behavior on value {
            SpringAnimation {
                damping: 0.08
                spring:  3
                mass: 0.3

                modulus: 10
            }
        }
    }

    MotorGaugeNeedle {
        anchors.centerIn: parent
        width: parent.width*0.4
        height: parent.height*0.4

        rotation: displayValue

        Behavior on rotation {
            SpringAnimation {
                damping: 0.3
                spring:  3
                mass: 0.3

                modulus: 360
            }
        }
    }
}
