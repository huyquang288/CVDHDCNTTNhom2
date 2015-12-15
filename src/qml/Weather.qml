import QtQuick 2.4
import QtQuick.Controls 1.4
import "GetWeather.js" as GW

Item {
    id: wea

    property string firstNumberImageSource: (temperature<10) ?("qrc:/images/resources/images/numbers/" +temperature +".png") :("qrc:/images/resources/images/numbers/" +Math.floor(temperature/10) +".png")
    property string secondNumberImageSource: "qrc:/images/resources/images/numbers/" + temperature%10 +".png"
    property int temperature: 0;
    property string weatherIconSource
    property string weatherTextString
    property string t1Text;
    property string t2Text;
    property string t3Text;
    property string t4Text;


    Timer {
        running: true
        interval: 3000
        //repeat: true
        onTriggered: {
            GW.getWeather()
            temperature= GW.Ctemperature
        }
    }

    Timer {
        running: true
        interval: 10000
        //repeat: true
        onTriggered: {
            GW.getWeather()
            temperature= GW.Ctemperature
        }
    }

    Rectangle {
        id: square
        y: height/20
        x: parent.width*0.125
        width: parent.width*0.75
        height: width*0.925

        Image {
            source: "qrc:/images/resources/images/square.png"
            anchors.fill: parent
            opacity: 0.3
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            text: qsTr("Yahoo! Weather.")
            color: "#093e9b"
            font.pixelSize: wea.width/28
        }

        Text {
            id: location
            text: qsTr("Hà Nội - Việt Nam");
            anchors.top: parent.top
            anchors.topMargin: height/2
            anchors.left: parent.left
            anchors.leftMargin: height/2
            color: "#093e9b"
            font.pixelSize: wea.width/22
        }

        Image {
            id: weatherIcon
            source: weatherIconSource
            anchors.top: location.bottom
            anchors.topMargin: location.height/2
            anchors.left: parent.left
            anchors.leftMargin: (parent.width- weatherIcon.width/3- width- weatherText.width)/2
            height: location.height*3
            width: height
        }
        Text {
            id: weatherText
            text: weatherTextString
            x: (parent.width- width)/2
            color: "#093e9b"
            font.pixelSize: wea.width/26
            y: weatherIcon.y +(weatherIcon.height- height)/2
            anchors.left: weatherIcon.right
            anchors.leftMargin: weatherIcon.width/3
        }


        // hai chu so cua ngay duong lich
        Image {
            id: firstNumberImage
            width: wea.width/5.5
            height: width*1.6
            x: (temperature<10) ?(square.width- width- cencius.width)/2 :(square.width- width- secondNumberImage.width- cencius.width)/2
            anchors.top: weatherIcon.bottom
            anchors.topMargin: weatherText.height/2
            source: firstNumberImageSource
        }
        Image {
            id: secondNumberImage
            height: firstNumberImage.height
            width: firstNumberImage.width            
            visible: (temperature<10) ?false :true
            anchors.top: firstNumberImage.top
            anchors.left: firstNumberImage.right
            source: secondNumberImageSource
        }
        Image {
            id: cencius
            width: secondNumberImage.width/1.5
            height: width
            source: "qrc:/images/resources/images/cencius.png"
            anchors.left: (temperature<10) ?firstNumberImage.right :secondNumberImage.right
            anchors.top: secondNumberImage.top
            anchors.topMargin: height/4
            anchors.leftMargin: height/4
        }

    }
    Rectangle {
        id: nextDaysWeather
        width: parent.width
        height: width/5
        x: 0
        anchors.top: square.bottom
        anchors.topMargin: height*0.06
        Rectangle {
            width: parent.width/2
            height: parent.height/2
            anchors.top: parent.top
            anchors.left: parent.left
            Image {
                source: "qrc:/images/resources/images/rectangle.png"
                anchors.fill: parent
                opacity: 0.8
            }
            Text {
                id: t1
                text: t1Text
                anchors.centerIn: parent
                font.pixelSize: weatherText.font.pixelSize/1.2
                color: "#093e9b"
            }
        }

        Rectangle {
            width: parent.width/2
            height: parent.height/2
            anchors.top: parent.top
            anchors.right: parent.right
            Image {
                source: "qrc:/images/resources/images/rectangle.png"
                anchors.fill: parent
                opacity: 0.8
            }
            Text {
                id: t2
                text: t2Text
                anchors.centerIn: parent
                font.pixelSize: weatherText.font.pixelSize/1.2
                color: "#093e9b"
            }
        }

        Rectangle {
            width: parent.width/2
            height: parent.height/2
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            Image {
                source: "qrc:/images/resources/images/rectangle.png"
                anchors.fill: parent
                opacity: 0.8
            }
            Text {
                id: t3
                text: t3Text
                anchors.centerIn: parent
                font.pixelSize: weatherText.font.pixelSize/1.2
                color: "#093e9b"
            }
        }

        Rectangle {
            width: parent.width/2
            height: parent.height/2
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            Image {
                source: "qrc:/images/resources/images/rectangle.png"
                anchors.fill: parent
                opacity: 0.8
            }
            Text {
                id: t4
                text: t4Text
                anchors.centerIn: parent
                font.pixelSize: weatherText.font.pixelSize/1.2
                color: "#093e9b"
            }
        }
    }
}
