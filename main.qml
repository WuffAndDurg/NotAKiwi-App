import QtQuick 2.7
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

import QtCharts 2.2

import "QML/Views"

Item {
    id: window
    visible: true

    Material.theme: Material.Dark

	 implicitWidth:  360
	 implicitHeight: 592

	 anchors.fill: parent;

	 Component.onCompleted: {
		  console.log("Screen size and DPI:", Screen.width, Screen.height, Screen.pixelDensity)
	 }

    Rectangle {
		  anchors.fill: parent;
        color: Material.background
    }

    SwipeView {
        anchors.fill: parent;

        TestPage {}

        LZRTagPage {}

		  PositionChart {}

		  TouchControl {}
    }
}
