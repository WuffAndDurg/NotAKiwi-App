
import QtQuick 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4


GridLayout {
    id: rootGrid;

    signal joystickUpdated(real x, real y, real rotation);

    property bool horizontal: (width > height);
    property var  currentTouchPoints: [];

    columns: horizontal ? 2 : 1
    layoutDirection: Qt.RightToLeft

    MultiPointTouchArea {
        Layout.fillHeight: true
        Layout.fillWidth:  true

         maximumTouchPoints: 2
         mouseEnabled: true

         id: inputArea

         property real startAngle: NaN;

         clip: true

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

         function postprocessJoystick(x, y, r) {
             if(Math.abs(x) < 0.1)
                 x = 0;
             if(Math.abs(y) < 0.1)
                 y = 0;
             if(Math.abs(r) < 0.2)
                 r = 0;

             joystickUpdated(x*speedSlider.value, y*speedSlider.value, r*speedSlider.value);
         }

         function recalculateGesture(tp) {
             var scaling = Math.max(inputArea.width, inputArea.height)/2;

             if(tp.length === 0) {
                 joystickUpdated(0, 0, 0);
             }
             if(tp.length === 1) {
                 var t = tp[0];
                 postprocessJoystick((width/2-t.x)/scaling, (height/2-t.y)/scaling, 0);
             }
             if(tp.length === 2) {
                 var ta = tp[0];
                 var tb = tp[1];

                 var rotation = Math.atan2(tb.y - ta.y, tb.x - ta.x);
                 if(isNaN(startAngle))
                     startAngle = rotation;

                 postprocessJoystick((width-(ta.x + tb.x))/(2*scaling), (height-(ta.y + tb.y))/(2*scaling), rotation - startAngle);
             }
         }

         onGestureStarted: {
              if(gesture.touchPoints.length > 1)
                    gesture.grab();
         }

         onTouchUpdated: {
              if(touchPoints.length === 0) {
                  finger1.x = width/2 - 20;
                  finger1.y = height/2 - 20;
                  finger2.x = width/2 - 20;
                  finger2.y = height/2 - 20;

                  recalculateGesture(touchPoints);
              }
              else if(touchPoints.length === 1) {
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

              currentTouchPoints = touchPoints;
         }

         onPressed: {
             startAngle = NaN;
         }

         Timer {
             interval: 1000/7
             running:  currentTouchPoints.length > 0
             repeat:   true

             onTriggered: inputArea.recalculateGesture(currentTouchPoints);
         }
    }

    Slider {
        id: speedSlider

        Layout.fillHeight: !horizontal;
        Layout.fillWidth:  horizontal;
        orientation: (rootGrid.columns === 1) ? Qt.Horizontal : Qt.Vertical
    }
}
