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

import QtQuick
import RoniaKit

/*! ***********************************************************************************************
 * This is the abstract type of all gauges definitions
 * ************************************************************************************************/
Item {
    id: root

    /* Property Declarations
     * ****************************************************************************************/

    //! Name
    property string       name:         "Name"

    //! Value
    property double       value:        100.0

    //! Outer radius
    property real         outerRadius:  0.0

    //! Theme
    property int          theme:        RoniaControl.Theme.Light

    //! Range Control
    property RangeControl rangeControl: RangeControl {}

    //! Style
    property Component    style:        null


    //! Theme Definitions
    enum Theme {
        Light = 0,
        Dark  = 1
    }

    /* Object Properties
     * ****************************************************************************************/


    /* Children
     * ****************************************************************************************/
    Loader {
        anchors.fill: parent
        sourceComponent: style
    }

    /* Functions
     * ****************************************************************************************/


}