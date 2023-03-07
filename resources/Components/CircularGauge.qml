import QtQuick
import QtQuick.Controls

RoniaControl {
    id: control

    rangeControl: circularRangeControl

    /* Property Declarations
     * ****************************************************************************************/

    property CircularRangeControl circularRangeControl: CircularRangeControl {

    }

//    rangeControl: CircularRangeControl {

//    }

    /*! The distance from the center of the gauge to the outer edge of the
        gauge.

        This property is useful for determining the size of the various
        components of the style, in order to ensure that they are scaled
        proportionately when the gauge is resized. */
    readonly property real outerRadius: Math.min(control.width, control.height) * 0.5




    //! This property holds the rotation of the needle in degrees.
    property real needleRotation: {
        var percentage = (control.value -  circularRangeControl.minimumValue) / ( circularRangeControl.maximumValue -  circularRangeControl.minimumValue);
        circularRangeControl.maximumAngle + percentage * 270;
    }




    /* Object Properties
     * ****************************************************************************************/
    width: 250
    height: 250

    Behavior on value {
        NumberAnimation {
            easing.overshoot: 1.2
            duration: 800
            easing.type: Easing.OutBack
        }
    }

    /* Children
     * ****************************************************************************************/
    background: Rectangle {
        implicitHeight: parent.height
        implicitWidth: parent.width
        color: "#1e1e1e"
        anchors.centerIn: parent
        radius: width / 2
    }

    needle : Item {
        implicitWidth: 0.08 * outerRadius
        implicitHeight: 0.9 * outerRadius

        Image {
            anchors.fill: parent
            source: "qrc:/RoniaKit/resources/Images/gauge/needle.png"
        }
    }

    needleKnob : Item {
        Image {
            source: "qrc:/RoniaKit/resources/Images/gauge/knob.png"
            anchors.centerIn: parent
        }
    }

    //! Needle Loader
    Loader {
        id: needleLoader
        sourceComponent: control.needle
        transform: [
            Rotation {
                angle: needleRotation
                origin.x: needleLoader.width / 2
                origin.y: needleLoader.height
            },
            Translate {
                x: control.width / 2 - needleLoader.width / 2
                y: control.height / 2 - needleLoader.height
            }
        ]
    }

    //! Needle Knob
    Loader {
        sourceComponent: needleKnob
        anchors.fill: parent
    }
    /* Functions
     * ****************************************************************************************/

}
