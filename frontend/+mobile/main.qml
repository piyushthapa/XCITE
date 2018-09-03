/**
 * Filename: main.qml
 *
 * XCITE is a secure platform utilizing the XTRABYTES Proof of Signature
 * blockchain protocol to host decentralized applications
 *
 * Copyright (c) 2017-2018 Zoltan Szabo & XTRABYTES developers
 *
 * This file is part of an XTRABYTES Ltd. project.
 *
 */
import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import Clipboard 1.0

ApplicationWindow {
    property bool isNetworkActive: false
    property string receivingAddress: "BM39fjwf093JF329f39fJFfa03987fja32"
    property string addressName1: "Posey"
    property string addressType1: "Main"
    property string receivingAddress2: "Bx33fjwf023JxoP9f39fJFfa0398wqWeJ9"
    property string addressName2: "Nrocy"
    property string addressType2: "Main"
    property string receivingAddress3: "B2o3fjwf02WIKoP9f3wxvmJFfa03wqWexc"
    property string addressName3: "Enervey"
    property string addressType3: "Main"
    property string receivingAddress4: "Bkf3019jzmkFAJowaj392JAFAlafj032jJ"
    property string addressName4: "Danny"
    property string addressType4: "Main"
    property string receivingAddress5: "BiJeija103JfjQWpdkl230fjFEI3019JKl"
    property string addressName5: "Golden"
    property string addressType5: "Main"
    id: xcite

    visible: true

    width: Screen.width
    height: Screen.height
    title: qsTr("XCITE")
    color: "#2B2C31"

    overlay.modal: Rectangle {
        color: "#c92a2c31"
    }

    StackView {
        id: mainRoot
        initialItem: DashboardForm {
        }
        anchors.fill: parent
    }

    Clipboard {
        id: clipboard
    }
}
