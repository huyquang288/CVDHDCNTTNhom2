import QtQuick 2.4
import QtQuick.Controls 1.4
import "DayCalendar.js" as DC
import "ConvertDay.js" as CD

Item {
    id: dayCal

    // bien ngay hom nay
    property date today: new Date ()

    // bien luu khi su kien vuot thay doi ngay thang xay ra.
    property date selectedDay: today

    // day la thu trong tuan
    property int dayToShow : today.getDay()
    property int dateToShow : today.getDate()
    property int monthToShow: today.getMonth()+1
    property int yearToShow: today.getFullYear()

    //source anh
    property string firstNumberImageSource: (dateToShow<10) ?("qrc:/images/resources/images/numbers/" +dateToShow +".png") :("qrc:/images/resources/images/numbers/" +Math.floor(dateToShow/10) +".png")
    property string secondNumberImageSource: "qrc:/images/resources/images/numbers/" + dateToShow%10 +".png"
    property string lunarDayImageSource: "qrc:/images/resources/images/12ConGiap/" +DC.chiForDayImage[(Math.floor(CD.jdFromDate(dateToShow,monthToShow, yearToShow)+1.5)%12)]  +".png"
    property string lunarYearImageSource: "qrc:/images/resources/images/12ConGiap/" +DC.chiForYearImage[(lunarYearNumber%12)] +".png"

    // luu gia tri ngay am lich
    property int lunarDayNumber: CD.getLunarDate(dateToShow, monthToShow, yearToShow)
    property int lunarMonthNumber: CD.getLunarMonth()
    property int lunarYearNumber: CD.getLunarYear()

    // su kien vuot trai, phai de chuyen ngay
    property double mouseEnteredX: -1;


    Rectangle {
        id: square
        y: height/50
        x: (parent.width- width)/2
        width: parent.width*0.77
        height: parent.height*0.77

        MouseArea {
            //id: mouseAreaForSolarDay;
            anchors.fill: parent
            //enabled: true;
            onEntered:  {
                mouseEnteredX= mouseX
                //mouseEnteredY= mouseY
            }

            onReleased: {
                // vuot sang trai
                if (Math.abs(mouseEnteredX- mouseX) >parent.width/3) {
                    if (mouseEnteredX- mouseX > parent.width/3) {
                        selectedDay= new Date(selectedDay.getTime() + 24*60*60*1000)
                    }
                    // vuot sang phai
                    else if (mouseX- mouseEnteredX > parent.width/3) {
                        selectedDay= new Date(selectedDay.getTime() - 24*60*60*1000)
                    }
                    changeDay();
                }
            }
        }

        Image {
            source: "qrc:/images/resources/images/square.png"
            anchors.fill: parent
            opacity: 0.3
        }

        // anh nam am lich
        Image {
            id: lunarYearImage
            source: lunarYearImageSource
            anchors.top: parent.top
            anchors.topMargin: height/10
            x: (square.width- solarMonthYear.width- width)/2
            height: dayCal.width/10.5
            width: height
        }

        // thang + nam duong lich
        Text {
            id: solarMonthYear
            color: "#227c04"
            font.pixelSize: dayCal.width/16
            anchors.bottom: lunarYearImage.bottom
            x: (square.width- width- lunarYearImage.width)/2 + lunarYearImage.width
            text: "Tháng " +monthToShow+ " Năm " + yearToShow
        }

        // thu*'
        Text {
            id: date
            anchors.top: solarMonthYear.bottom
            anchors.topMargin: solarMonthYear.height*0.1
            x: (square.width- width)/2
            font.pixelSize: dayCal.width/19
            color: "#f20707"
            text: DC.weekday[dayToShow]
        }

        // hai chu so cua ngay duong lich
        Image {
            id: firstNumberImage
            width: dayCal.width/5.5
            height: width*1.6
            x: (dateToShow<10) ?(square.width- width)/2 :(square.width- width- secondNumberImage.width)/2
            anchors.top: date.bottom
            anchors.topMargin: date.height/2
            source: firstNumberImageSource
        }
        Image {
            id: secondNumberImage
            height: firstNumberImage.height
            width: firstNumberImage.width
            y: firstNumberImage.y
            visible: (dateToShow<10) ?false :true
            x: (square.width- width- firstNumberImage.width)/2 + firstNumberImage.width
            source: secondNumberImageSource
        }

        // anh con giap dai dien cho ngay am lich
        Image {
            id: lunarDayImage
            source: lunarDayImageSource
            anchors.top: firstNumberImage.bottom
            anchors.topMargin: date.height/2
            x: (square.width- width)/2
            width: lunarYearImage.width*1.6
            height: width
        }
    }

    Image {
        source: "qrc:/images/resources/images/rectangle.png"
        y: day1.y- day1.height*0.25
        height: day3.y + day3.height*1.25- day1.y+ day1.height*0.25
        width: parent.width*0.9
        x: (parent.width- width)/2
        opacity: 0.8
    }

    // ngay
    Text {
        id: day1
        color: "#093e9b"
        font.pixelSize: dayCal.width/28
        text: qsTr("Ngày")
        anchors.top: square.bottom
        anchors.topMargin: square.height/22
        x: (parent.width/3- width)/2
    }
    Text {
        id: day2
        color: "#070777"
        font.pixelSize: solarMonthYear.font.pixelSize
        anchors.top: day1.bottom
        anchors.topMargin: font.pixelSize/10
        x: (parent.width/3- width)/2
        text: lunarDayNumber
    }
    Text {
        id: day3
        font.pixelSize: day1.font.pixelSize/1.1
        color: "#093e9b"
        text: DC.can[Math.floor(CD.jdFromDate(dateToShow, monthToShow, yearToShow) +9.5)%10] +" " +DC.chiForText[Math.floor(CD.jdFromDate(dateToShow, monthToShow, yearToShow) +1.5)%12]
        anchors.top: day2.bottom
        anchors.topMargin: font.pixelSize/10
        x: (parent.width/3- width)/2
    }

    // thang
    Text {
        id: mon1
        color: "#093e9b"
        font.pixelSize: day1.font.pixelSize
        text: qsTr("Tháng")
        anchors.top: day1.top
        anchors.topMargin: font.pixelSize/10
        x: (parent.width/3- width)/2 +parent.width/3
    }
    Text {
        id: mon2
        color: "#070777"
        font.pixelSize: solarMonthYear.font.pixelSize
        anchors.top: mon1.bottom
        anchors.topMargin: font.pixelSize/10
        x: (parent.width/3- width)/2 +parent.width/3
        text: lunarMonthNumber
    }
    Text {
        color: "#093e9b"
        text: DC.can[(lunarYearNumber*12+lunarMonthNumber+3)%10] +" " +DC.chiForText[(lunarMonthNumber+1)%12]
        anchors.top: mon2.bottom
        anchors.topMargin: font.pixelSize/10
        x: (parent.width/3- width)/2 +parent.width/3
        font.pixelSize: day1.font.pixelSize/1.1
    }

    // nam
    Text {
        id: yea1
        color: "#093e9b"
        font.pixelSize: day1.font.pixelSize
        text: qsTr("Năm")
        anchors.top: day1.top
        anchors.topMargin: font.pixelSize/10
        x: (parent.width/3- width)/2 +parent.width/3*2
    }
    Text {
        id: yea2
        color: "#070777"
        font.pixelSize: solarMonthYear.font.pixelSize
        anchors.top: yea1.bottom
        anchors.topMargin: font.pixelSize/10
        x: (parent.width/3- width)/2 +parent.width/3*2
        text: lunarYearNumber
    }
    Text {
        color: "#093e9b"
        text: DC.can[(lunarYearNumber+6)%10] +" " +DC.chiForText[(lunarYearNumber+8)%12]
        anchors.top: yea2.bottom
        anchors.topMargin: font.pixelSize/10
        x: (parent.width/3- width)/2 +parent.width/3*2
        font.pixelSize: day1.font.pixelSize/1.1
    }



    function changeDay() {
        // thay doi gia tri cua cac thong so hien thi tren man hinh
        // day la thu trong tuan
        dayToShow = selectedDay.getDay()
        dateToShow = selectedDay.getDate()
        monthToShow= selectedDay.getMonth()+1
        yearToShow= selectedDay.getFullYear()

        //source anh
        firstNumberImageSource= (dateToShow<10) ?("qrc:/images/resources/images/numbers/" +dateToShow +".png") :("qrc:/images/resources/images/numbers/" +Math.floor(dateToShow/10) +".png")
        secondNumberImageSource= "qrc:/images/resources/images/numbers/" + dateToShow%10 +".png"
        lunarDayImageSource= "qrc:/images/resources/images/12ConGiap/" +DC.chiForDayImage[(Math.floor(CD.jdFromDate(dateToShow,monthToShow, yearToShow)+1.5)%12)]  +".png"
        lunarYearImageSource= "qrc:/images/resources/images/12ConGiap/" +DC.chiForYearImage[(lunarYearNumber%12)] +".png"

        // luu gia tri ngay am lich
        lunarDayNumber= CD.getLunarDate(dateToShow, monthToShow, yearToShow)
        lunarMonthNumber= CD.getLunarMonth()
        lunarYearNumber= CD.getLunarYear()

        // xoa su kien luu dien bat dau cua su kien vuot
        mouseEnteredX= -1;
    }

}

