import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.2
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.11

AlertBox {
    title: "Motor!"

    property real displayValue
    property real speed

    implicitHeight: 400
    implicitWidth:  300

    GridLayout {
        id: columnLayout

        anchors.fill: parent;

        columns: width < height ? 1 : 2

        Item {
            id: gaugeItem

            Layout.preferredHeight: 70
            Layout.preferredWidth:  70

            Layout.fillHeight: true
            Layout.fillWidth: true

				CircularGauge {
					 id: hundredsGauge
					 stepSize: 0

					 anchors.fill: parent;

					 maximumValue: 100
					 minimumValue: 0

					 value: displayValue/360

					 style: CircularGaugeStyle {
						  minimumValueAngle: 0
						  maximumValueAngle: 360

						  tickmarkStepSize: 10
						  tickmarkLabel:  Text {
									 font.pixelSize: Math.max(6, outerRadius * 0.25)
									 color: Material.color(Material.Grey, Material.Shade200)
									 text: styleData.value/10
									 antialiasing: true

									 visible: styleData.value < 100
						  }


						  needle: Shape {
								scale: outerRadius/113

								ShapePath {
									 fillColor:   Material.color(Material.Purple, Material.Shade400);
									 strokeColor: Material.color(Material.Purple);

									 PathLine { x: -1;  y: 0   }
									 PathLine { x: -1;  y: -83  }
									 PathLine { x: -8;  y: -100 }
									 PathLine { x: 8;   y: -100 }
									 PathLine { x: 1;   y: -83  }
									 PathLine { x: 1;   y: 0   }
								}
						  }
					 }

					 Behavior on value {
						  SpringAnimation {
								id: smoothAnimation
								damping: 0.08
								spring:  3
								mass:    0.3

								modulus: 100
						  }}
				}

            CircularGauge {
                id: tensGauge
                stepSize: 0

                anchors.fill: parent;

                maximumValue: 10
                minimumValue: 0

                value: displayValue/360

                style: CircularGaugeStyle {
                    minimumValueAngle: 0
                    maximumValueAngle: 360

						  tickmarkStepSize: 0

						  needle: Shape {
								scale: outerRadius/85

								ShapePath {
									 fillColor:   Material.color(Material.Blue);
									 strokeColor: Material.color(Material.Blue, Material.Shade600);

									 PathLine { x: -8; y: -50 }
									 PathLine { x: 0;   y: -60 }
									 PathLine { x: 8;  y: -50 }
									 PathLine { x: 0;   y: 0 }
								}
						  }
                }

                Behavior on value {
                    SpringAnimation {
                        damping: 0.08
                        spring:  3
                        mass: 0.3

                        modulus: 10
                    }
                }
            }
            MotorGaugeNeedle {
                x: 176
                y: 14
                anchors.centerIn: parent
					 width: Math.min(parent.width, parent.height)*0.5;
                height: width

                rotation: displayValue

                Behavior on rotation {
                    SpringAnimation {
                        damping: 0.3
                        spring:  3
                        mass: 0.3

                        modulus: 360
                    }
                }
            }
        }

        Gauge {
            visible: false

            id: gauge

            Layout.preferredWidth:  30
            Layout.preferredHeight: 30

            Layout.fillWidth:  true
            Layout.fillHeight: true

            orientation: width < height ? Qt.Vertical : Qt.Horizontal

            Behavior on value {
                SmoothedAnimation {
                    duration: 200;
                    velocity: -1;
                }
            }

            value: speed
        }
    }
}

/*##^## Designer {
    D{i:0;displayValue__AT__NodeInstance:0;height:127;width:640}
}
 ##^##*/
