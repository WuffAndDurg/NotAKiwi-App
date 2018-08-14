
import QtQuick 2.11
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4

MultiPointTouchArea {
	 maximumTouchPoints: 2
	 mouseEnabled: true

	 id: inputArea

	 Rectangle {
		  radius: Math.min(width, height)*0.2;

		  color: Material.background
		  border.color: Material.accent;
		  border.width: 1.5

		  anchors.fill: parent;
	 }

	 Rectangle {
		  id: finger1

		  width: height
		  height: 20

		  radius: width

		  x: inputArea.width/2 - 20;
		  y: inputArea.height/2 - 20;

		  color: Material.accent;

		  Behavior on x {
				SmoothedAnimation {velocity: 1000; duration: 50}
		  }
		  Behavior on y {
				SmoothedAnimation {velocity: 1000; duration: 50}
		  }
	 }

	 Rectangle {
		  id: finger2

		  width: height
		  height: 40

		  radius: width

		  x: inputArea.width/2 - 20;
		  y: inputArea.height/2 - 20;

		  color: Material.accent;

		  Behavior on x {
				SmoothedAnimation {velocity: 1000; duration: 50}
		  }
		  Behavior on y {
				SmoothedAnimation {velocity: 1000; duration: 50}
		  }
	 }

	 onGestureStarted: {
		  if(touchPoints.size > 1)
				gesture.grab();
	 }

	 onTouchUpdated: {
		  if(touchPoints.length === 1) {
				var t = touchPoints[0];
				finger1.x = t.x - 20;
				finger2.x = t.x - 20;
				finger1.y = t.y - 20;
				finger2.y = t.y - 20;
		  }
		  else if(touchPoints.length > 1){
				finger1.x = touchPoints[0].x - 20;
				finger2.x = touchPoints[1].x - 20;

				finger1.y = touchPoints[0].y - 20;
				finger2.y = touchPoints[1].y - 20;
		  }
	 }

	 onReleased: {
		  if(touchPoints.length === 0) {
				finger1.x = width/2 - 20;
				finger1.y = height/2 - 20;
				finger2.x = width/2 - 20;
				finger2.y = height/2 - 20;
		  }
	 }
}
