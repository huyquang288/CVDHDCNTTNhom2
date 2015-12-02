import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import com.iktwo.qutelauncher 1.0
import "mainFunctions.js" as MF

ApplicationWindow {
    id: applicationWindow

    property int mouseEnteredX: -1
    property string currentTab: "calendar"

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

    ApplicationTile {
        id: applicationTile
        dragTarget: applicationTile
    }

    // menu cac icon
    Item {
        anchors {
            top: parent.top; topMargin: ScreenValues.statusBarHeight
            bottom: borderImageNavBar.top
            left: parent.left
            right: parent.right
        }

        ExpandableItem {
            id: explandableItem
            anchors.fill: parent

            ApplicationGrid {
                model: PackageManager
                anchors.fill: parent
                onPressAndHold: {
                    applicationTile.source = "image://icon/" + model.packageName
                    applicationTile.text = model.name
                    explandableItem.close()
                }
            }
        }
    }

    // day calendar tab
    DayCalendar {
        id: calendarTab
        x: 0
        anchors.top: parent.top;
        anchors.topMargin: ScreenValues.statusBarHeight*2
        width: parent.width
        height: parent.height*0.7
        visible: (currentTab==="calendar") ?true :false
    }

    Weather {
        id: weatherTab
        x: 0
        anchors.top: parent.top;
        anchors.topMargin: ScreenValues.statusBarHeight*2
        width: parent.width
        height: parent.height*0.7
        visible: (currentTab==="weather") ?true :false
    }



    function dragToLeft () {
        switch (currentTab) {
        case "calendar": {
            currentTab= "weather"
            return;
        }
        default: {
            return;
        }
        }
    }

    function dragToRight () {
        switch (currentTab) {
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
