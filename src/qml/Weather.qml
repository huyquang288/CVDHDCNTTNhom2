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


        // icon doi kieu nhiet do
        ImageButton {
            id: ctem
            width: firstNumberImage.width*0.8
            height: width
            anchors.left: parent.left
            anchors.leftMargin: (firstNumberImage.x- width)/2
            anchors.top: firstNumberImage.top
            anchors.topMargin: (firstNumberImage.height- height*2)/3
            source: "qrc:/images/resources/images/temperature/cactive.png"
            onPressed: opacity= 0.6
            onReleased: opacity= 1
            onClicked: {
                if (source==="qrc:/images/resources/images/temperature/cdeactive.png") {
                    source= "qrc:/images/resources/images/temperature/cactive.png"
                    ftem.source= "qrc:/images/resources/images/temperature/fdeactive.png"
                    temperature= GW.Ctemperature
                }
            }
        }
        ImageButton {
            id: ftem
            width: ctem.width
            height: width
            anchors.left: ctem.left
            anchors.top: ctem.bottom
            anchors.topMargin: (firstNumberImage.height- height*2)/3
            source: "qrc:/images/resources/images/temperature/fdeactive.png"
            onPressed: opacity= 0.6
            onReleased: opacity= 1
            onClicked: {
                if (source==="qrc:/images/resources/images/temperature/fdeactive.png") {
                    source= "qrc:/images/resources/images/temperature/factive.png"
                    ctem.source= "qrc:/images/resources/images/temperature/cdeactive.png"
                    temperature= GW.Ftemperature
                }
            }
        }


        // hai chu so cua ngay duong lich
        Image {
            id: firstNumberImage
            width: wea.width/5.5
            height: width*1.6
            x: (temperature<10) ?(square.width- width)/2 :(square.width- width- secondNumberImage.width)/2
            anchors.top: weatherIcon.bottom
            anchors.topMargin: weatherText.height
            source: firstNumberImageSource
        }
        Image {
            id: secondNumberImage
            height: firstNumberImage.height
            width: firstNumberImage.width
            y: firstNumberImage.y
            visible: (temperature<10) ?false :true
            x: (square.width- width- firstNumberImage.width)/2 + firstNumberImage.width
            source: secondNumberImageSource
        }

    }
    Rectangle {
        id: nextDaysWeather
        width: parent.width*0.95
        height: width/5
        x: parent.width*0.025
        anchors.top: square.bottom
        anchors.topMargin: height*0.06

        Image {
            source: "qrc:/images/resource/images/rectangle.png"
            anchors.fill: parent
        }
    }
}
