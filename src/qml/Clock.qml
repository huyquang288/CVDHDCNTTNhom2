import QtQuick 2.4
import QtQuick.Controls 1.4
import "content" as Content

Item {
    id: wea

    Content.Clock {
        id: clo1
        scale: parent.width/width/1.7
        x: (parent.width- width)/2
        y: height*scale/2.6
        city: "Hà Nội"; shift: 7
    }

    Rectangle {
        id: worldClockList
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: parent.width
        height: parent.height- clo1.height*clo1.scale*1.1

        Image {
            anchors.fill: parent
            source: "qrc:/images/resources/images/rectangle.png"
        }

        ListView {
            id: clockview
            anchors.fill: parent
            orientation: ListView.Horizontal
            //cacheBuffer: 2000
            //snapMode: ListView.SnapOneItem
            highlightRangeMode: ListView.ApplyRange

            clip: true
            interactive: visible


            delegate: Content.Clock { city: cityName; shift: timeShift }
            model: ListModel {
                ListElement { cityName: "New York"; timeShift: -4 }
                ListElement { cityName: "London"; timeShift: 0 }
                ListElement { cityName: "Oslo"; timeShift: 1 }
                ListElement { cityName: "Mumbai"; timeShift: 5.5 }
                ListElement { cityName: "Tokyo"; timeShift: 9 }
                ListElement { cityName: "Brisbane"; timeShift: 10 }
                ListElement { cityName: "Los Angeles"; timeShift: -8 }
            }
        }
    }
}

