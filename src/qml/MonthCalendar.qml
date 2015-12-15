import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls 1.4
import org.qtproject.examples.calendar 1.0
import "ConvertDay.js" as CD

Item {
    id: monthCalendar

    SystemPalette {
        id: systemPalette
    }

    SqlEventModel {
        id: eventModel
    }

    Flow {
        id: row
        anchors.fill: parent

        spacing: 10
        layoutDirection: Qt.RightToLeft

        Calendar {
            id: calendar
            width: (parent.width > parent.height ? parent.width * 0.7 - parent.spacing : parent.width)
            height: (parent.height > parent.width ? parent.height * 0.7 - parent.spacing : parent.height)
            frameVisible: true
            weekNumbersVisible: true


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
                        color: (styleData.date !== undefined && styleData.selected) ?selectedDateColor :(dayColor(styleData.date) ?"#fc571b" :((styleData.date.getDay()===0 || styleData.date.getDay()===6)&&(styleData.visibleMonth && styleData.valid)) ?"#f7e8dc" :("transparent"))
                        anchors.margins: styleData.selected ? -1 : 0
                    }

                    Image {
                        visible: eventModel.eventsForDate(styleData.date).length > 0
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: -1
                        width: 30
                        height: width
                        source: "qrc:/images/resources/images/eventindicator.png"
                    }

                    Label {
                        id: dayDelegateText
                        text: styleData.date.getDate()
                        font.pixelSize: parent.height/3
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
                        text: CD.getDayForMonthCalendar(styleData.date.getDate(), styleData.date.getMonth()+1, styleData.date.getYear())
                        font.pixelSize: dayDelegateText.font.pixelSize/2
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

        Component {
            id: eventListHeader
            Column {
                id: eventDateColumn
                width: parent.width
                height: eventDateRow.height + globalEventDay.height+10
                spacing: 10
                Row {
                    id: eventDateRow
                    width: parent.width
                    height: eventDayLabel.height*1.1
                    spacing: 10

                    Label {
                        id: eventDayLabel
                        text: calendar.selectedDate.getDate()
                        font.pointSize: 40
                        color: "#2d2121"
                    }

                    Column {
                        height: eventDayLabel.height

                        Label {
                            readonly property var options: { weekday: "long" }
                            text: Qt.locale().standaloneDayName(calendar.selectedDate.getDay(), Locale.LongFormat)
                            font.pointSize: 20
                            color: "#2d2121"
                        }
                        Label {
                            text: Qt.locale().standaloneMonthName(calendar.selectedDate.getMonth())
                                  + calendar.selectedDate.toLocaleDateString(Qt.locale(), " yyyy")
                            font.pointSize: 13
                            color: "#2d2121"
                        }
                    }
                }
                Label {
                    id: globalEventDay
                    text: dayEvent (calendar.selectedDate);
                    font.pointSize: 22
                    wrapMode: Text.Wrap
                    color: "#ff7f00"
                }
            }
        }

        // danh sach su kien trong ngay
        Rectangle {
            width: (parent.width > parent.height ? parent.width * 0.3 - parent.spacing : parent.width)
            height: (parent.height > parent.width ? parent.height * 0.3 - parent.spacing : parent.height)
            border.color: Qt.darker(color, 1.2)



            ListView {
                id: eventsListView
                spacing: 15
                clip: true
                header: eventListHeader
                width: parent.width
                height: parent.height
                anchors.top: parent.top
                anchors.margins: 15
                model: eventModel.eventsForDate(calendar.selectedDate)

                delegate: Rectangle {
                    width: eventsListView.width
                    height: eventItemColumn.height
                    anchors.horizontalCenter: parent.horizontalCenter                   

                    Image {
                        anchors.top: parent.top
                        anchors.topMargin: 4
                        width: 20
                        height: width
                        source: "qrc:/images/resources/images/eventindicator.png"
                    }

//                    Rectangle {
//                        width: parent.width
//                        height: 1
//                        color: "#eee"
//                    }

                    Column {
                        id: eventItemColumn
                        anchors.left: parent.left
                        anchors.leftMargin: 25
                        anchors.right: parent.right
                        height: timeLabel.height + nameLabel.height + 35
                        spacing: 10

                        Label {
                            id: nameLabel
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: modelData.name
                            color: "#2d2121"
                            font.pixelSize: eventItemColumn.height/2.5
                        }
                        Label {
                            id: timeLabel
                            width: parent.width
                            wrapMode: Text.Wrap
                            font.pixelSize: nameLabel.font.pixelSize
                            text: modelData.startDate.toLocaleTimeString(calendar.locale, Locale.ShortFormat)
                            color: "#aaa"
                        }
                    }

                    ImageButton {
                        id: deleteButton
                        source: "qrc:/images/resources/images/delete.png"
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.rightMargin: width/3
                        anchors.topMargin: (parent.height- height)/2
                        height: parent.height/1.75
                        width: height/1.25
                        onClicked: {
                            var dat= calendar.selectedDate.getFullYear() +"-" +(calendar.selectedDate.getMonth()+1) +"-" +calendar.selectedDate.getDate();
                            var query= "delete from Event where startDate='" +dat.toString() +"' AND name= '" +nameLabel.text +"'";
                            console.log(query);
                            eventModel.editEvent(query);
                        }

                    }
                }
            }
        }

    }

    MouseArea {
        id: hideCalendarClickEvent
        anchors.fill: parent
        visible: setEventWindow.visible
    }

    Rectangle {
        id: setEventWindow
        width: parent.width/1.2
        height: width/2
        x: (parent.width- width)/2
        y: (parent.height- height)/2
        color: "grey"
        visible: false;        

        ImageButton {
            //anchors.fill: parent
            source: "qrc:/images/resources/images/cancel.png"
            anchors.top: parent.top
            anchors.right: parent.right
            height: parent.height/6
            width: height
            onClicked: {
                setEventWindow.visible= false
            }
        }

        Text {
            id: nameOfWindow
            text: qsTr("ĐẶT SỰ KIỆN")
            font.pixelSize: parent.height/6
            anchors.top: parent.top
            anchors.topMargin: font.pixelSize/2
            x: (parent.width- width)/2
            color: "white"
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
            color: "white"

        }
        TextArea {
            id: eventNameInput
            font.pixelSize: eventNameText.font.pixelSize/1.3
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
            color: "white"
            font.pixelSize: eventNameText.font.pixelSize
            anchors.left: eventNameText.left
            anchors.top: eventNameText.bottom
            anchors.topMargin: font.pixelSize/1.5
        }
        ComboBox {
            id: hour
            width: parent.width/5.5
            height: width/2.5
            anchors.bottom: eventDayText.bottom
            anchors.bottomMargin: -height/15
            anchors.left: eventNameInput.left
            scale: 1.3
            model: ["Giờ", 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21];
        }

        ComboBox {
            id: minute
            width: parent.width/4.5
            height: hour.height
            anchors.left: hour.right            
            anchors.leftMargin: width/3
            anchors.bottom: hour.bottom
            scale: 1.3
            model: ["Phút", 00,01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59];
        }

        Text {
            id: warning
            text: qsTr("THIẾU THÔNG TIN")
            color: "red"
            font.pixelSize: eventDayText.font.pixelSize*1.2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: height/4
            anchors.left: parent.left
            anchors.leftMargin: height/4
            visible: false
        }

        ImageButton {
            source: "qrc:/images/resources/images/ok.png"
            width: parent.width/4
            height: parent.height/5.5
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: height/4
            anchors.rightMargin: height/4
            onClicked: {
                if (eventNameInput.text=="" || hour.currentIndex==0 || minute.currentIndex==0) {
                    warning.visible= true;
                }
                else {
                    // luu vao csdl
                    var dat= calendar.selectedDate.getFullYear() +"-" +(calendar.selectedDate.getMonth()+1) +"-" +calendar.selectedDate.getDate();
                    var tim= (hour.currentIndex+5)*3600 +(minute.currentIndex-1)*60
                    var query= "insert into Event values('" +eventNameInput.text +"', '" +dat.toString() +"', " +tim.toString() +", '" +dat.toString() +"', "+(tim+1).toString() +")";
                    eventModel.editEvent(query);
                    hour.currentIndex= 0
                    minute.currentIndex= 0;
                    eventNameInput.text= "";
                    parent.visible= false;
                    warning.visible= false
                }
            }
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

    function dayColor (date) {
        var d= (date.getFullYear() +"-");
        d+= (date.getMonth()+1)
        d+= "-" +date.getDate();
        d= d.toString();
        console.log(d);
        switch (d) {
        case '2016-2-8': {
            return true
        }
        case '2016-2-9': {
            return true
        }
        case '2016-2-7': {
            return true
        }
        case '2016-2-6': {
            return true
        }
        case '2016-2-10': {
            return true
        }
        case '2016-1-1': {
            return true
        }
        case '2016-4-30': {
            return true
        }
        case '2016-4-10': {
            return true
        }
        case '2016-5-1': {
            return true
        }
        default: return false;
        }
    }

    function dayEvent (date) {
        var d= (date.getFullYear() +"-");
        d+= (date.getMonth()+1)
        d+= "-" +date.getDate();
        d= d.toString();
        console.log(d);
        switch (d) {
        case '2016-2-8': {
            return "Tết Âm Lịch"
        }
        case '2016-2-9': {
            return "Tết Âm Lịch"
        }
        case '2016-2-7': {
            return "Tết Âm Lịch"
        }
        case '2016-2-6': {
            return "Tết Âm Lịch"
        }
        case '2016-2-10': {
            return "Tết Âm Lịch"
        }
        case '2016-1-1': {
            return "Tết Dương Lịch"
        }
        case '2016-4-30': {
            return "Ngày Giải Phóng Miền Nam"
        }
        case '2016-4-10': {
            return "Giỗ Tổ Hùng Vương"
        }
        case '2016-5-1': {
            return "Ngày Quốc tế lao động"
        }
        default: return "";
        }
    }
}
