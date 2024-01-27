import QtQuick 2.1

Rectangle {
    id: root
    width: 400
    height: 60

    property alias num: numText.text
    property alias text: nameText.text
    property alias points: pointsText.text

    property int spacing: 15
    property string posColor: "black"
    property string posBgColor: "lightgrey"
    property string valBgColor: "white"

    Rectangle {
        id: pos
        width: root.height
        height: root.height
        color: posBgColor
        Text {
            id: numText
            anchors.centerIn: pos
            font.pointSize: pos.height * 0.6
            //color: posColor
            text: "1"
        }
    }

    Rectangle {
        id: val
        anchors.left: pos.right
        width: root.width - root.height
        height: root.height
        color: valBgColor
        Text {
            id: nameText
            anchors.left: val.left
            anchors.verticalCenter: val.verticalCenter
            anchors.leftMargin: spacing
            font.pointSize: val.height * 0.4
            font.capitalization: Font.AllUppercase
            text: "name"
        }
        Text {
            id: pointsText
            anchors.right: val.right
            anchors.verticalCenter: val.verticalCenter
            anchors.rightMargin: spacing
            font.pointSize: val.height * 0.5
            text: "0"
        }
    }
}
