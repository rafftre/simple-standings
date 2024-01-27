QT += qml quick
TARGET = standings
qtHaveModule(widgets) {
    QT += widgets
}

include(src/src.pri)

OTHER_FILES += \
    main.qml \
    StandingsItem.qml

RESOURCES += \
    resources.qrc
