
import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4

Pane {
     Material.elevation: 2

     property alias title:          titleLabel.text
     property alias statusMessage:  messageLabel.text
     property var   alarmColor:     undefined
     property bool  autohideBorder: (title === "")

	 default property alias children: contentRect.data

	 property color backgroundColor: Material.background
	 property alias radius:     alarmRect.radius

     property bool showAlarm: true

    function updateDisplay() {
        if(typeof(alarmColor) == "string") {
              alarmRect.color = alarmColor;
              contentRect.anchors.margins = 5;
        }
        else if (typeof(alarmColor) == "number"){
              var alarmMap = {
                   "-2": [Material.Purple, 2],
                   "-1": [Material.Blue, 1],
                   0: [Material.Green, 1],
                   1: [Material.Amber,  2],
                   2: [Material.Orange, 3],
                   3: [Material.Red,    5]
              }

              alarmRect.color = Material.color(alarmMap[alarmColor][0]);
              contentRect.anchors.margins = alarmMap[alarmColor][1]

              showAlarm = true;
              resetTimer.start()
          }
        else {
              alarmRect.color = Material.color(Material.Grey);
              contentRect.anchors.margins = 1;
        }
    }

     onAlarmColorChanged:    updateDisplay();
     onStatusMessageChanged: updateDisplay();

     Timer {
         id: resetTimer
         interval: 3000

         onTriggered: {
             if(alarmColor === 0) {
                 showAlarm = false;
                 if(autohideBorder)
                     contentRect.anchors.margins = 0;
             }
         }
     }

	 data: [
		  Label {
				id: titleLabel
				anchors.top: parent.top;
				anchors.left: parent.left;

                height: (title === "") ? 0 : undefined
		  },

		  Rectangle {
				id: alarmRect

				anchors.bottom: parent.bottom;
				anchors.left:   parent.left;
				anchors.right:  parent.right;
                anchors.top:    titleLabel.bottom;

				radius: 2

				Behavior on color {
					 ColorAnimation { duration: 200 }
				}

                Label {
                   id: messageLabel
                   anchors.top: parent.top;
                   anchors.left: parent.left;
                   anchors.right: parent.right;

                   height: ((text == "") || !showAlarm) ? 0 : 18

                   clip: true;

                   background: Rectangle {
                       anchors.fill: parent;
                       color: alarmRect.color

                       radius: alarmRect.radius
                   }

                   color: Material.color(Material.Grey, Material.Shade200);
                   horizontalAlignment: Text.AlignHCenter
                   verticalAlignment:   Text.AlignVCenter

                   Behavior on height {
                       SmoothedAnimation { velocity: -1; duration: 200 }
                   }
                }

				Rectangle {
					 id: contentRect
					 color: backgroundColor;

                     anchors.left: parent.left;
                     anchors.right: parent.right;
                     anchors.bottom: parent.bottom;
                     anchors.top: messageLabel.bottom;

                     radius: alarmRect.radius;

                     anchors.topMargin: showAlarm ? 0 : undefined;

                     clip:   true
					 Behavior on anchors.margins {
                          SmoothedAnimation { velocity: -1; duration: 500; }
					 }
				}
		  }
	 ]
}
