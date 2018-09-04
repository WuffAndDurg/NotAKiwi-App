import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id: rootItem

    property color needlePrimary:   Material.color(Material.Green);
    property color needleSecondary: Material.color(Material.Green, Material.Shade900);

    Rectangle {
        id: boundingCircle

        anchors.centerIn: parent;

        color: needlePrimary

        radius: Math.min(rootItem.width, rootItem.height)/2;
        width: radius*2
        height: radius*2
    }

    Item {
        id: core
        z: 1

        anchors.centerIn: parent;

        Repeater {
            model: 6

            Rectangle {
                color: needleSecondary
                radius: width * 0.15

                height: boundingCircle.radius*0.4
                width:  height*1.4

                x: -width/2
                y: boundingCircle.radius - height*0.9

                transform: Rotation {
                    origin.x: width/2
                    origin.y: -y
                    angle: index/6 * 360
                }
            }
        }
    }
}
