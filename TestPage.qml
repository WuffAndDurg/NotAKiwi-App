import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.2

import "QML/Views"

GridLayout {
    columns: 2

    Timer {
        repeat:     true
        running:    true
        interval:   200

        onTriggered: {
            motorGauge.displayValue += inputDial.value*100;
            motorGauge.speed = Math.abs(inputDial.value*1000);
        }
    }

	 MotorGauge {
		  alarmColor: inputDial.value == 0 ? -1 : Math.min(Math.floor(inputDial.value*1000 / 300), 3);

		  Layout.fillWidth:  true
		  Layout.fillHeight: true

		  Layout.preferredHeight: 70
		  Layout.preferredWidth:  50

		  id: motorGauge
		  displayValue: 0
	 }

    Repeater {
        model: 3

        MotorGauge {
            Layout.fillWidth:  true
            Layout.fillHeight: true

            Layout.preferredHeight: 70
            Layout.preferredWidth:  50

            displayValue: 0
        }
    }

    Dial {
        Layout.fillHeight: true
        Layout.fillWidth:  true

        Layout.preferredHeight: 50
        Layout.preferredWidth:  50

        id: inputDial
        Material.accent: Material.Green;

        Layout.columnSpan: 2
    }
 }
