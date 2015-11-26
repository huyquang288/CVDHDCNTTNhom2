import QtQuick 2.4

Item{
    id: imagebutton
    property string source
    signal clicked()
    signal released()
    signal pressed()

    Image {
        id: image
        width: parent.width
        height: parent.height
        MouseArea {
            id: mousebutton
            anchors.fill: parent
            onClicked: imagebutton.clicked();
            onReleased: imagebutton.released()
            onPressed: imagebutton.pressed()
        }
        source: imagebutton.source
    }

}//end item
