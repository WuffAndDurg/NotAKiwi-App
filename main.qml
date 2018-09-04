import QtQuick 2.7
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

import QtCharts 2.2

import "QML/Views"

Rectangle {
    id: window
    visible: true

    Material.theme: Material.Dark
    Material.accent: Material.Blue

    color: Material.background

	 implicitWidth:  360
	 implicitHeight: 592

	 anchors.fill: parent;

	 Component.onCompleted: {
		  console.log("Screen size and DPI:", Screen.width, Screen.height, Screen.pixelDensity)
	 }

    AlertBox {
        anchors.fill: parent;

        alarmColor:    robot.status
        statusMessage: robot.statusMessage

        Item {
            visible: width < 1000
            anchors.fill: parent;

            TabBar {
                id: tabSelector

                anchors.top:    parent.top
                anchors.left:   parent.left;
                anchors.right:  parent.right;

                currentIndex: mainView.currentIndex;
                onCurrentIndexChanged: {
                    mainView.currentIndex = currentIndex;
                }

                anchors.margins: 5;

                TabButton {
                    text: "Stats."
                }
                TabButton {
                    text: "Pos."
                }
                TabButton {
                    text: "Joystick"
                }
            }

            SwipeView {
                id: mainView

                interactive: (currentIndex < 2);

                anchors.top:    tabSelector.bottom;
                anchors.left:   parent.left;
                anchors.right:  parent.right;
                anchors.bottom: parent.bottom;

                anchors.margins: 5

                clip: true

                TestPage {}

                PositionChart {
                    id: posChart
                    robotXPos: robot.position["x"];
                    robotYPos: robot.position["y"];

                    Connections {
                        target: robot
                        onRobotPositionChanged: posChart.updatePoint();
                    }
                }

                TouchControl {
                    onJoystickUpdated: {
                        robot.setJoystick(x, y, rotation);
                    }
                }
            }
        }

        FullscreenOverview {
            visible: width >= 1000;
            anchors.fill: parent;
        }
    }
}
