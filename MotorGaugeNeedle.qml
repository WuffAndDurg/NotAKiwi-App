import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: rootItem

    Rectangle {
        id: boundingCircle

        anchors.centerIn: parent;

        color: "red"

        radius: Math.min(rootItem.width, rootItem.height)/2;
        width: radius*2
        height: radius*2

        clip: true

        Item {
            id: core

            anchors.centerIn: parent;

            Repeater {
                model: 6

                Rectangle {
                    color: "black"

                    height: boundingCircle.radius*0.4
                    width:  height*1.4

                    x: -width/2
                    y: boundingCircle.radius - height

                    transform: Rotation {
                        origin.x: width/2
                        origin.y: -y
                        angle: index/6 * 360
                    }
                }
            }
        }
    }
}
