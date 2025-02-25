/*
 * Project: RoniaKit
 * Version: 1.0.0
 * License: Apache 2.0
 *
 * Copyright (c) 2023 Ronia AB
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import QtQuick 2.15
import QtQuick.Controls
import RoniaKit.Gauges
import RoniaKit

/*! ***********************************************************************************************
 * Circular basic Gauge Style
 * ************************************************************************************************/
Item
{
    id: control

    /* Property Declarations
     * ****************************************************************************************/    
    property  bool           backgroundVisible:        true

    property  bool           foregroundVisible:        true

    property  bool           overrideMajorTickmarks:   false

    property  bool           overrideMinorTickmarks:   false

    property  bool           overrideTickLabels:       false

    property  bool           overrideNeedle:           false

    property  bool           overrideNeedleKnob:       false

    property  bool           overrideName:             false

    property  bool           overrideValueNumber:      false

    property  var            backgroundMap:            ({})

    property  var            foregroundMap:            ({})

    property  var            majorTickmarkMap:         ({})

    property  var            minorTickmarkMap:         ({})

    property  var            labelMap:                 ({})

    property  var            needleMap:                ({})

    property  var            needleKnobMap:            ({})

    property  int            theme;

    required property double value

    property real            outerRadius

    property real                 minorInsetRadius:        outerRadius - rangeControl.minorTickmarkInset

    property real                 majorInsetRadius:        outerRadius - rangeControl.tickmarkInset

    property real                 labelInsetRadius:        outerRadius - rangeControl.labelInset

    property bool                 digitalValueVisibility : true

    property RangeControl         rangeControl : RangeControl{}

    property real needleRotation:
    {
        var percentage = (control.value - rangeControl.minimumValue) /
                         ( rangeControl.maximumValue -  rangeControl.minimumValue);

        rangeControl.startAngle + percentage *
                Math.abs(rangeControl.endAngle -  rangeControl.startAngle);
    }

    /* Object Properties
     * ****************************************************************************************/
    width: 250
    height: 250

    /* Font Loader
     * ****************************************************************************************/
    FontLoader {id: webFont; source: "qrc:/RoniaKit/assets/fonts/fontsFree-Net-DS-DIGI-1.ttf" }

    Component.onCompleted:
    {
        backgroundMap[CommonDefinitions.Theme.Light] = "#ffffff"
        backgroundMap[CommonDefinitions.Theme.Dark] = "#333333"

        labelMap[CommonDefinitions.Theme.Light] = "black"
        labelMap[CommonDefinitions.Theme.Dark] = "white"

        majorTickmarkMap[CommonDefinitions.Theme.Dark] = "#e5e5e5"
        majorTickmarkMap[CommonDefinitions.Theme.Light] = "#c8d0d0"

        minorTickmarkMap[CommonDefinitions.Theme.Dark] = "#e5e5e5"
        minorTickmarkMap[CommonDefinitions.Theme.Light] = "#c8d0d0"

        needleMap[CommonDefinitions.Theme.Dark] =  "qrc:/RoniaKit/Gauges/assets/images/redNeedle2.png"
        needleMap[CommonDefinitions.Theme.Light] = "qrc:/RoniaKit/Gauges/assets/images/redNeedle3.png"

        needleKnobMap[CommonDefinitions.Theme.Dark] =  "#ff2c2c"
        needleKnobMap[CommonDefinitions.Theme.Light] = "#ff6861"

        backgroundMapChanged();
        majorTickmarkMapChanged();
        minorTickmarkMapChanged();
        labelMapChanged();
        needleMapChanged();
        needleKnobMapChanged();
    }

    /* Components
     * ****************************************************************************************/

     property Component tickmark: Rectangle {
        implicitWidth: outerRadius * 0.02
        antialiasing: true
        implicitHeight: outerRadius * 0.06
        color: majorTickmarkMap[theme]
        visible: true
    }

    //! Minor Tickmars
    property Component minorTickmark: Rectangle {
        implicitWidth: outerRadius * 0.01
        antialiasing: true
        implicitHeight: outerRadius * 0.03
        color: minorTickmarkMap[theme]
        visible: true
    }

    property Component background: Rectangle {
        implicitHeight: parent.height
        implicitWidth: parent.width
        color: "transparent"
        anchors.centerIn: parent
        radius: width / 2
        Rectangle {
            implicitHeight: parent.height/2
            implicitWidth: parent.width/2
            color: "transparent"
            anchors.centerIn: parent
            radius: width / 2
            border.color: majorTickmarkMap[theme]
            border.width: 1

            Rectangle {
                implicitHeight: parent.height/ 3
                implicitWidth: parent.width/3
                color: majorTickmarkMap[theme]
                anchors.centerIn: parent
                radius: width / 2
                Rectangle {
                    implicitHeight: parent.height / 3
                    implicitWidth: parent.width / 3
                    color: needleKnobMap[theme]
                    anchors.centerIn: parent
                    radius: width / 2
                }
            }
        }
    }

    //! Foreground
    property Component foreground:  null

    //! Needle
    property Component needle: Item {
        implicitWidth: 0.08 * outerRadius
        implicitHeight: 0.8 * outerRadius

        Image {
            anchors.fill: parent
            source: needleMap[theme]
        }
    }

    //! Needle Knob
    property Component needleKnob: null

    /* Children
     * ****************************************************************************************/

    Loader
    {
        id: backgroundLoader

        visible: backgroundVisible
        width: outerRadius * 2
        height: outerRadius * 2
        anchors.centerIn: parent
        sourceComponent: background
    }

    //! Major TickMark Loader
    Loader
    {
        id: majorTickLoader

        visible: !overrideMajorTickmarks
        active: rangeControl.majorTickVisible
        width: control.majorInsetRadius * 2
        height: control.majorInsetRadius * 2
        anchors.centerIn: parent

        sourceComponent: Repeater
        {
            id: tickmarkRepeater

            property real p: Math.abs(rangeControl.endAngle  - rangeControl.startAngle)
                             / (tickmarkRepeater.model - 1)

            model: rangeControl.majorTickCount
            anchors.fill: parent

            delegate: Loader
            {
                id: tickmarkLoader

                x: control.majorInsetRadius
                y: control.majorInsetRadius
                sourceComponent: control.tickmark

                transform:
                [
                    Rotation
                    {
                        angle: (rangeControl.startAngle + 360 + (index * p) )
                    },

                    Translate
                    {
                        x: Math.sin((rangeControl.startAngle + 180 + index * p)
                                    * (Math.PI/180)) * control.majorInsetRadius * -1
                        y: Math.cos((rangeControl.startAngle + 180 + index * p)
                                    * (Math.PI/180)) * control.majorInsetRadius
                    }
                ]
            }
        }
    }

    //! Minor TickMark Loader
    Loader
    {
        visible: !overrideMinorTickmarks
        active: rangeControl.minorTickVisible
        width: control.minorInsetRadius * 2
        height: control.minorInsetRadius * 2
        anchors.centerIn: parent

        sourceComponent: Repeater
        {
            id: minortickmarkRepeater

            property real p: Math.abs(rangeControl.endAngle  - rangeControl.startAngle)
                             / (minortickmarkRepeater.model - 1)

            model: (rangeControl.majorTickCount - 1) * rangeControl.minorTickCount + rangeControl.majorTickCount
            anchors.fill: parent

            delegate: Loader
            {
                id: minorTickmarkLoader
                x: control.minorInsetRadius
                y: control.minorInsetRadius
                visible: !(index%(control.rangeControl.minorTickCount+1)===0)
                sourceComponent: control.minorTickmark

                transform:
                [
                    Rotation
                    {
                        angle: (rangeControl.startAngle + 360 + (index * p))
                    },

                    Translate
                    {
                        x: Math.sin((rangeControl.startAngle + 180 + index * p)
                                    * (Math.PI/180)) * control.minorInsetRadius * -1
                        y: Math.cos((rangeControl.startAngle + 180 + index * p)
                                    * (Math.PI/180)) * control.minorInsetRadius
                    }
                ]
            }
        }
    }

    //! Label Loader
    Loader
    {
        visible: !overrideTickLabels
        active: rangeControl.labelVisible
        width: control.labelInsetRadius * 2
        height: control.labelInsetRadius * 2
        anchors.centerIn: parent

        sourceComponent: Repeater
        {
            id: labelRepeater

            property real p: Math.abs(rangeControl.endAngle  - rangeControl.startAngle)
                             / (labelRepeater.model - 1)

            model: rangeControl.majorTickCount
            anchors.fill: parent

            delegate: Loader
            {
                id: labelLoader
                x: control.labelInsetRadius
                y: control.labelInsetRadius

                sourceComponent: Text
                {
                    font.pixelSize: Math.max(6, 0.1 * outerRadius)

                    text: Math.round((rangeControl.maximumValue
                                      - rangeControl.minimumValue)
                                      / (rangeControl.majorTickCount - 1)
                                      * index + rangeControl.minimumValue)

                    color: labelMap[theme] ?? "white"
                    antialiasing: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                transform:
                [
                    Rotation
                    {
                        angle: (rangeControl.startAngle - 3 + 360 + (index * p))
                    },

                    Translate
                    {
                        x: Math.sin((rangeControl.startAngle - 3 + 180 + index * p)
                                    * (Math.PI/180)) * control.labelInsetRadius * -1
                        y: Math.cos((rangeControl.startAngle - 3 + 180 + index * p )
                                    * (Math.PI/180)) * control.labelInsetRadius
                    }
                ]
            }
        }
    }

    //! Needle Loader
    Loader
    {
        id: needleLoader

        visible: !overrideNeedle
        sourceComponent: control.needle

        transform:
        [
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

    //! Foreground loader
    Loader
    {
        id: foregroundLoader

        visible: foregroundVisible
        width: outerRadius * 2
        height: outerRadius * 2
        anchors.centerIn: parent
        sourceComponent: foreground
    }

    /* Animations
     * ****************************************************************************************/

    Behavior on value
    {
        NumberAnimation
        {
            easing.overshoot: 1.2
            duration: 800
            easing.type: Easing.OutBack
        }
    }
}
