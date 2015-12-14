import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls 1.4

Item {
    id: monthCalendar

    SystemPalette {
        id: systemPalette
    }

    Flow {
        id: row
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10
        layoutDirection: Qt.RightToLeft

        Calendar {
            id: calendar
            width: (parent.width > parent.height ? parent.width * 0.6 - parent.spacing : parent.width)
            height: (parent.height > parent.width ? parent.height * 0.6 - parent.spacing : parent.height)
            frameVisible: true
            weekNumbersVisible: true
            //selectedDate: new Date(2014, 0, 1)
            //focus: true


            style: CalendarStyle {
                gridVisible: false
                dayDelegate: Item {
                    readonly property color sameMonthDateTextColor: "#444"
                    readonly property color selectedDateColor: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                    readonly property color selectedDateTextColor: "white"
                    readonly property color differentMonthDateTextColor: "#bbb"
                    readonly property color invalidDatecolor: "#dddddd"

                    Rectangle {
                        anchors.fill: parent
                        border.color: "transparent"
                        color: styleData.date !== undefined && styleData.selected ? selectedDateColor : ((styleData.date.getDay()===0 || styleData.date.getDay()===6)&&(styleData.visibleMonth && styleData.valid)) ?"#f7e8dc" :("transparent")
                        anchors.margins: styleData.selected ? -1 : 0
                    }

                    Image {
                        visible: eventModel.eventsForDate(styleData.date).length > 0
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: -1
                        width: 12
                        height: width
                        source: "qrc:/images/eventindicator.png"
                    }

                    Label {
                        id: dayDelegateText
                        text: styleData.date.getDate()
                        anchors.centerIn: parent
                        color: {
                            var color = invalidDatecolor;
                            if (styleData.valid) {
                                // Date is within the valid range.
                                color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                if (styleData.selected) {
                                    color = selectedDateTextColor;
                                }
                            }
                            color;
                        }
                    }
                    Label {
                        id: smalltext
                        text: styleData.date.getDate() +30
                        font.pixelSize: dayDelegateText.font.pixelSize/1.3
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: height/4
                        anchors.right: parent.right
                        anchors.rightMargin: height/3
                        color: {
                            var color = invalidDatecolor;
                            if (styleData.valid) {
                                // Date is within the valid range.
                                color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                if (styleData.selected) {
                                    color = selectedDateTextColor;
                                }
                            }
                            color;
                        }
                    }
                }
            }
            onPressAndHold: {
                setEventWindow.visible= true;
                showSetEventWindow.start()

            }
        }
/*
        Component {
            id: eventListHeader

            Row {
                id: eventDateRow
                width: parent.width
                height: eventDayLabel.height
                spacing: 10

                Label {
                    id: eventDayLabel
                    text: calendar.selectedDate.getDate()
                    font.pointSize: 35
                }

                Column {
                    height: eventDayLabel.height

                    Label {
                        readonly property var options: { weekday: "long" }
                        text: Qt.locale().standaloneDayName(calendar.selectedDate.getDay(), Locale.LongFormat)
                        font.pointSize: 18
                    }
                    Label {
                        text: Qt.locale().standaloneMonthName(calendar.selectedDate.getMonth())
                              + calendar.selectedDate.toLocaleDateString(Qt.locale(), " yyyy")
                        font.pointSize: 12
                    }
                }
            }
        }

        Rectangle {
            width: (parent.width > parent.height ? parent.width * 0.4 - parent.spacing : parent.width)
            height: (parent.height > parent.width ? parent.height * 0.4 - parent.spacing : parent.height)
            border.color: Qt.darker(color, 1.2)

            ListView {
                id: eventsListView
                spacing: 4
                clip: true
                header: eventListHeader
                anchors.fill: parent
                anchors.margins: 10
                model: eventModel.eventsForDate(calendar.selectedDate)

                delegate: Rectangle {
                    width: eventsListView.width
                    height: eventItemColumn.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image {
                        anchors.top: parent.top
                        anchors.topMargin: 4
                        width: 12
                        height: width
                        source: "qrc:/images/eventindicator.png"
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#eee"
                    }

                    Column {
                        id: eventItemColumn
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        anchors.right: parent.right
                        height: timeLabel.height + nameLabel.height + 8

                        Label {
                            id: nameLabel
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: modelData.name
                        }
                        Label {
                            id: timeLabel
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: modelData.startDate.toLocaleTimeString(calendar.locale, Locale.ShortFormat)
                            color: "#aaa"
                        }
                    }
                }
            }
        }
        */
    }

    Rectangle {
        id: setEventWindow
        width: parent.width/1.5
        height: width/2.5
        x: (parent.height- width)/2
        y: (parent.height- height)/2
        color: "grey"
        visible: false;
        Image {
            //anchors.fill: parent
            source: ""

        }
        Text {
            id: nameOfWindow
            text: qsTr("ĐẶT SỰ KIỆN")
            font.pixelSize: parent.height/6
            anchors.top: parent.top
            anchors.topMargin: font.pixelSize/2
            x: (parent.width- width)/2
        }

        // dong ten su kien
        Text {
            id: eventNameText
            text: qsTr("Sự kiện: ")
            font.pixelSize: nameOfWindow.font.pixelSize/1.6
            anchors.top: nameOfWindow.bottom
            anchors.topMargin: font.pixelSize
            anchors.left: parent.left
            anchors.leftMargin: font.pixelSize/1.5

        }
        TextArea {
            id: eventNameInput
            font.pixelSize: eventNameText.font.pixelSize
            anchors.left: eventDayText.right
            anchors.leftMargin: font.pixelSize/2
            anchors.bottom: eventNameText.bottom
            height: font.pixelSize*1.7
            width: parent.width/1.5
            wrapMode: TextInput.Wrap
            focus: true
        }

        // dat ngay cho su kien
        Text {
            id: eventDayText
            text: qsTr("Thời gian: ")
            font.pixelSize: eventNameText.font.pixelSize
            anchors.left: eventNameText.left
            anchors.top: eventNameText.bottom
            anchors.topMargin: font.pixelSize/1.5
        }
        ComboBox {
            id: hour
            width: parent.width/7
            anchors.bottom: eventDayText.bottom
            anchors.left: eventNameInput.left
            model: ["Giờ", 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21];
        }

        ComboBox {
            id: minute
            width: parent.width/6
            anchors.left: hour.right
            anchors.leftMargin: width/2
            anchors.bottom: hour.bottom
            model: ["Phút", 00,01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59];
        }

        ImageButton {
            source: "qrc:/images/resources/images/ok.png"
            width: parent.width/3
            height: parent.height/4
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: height/4
            anchors.rightMargin: height/4


        }

    }


    NumberAnimation {
        id: showSetEventWindow
        target: setEventWindow
        property: "opacity"
        duration: 200
        easing.type: Easing.InOutQuad
        from: 0
        to: 1
    }
}
