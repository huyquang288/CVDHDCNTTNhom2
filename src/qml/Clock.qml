import QtQuick 2.4
import QtQuick.Controls 1.4
import "content" as Content

Item {
    id: wea
    Rectangle {
        id: detailRectangle
        color: "white"
        anchors.fill: parent
        opacity: 0.9



        Content.Clock {
            id: clo1
            scale: parent.width/width
            anchors.top: parent.top
            anchors.topMargin: (parent.height- ((height*2- name1.height))*scale)/2.75
            anchors.left: parent.left
            anchors.leftMargin: (parent.width*0.2/3)*scale
            city: "Hà Nội"; shift: 7
        }

        Rectangle {
            id: square
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width
            height: parent.height- clo1.width*clo1.scale

            Image {
                anchors.fill: parent
                source: "qrc:/images/resources/images/rectangle.png"
            }

            ListView {

            }
        }
    }
}
