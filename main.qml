import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.0

ApplicationWindow {
    id: root
    title: "Main Window"
    width: 800
    height: 600
    color: "white"

    property int defaultSpacing: 10
    property int viewerSpacing: viewer.height / 40

    property int maxPoints: 0

    property string bgColor: "#303030"
    property string posBgColor: "#558833"
    property string valBgColor: "#dddddd"
    property string posColor: "#303030"
    property string topBgColor: "orange"

    Action {
        id: exitAction
        text: "Esci"
        shortcut: "Ctrl+Q"
        onTriggered: Qt.quit();
        tooltip: "Esci dall'applicazione"
    }
    Action {
        id: toggleViewer
        text: viewer.visible ? "Nascondi visualizzatore" : "Mostra visualizzatore"
        shortcut: "Ctrl+V"
        onTriggered: { viewer.visible = !viewer.visible }
    }
    Action {
        id: toggleViewerFullscreen
        text: "Visualizzatore a tutto schermo"
        shortcut: "Ctrl+F"
        onTriggered: {
            if (viewer.visible) {
                if (viewer.visibility !== Window.Maximized) {
                    viewer.visibility = Window.Maximized;
                } else {
                    viewer.visibility = Window.Windowed;
                }
            }
        }
    }

    menuBar: MenuBar {
        Menu {
            title: "File"
            MenuItem {
                action: exitAction
            }
        }
        Menu {
            title: "Finestra"
            MenuItem {
                action: toggleViewer
            }
            MenuItem {
                action: toggleViewerFullscreen
                visible: viewer.visible
            }
        }
    }

    ListModel {
        id: nameModel
        ListElement { name: "Tavolo 1"; points: 0 }
        ListElement { name: "Tavolo 2"; points: 0 }
        ListElement { name: "Tavolo 3"; points: 0 }
        ListElement { name: "Tavolo 4"; points: 0 }
        ListElement { name: "Tavolo 5"; points: 0 }
        ListElement { name: "Tavolo 6"; points: 0 }
        ListElement { name: "Tavolo 7"; points: 0 }
        ListElement { name: "Tavolo 8"; points: 0 }
        ListElement { name: "Tavolo 9"; points: 0 }
        ListElement { name: "Tavolo 10"; points: 0 }
        ListElement { name: "Tavolo 11"; points: 0 }
        ListElement { name: "Tavolo 12"; points: 0 }
        ListElement { name: "Tavolo 13"; points: 0 }
        ListElement { name: "Tavolo 14"; points: 0 }
        ListElement { name: "Tavolo 15"; points: 0 }
        ListElement { name: "Tavolo 16"; points: 0 }
        ListElement { name: "Tavolo 17"; points: 0 }
        ListElement { name: "Tavolo 18"; points: 0 }
    }

    ListModel {
        id: sortedModel
    }

    function fillSortedModel() {
        sortedModel.clear();
        maxPoints = 0;
        for (var i = 0; i < nameModel.count; i++) {
            var item = nameModel.get(i);
            if (item.points > maxPoints) {
                maxPoints = item.points;
            }
            var j = 0;
            while (j < sortedModel.count) {
                if (item.points > sortedModel.get(j).points) {
                    sortedModel.insert(j, item);
                    break;
                }
                j += 1;
            }
            if (j == sortedModel.count) {
                sortedModel.append(item);
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: defaultSpacing

        Column {
            //anchors.centerIn: parent
            spacing: defaultSpacing

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 16
                text: "Inserisci i punteggi e clicca su 'Aggiorna' per aggiornare la classifica"
            }

            Grid {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: defaultSpacing
                columns: 2
                rows: 9
                spacing: defaultSpacing

                Repeater {
                    model: nameModel
                    Rectangle {
                        width: 360
                        height: 38
                        Text {
                            anchors.right: nameTextField.left
                            anchors.rightMargin: 5
                            font.pointSize: 24
                            text: (index + 1) + ":"
                        }
                        TextField {
                            id: nameTextField
                            anchors.right: pointsField.left
                            anchors.rightMargin: 5
                            font.pointSize: 24
                            width: 160
                            height: 38
                            maximumLength: 60
                            text: name
                            onTextChanged: { nameModel.get(index).name = text; }
                        }
                        SpinBox {
                            id: pointsField
                            anchors.right: parent.right
                            font.pointSize: 24
                            width: 120
                            height: 38
                            maximumValue: 1000000000
                            value: points
                            onValueChanged: { nameModel.get(index).points = value; }
                        }
                    }
                } // Repeater
            } // Grid

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Aggiorna"
                onClicked: {
                    fillSortedModel();
                    viewer.visible = true;
                }
            }
        } // Column
    } // Rectangle

    ApplicationWindow {
        id: viewer
        title: "Standings Viewer"
        width: 640
        height: 480
        //color: "white"
        visible: false

        onClosing: { visible: false }

        Rectangle {
            anchors.fill: parent
            color: bgColor

            Text {
                id: standingsLabel
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                font.pointSize: parent.height / 40
                color: "white"
                text: "Classifica"
            }

            Grid {
                //anchors.fill: parent
                anchors.top: standingsLabel.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: viewerSpacing
                columns: 2
                rows: 9
                spacing: viewerSpacing

                Repeater {
                    model: sortedModel

                    StandingsItem {
                        width: (parent.width - root.viewerSpacing) / 2
                        height: (parent.height - root.viewerSpacing * 8) / 9
                        spacing: root.viewerSpacing
                        posColor: root.posColor
                        posBgColor: root.posBgColor
                        valBgColor: (maxPoints > 0 && sortedModel.get(index) && sortedModel.get(index).points === maxPoints)
                                    ? root.topBgColor : root.valBgColor
                        num: (index + 1) + ""
                        text: name
                        points: sortedModel.get(index) ? sortedModel.get(index).points + "" : "0"
                    }
                } // Repeater
            } // Grid
        } // Rectangle

    } // viewer
}
