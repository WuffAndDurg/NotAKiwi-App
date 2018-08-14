
import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4

Item {
	 property alias title: titleLabel.text

	 default property alias children: contentRect.data

	 property color backgroundColor: Material.background
	 property alias radius:     alarmRect.radius

	 property var alarmColor: undefined

	 onAlarmColorChanged: {
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
			}
		  else {
				alarmRect.color = Material.color(Material.Grey);
				contentRect.anchors.margins = 1;
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

				Rectangle {
					 id: contentRect
					 color: backgroundColor;

					 anchors.fill: parent;

					 radius: anchors.margins + alarmRect.radius;
					 Behavior on anchors.margins {
						  SmoothedAnimation { velocity: -1; duration: 200; }
					 }
				}
		  }
	 ]
}
