import QtQuick

/*! ***********************************************************************************************
 * This is the abstract type of all gauges definitions
 *
 * ************************************************************************************************/
Item {
    id: root

    /* Property Declarations
     * ****************************************************************************************/

    //! Value
    property double value: 100.0

    //! Range Control
    property RangeControl rangeControl: RangeControl{}

    //! Background
    property Component background: Rectangle {
        implicitHeight: root.height
        implicitWidth: root.width
        color: "#1e1e1e"
        anchors.centerIn: parent
    }

    //! Major Tickmarks
    property Component tickmark: Rectangle {
            implicitWidth: outerRadius * 0.02
            antialiasing: true
            implicitHeight: outerRadius * 0.06
            color: "#c8c8c8"
            visible: true
        }

    //! Minor Tickmars
    property Component minorTickmark: Rectangle {
            implicitWidth: outerRadius * 0.01
            antialiasing: true
            implicitHeight: outerRadius * 0.03
            color: "#c8c8c8"
            visible: true
        }

    //! Tickmar Labels (major)
    property Component tickmarkLabel: Text {
            font.pixelSize: Math.max(6, 0.12 * outerRadius)
            text: "1"
            color: "#c8c8c8"
            antialiasing: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

    //! Needle
    property Component needle: null

    //! Needle Knob
    property Component needleKnob: null

    //! Foreground
    property Component foreground:  null

    /* Object Properties
     * ****************************************************************************************/


    /* Children
     * ****************************************************************************************/

    //! Background Loader
    Loader {
        id: backgroundLoader
        width: outerRadius * 2
        height: outerRadius * 2
        anchors.centerIn: parent
        sourceComponent: background
    }


    /* Functions
     * ****************************************************************************************/


}