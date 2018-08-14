
import QtQuick 2.0
import QtCharts 2.0

ChartView {

	 property real robotXPos: 0
	 property real robotYPos: 0

	 property real smoothXPos: robotXPos
	 property real smoothYPos: robotYPos

	 Behavior on smoothXPos {
		  SmoothedAnimation {
				duration: 2000
				velocity: 10
		  }
	 }
	 Behavior on smoothYPos {
		  SmoothedAnimation {
				duration: 2000
				velocity: 10
		  }
	 }

	 theme: ChartView.ChartThemeDark

	 implicitHeight: 500
	 implicitWidth: 864

	 legend.visible: false

	 ValueAxis {
		  id:   xAxis
		  min:  smoothXPos - width/2
		  max:  smoothXPos + width/2
	 }

	 ValueAxis {
		  id: yAxis
		  min:  smoothYPos - height/2
		  max:  smoothYPos + height/2
	 }

	 ScatterSeries {
		  axisX: xAxis
		  axisY: yAxis

		  id: point

		  XYPoint {
				x: robotXPos
				y: robotYPos
		  }
	 }

	 MouseArea {
		  id: chartTouchy

		  x: plotArea.x
		  y: plotArea.y
		  width:  plotArea.width
		  height: plotArea.height

		  Timer {
				interval: 100
				repeat:   true
				running: chartTouchy.containsMouse

				onTriggered: chartTouchy.updateFromEvent();
		  }

		  function updateFromEvent() {

				var xPos = xAxis.min + (chartTouchy.mouseX/width)*(xAxis.max - xAxis.min)
				var yPos = yAxis.max - (chartTouchy.mouseY/height)*(yAxis.max - yAxis.min)

				console.log("I got position:", xPos, yPos)

				robotXPos = xPos;
				robotYPos = yPos;

				point.clear();
				point.append(xPos, yPos);
		  }
	 }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
