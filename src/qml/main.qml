import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import com.iktwo.qutelauncher 1.0
import "mainFunctions.js" as MF

ApplicationWindow {
    id: applicationWindow

    property int mouseEnteredX: -1
    property string currentTab: "month"

    property bool isWindowActive: Qt.application.state === Qt.ApplicationActive
    property int dpi: Screen.pixelDensity * 25.4

    property var resolutions: [
        {"height": 480, "width": 320}, // HVGA
        {"height": 640, "width": 480}, // VGA
        {"height": 800, "width": 480}, // WVGA
        {"height": 800, "width": 600}, // SVGA
        {"height": 640, "width": 360}, // nHD
        {"height": 960, "width": 540}  // qHD
    ]

    property int currentResolution: 3
    property bool isScreenPortrait: height >= width
    property bool activeScreen: Qt.application.state === Qt.ApplicationActive

    property int tilesHorizontally: getNumberOfTilesHorizontally(isScreenPortrait)
    property int tilesVertically: getNumberOfTilesVertically(isScreenPortrait)


    function getNumberOfTilesHorizontally(isScreenPortrait) {
        if (isScreenPortrait) {
            if (ScreenValues.isTablet) {
                return 5
            } else {
                return 4
            }
        } else {
            if (ScreenValues.isTablet) {
                return 6
            } else {
                return 4
            }
        }
    }

    function getNumberOfTilesVertically(isScreenPortrait) {
        if (isScreenPortrait) {
            return 6
        } else {
            if (ScreenValues.isTablet) {
                return 5
            } else {
                return 4
            }
        }
    }


    color: "#00000000"

    width: resolutions[currentResolution].width
    height: resolutions[currentResolution].height

    visible: true

    onActiveScreenChanged: {
        if (activeScreen)
            ScreenValues.updateScreenValues()
    }

    FocusScope {
        id: backKeyHandler
        height: 1
        width: 1
        focus: true
/*
        Keys.onAsteriskPressed: {
            if (explandableItem.isOpened) {
                explandableItem.close()
            }
        }

        Keys.onBackPressed: {
            if (explandableItem.isOpened) {
                explandableItem.close()
            }
        }
*/
    }

    Timer {
        interval: 550
        running: true
        onTriggered: {
            PackageManager.registerBroadcast()
        }
    }


    BorderImage  {
        id: borderImageStatusBar
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: ScreenValues.statusBarHeight

        source: "qrc:/images/shadow"
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
    }

    BorderImage  {
        id: borderImageNavBar

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: ScreenValues.navBarVisible ? ScreenValues.navigationBarHeight : 0
        source: ScreenValues.navBarVisible ? "qrc:/images/shadow_navigationbar" : ""

        border {
            left: 5; top: 5
            right: 5; bottom: 5
        }
    }

    /*
    GridView {
        /// TODO: verify in landscape mode
        anchors {
            top: parent.top; topMargin: ScreenValues.statusBarHeight
            left: parent.left
            right: parent.right
        }

        height: 4 * (80 * ScreenValues.dp)
        model: 16
        interactive: false
        cellHeight: height / 4
        cellWidth: width / 4

        delegate: DropArea {
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight
        }
    }
    */

    /*
    IntroView {
        anchors.fill: parent

        enabled: false
        visible: false

        model: ListModel {
            ListElement { backgroundColor: "#1abd9c" }
            ListElement { backgroundColor: "#2fcd72" }
        }
    }
    */


/*
    Row {
        id: rowFavorites

        anchors.bottom: borderImageNavBar.top

        height: 80 * ScreenValues.dp

        Repeater {
            model: 5

            DropArea {
                width: 80 * ScreenValues.dp
                height: 80 * ScreenValues.dp
            }
        }
    }
*/

    MouseArea {
        anchors.fill: parent
        onDoubleClicked: {
            currentTab="month"
            rightButton.visible=true;
            leftButton.visible= false
        }
    }

    ApplicationTile {
        id: applicationTile
        dragTarget: applicationTile
    }

    // menu cac icon
    Item {
        anchors {
            top: monthTab.bottom
            bottom: borderImageNavBar.top
            topMargin: parent.height*0.015
            left: parent.left
            right: parent.right
        }
        Image {
            source: "qrc:/images/resources/images/rectangle.png"
            anchors.fill: parent
            opacity: 0.85
        }
        ApplicationGrid {
            model: PackageManager
            anchors.fill: parent
            /*
            onPressAndHold: {
                applicationTile.source = "image://icon/" + model.packageName
                applicationTile.text = model.name
                explandableItem.close()
            }
            */

        }
    }




    ImageButton {
        id: leftButton
        source: "qrc:/images/resources/images/left.png"
        anchors.top: monthTab.top
        x: 0
        height: monthTab.height
        width: parent.width*0.06
        visible: (currentTab=="month") ?false :true
        opacity: 0.7
        onClicked: {
            leftButtonClick()
        }
    }

    ImageButton {
        id: rightButton
        source: "qrc:/images/resources/images/right.png"
        anchors.top: monthTab.top
        anchors.left: monthTab.right
        height: monthTab.height
        width: leftButton.width
        opacity: 0.7
        onClicked: {
            leftButton.visible=true
            rightButtonClick()
        }
    }

    // day calendar tab
    MonthCalendar {
        id: monthTab
        x: 0
        anchors.top: borderImageStatusBar.bottom
        width: parent.width*0.94
        height: parent.height*0.515
        opacity: 0.9
        visible: (currentTab==="month") ?true :false        
    }

    Clock {
        id: clockTab
        anchors.left: leftButton.right
        anchors.top: borderImageStatusBar.bottom
        width: parent.width*0.88
        height: parent.height*0.515
        opacity: 0.9
        visible: (currentTab==="clock") ?true :false        
    }

    DayCalendar {
        id: calendarTab
        x: clockTab.x
        anchors.top: clockTab.top
        width: clockTab.width
        height: clockTab.height
        opacity: clockTab.opacity
        visible: (currentTab==="calendar") ?true :false        
    }

    Weather {
        id: weatherTab
        x: clockTab.x
        anchors.top: clockTab.top
        width: clockTab.width
        height: clockTab.height
        opacity: clockTab.opacity
        visible: (currentTab==="weather") ?true :false
    }


    function rightButtonClick () {
        switch (currentTab) {
        case "month": {
            currentTab= "clock"
            return;
        }
        case "clock": {
            currentTab= "calendar"
            return;
        }
        case "calendar": {
            currentTab= "weather"
            return;
        }
        case "weather": {
            currentTab=""
            leftButton.visible=false
            rightButton.visible=false
            return;
        }
        default: {
            return;
        }
        }
    }

    function leftButtonClick () {
        switch (currentTab) {
        case "calendar": {
            currentTab= "clock"
            return;
        }
        case "clock": {
            currentTab= "month"
            return;
        }
        case "weather": {
            currentTab= "calendar"
            return;
        }
        default: {
            return;
        }
        }
    }

}
