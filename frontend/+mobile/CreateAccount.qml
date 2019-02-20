/**
 * Filename: CreateAccount.qml
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
import QtGraphicalEffects 1.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3

import "qrc:/Controls" as Controls

Rectangle {
    id: backgroundSignUp
    width: Screen.width
    height: Screen.height
    color: "#14161B"

    LinearGradient {
        anchors.fill: parent
        start: Qt.point(0, 0)
        end: Qt.point(0, parent.height)
        opacity: 0.05
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: maincolor }
        }
    }

    Image {
        id: largeLogo
        source: 'qrc:/icons/XBY_logo_large.svg'
        width: parent.width * 2
        height: (largeLogo.width / 75) * 65
        anchors.top: parent.top
        anchors.topMargin: 63
        anchors.right: parent.right
        opacity: 0.5
    }

    property int accountCreated: 0
    property int usernameWarning: 0
    property int passwordWarning1: 0
    property int passwordWarning2: 0
    property int availableUsername: 0
    property int signUpError: 0
    property int selectStorage: 0
    property int storageSwitchState: 0
    property int checkUsername : 0

    function validation(text){
        var regExp = /^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,}$/;
        if(regExp.test(text)) passwordWarning1 = 0;
        else passwordWarning1 = 1;
    }

    function usernameLength(text) {
        if (text.length <= 5) {
            usernameWarning = 3
        }
        else if (text.length >= 13) {
            usernameWarning = 4
        }
        else {
            usernameWarning = 0
        };
        if (userName.text == ""){
            usernameWarning = 0
        }
    }

    Flickable {
        id: scrollArea
        width: parent.width
        height: parent.height
        contentHeight: setupScrollArea.height
        anchors.left: parent.left
        anchors.top: parent.top
        boundsBehavior: Flickable.StopAtBounds
        state: (accountCreated == 0  || signUpError == 0)? "inView" : "hidden"


        states: [
            State {
                name: "inView"
                PropertyChanges { target: scrollArea; opacity: 1}
            },
            State {
                name: "hidden"
                PropertyChanges { target: scrollArea; opacity: 0}
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "*"
                NumberAnimation { target: scrollArea; property: "opacity"; duration: 200; easing.type: Easing.OutCubic}
            }
        ]

        Rectangle {
            id: setupScrollArea
            width: parent.width
            height: 800
            color: "transparent"

            Label {
                id: welcomeText
                text: "WELCOME TO XCITE"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 25
                color: maincolor
                font.pixelSize: 24
                font.family: xciteMobile.name
                font.bold: true
            }

            Label {
                id: createAccountText
                text: "Let's get started by creating an account"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: welcomeText.bottom
                color: "#F2F2F2"
                font.pixelSize: 18
                font.family: xciteMobile.name
            }

            Text {
                id: createUsernameText
                width: doubbleButtonWidth
                maximumLineCount: 3
                anchors.left: userName.left
                anchors.top: createAccountText.bottom
                anchors.topMargin: 40
                horizontalAlignment: Text.AlignJustify
                wrapMode: Text.WordWrap
                text: "Choose a username, only alphanumeric characters are allowed, no spaces, minimum 6 and no more than 12 characters"
                color: "#F2F2F2"
                font.pixelSize: 18
                font.family: xciteMobile.name
                visible: accountCreated == 0 && signUpError == 0
            }

            Controls.TextInput {
                id: userName
                height: 34
                width: doubbleButtonWidth
                placeholder: "USERNAME"
                text: ""
                mobile: 1
                deleteBtn: 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: createUsernameText.bottom
                anchors.topMargin: 10
                rightPadding: 34
                color: userName.text != "" ? "#F2F2F2" : "#727272"
                textBackground: "#0B0B09"
                font.pixelSize: 14

                onTextChanged: {
                    usernameLength(userName.text)
                    availableUsername = 0
                    checkUsername = 0
                }

                Image {
                    id: checkButton
                    source: 'qrc:/icons/icon-questionmark_01.svg'
                    height: 20
                    width: 13
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    visible: checkUsername == 0

                    Rectangle {
                        height: 34
                        width: 34
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: "transparent"

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                checkUsername = 1
                                userExists(userName.text)
                            }
                        }

                        Connections {
                            target: UserSettings
                            onUserAlreadyExists: {
                                usernameWarning = 1
                            }

                            onUsernameAvailable: {
                                availableUsername = 1
                                usernameWarning = 2
                            }

                            onSettingsServerError: {
                                networkError = 1
                            }
                        }
                    }
                }

                Image {
                    id: usernameOK
                    source: 'qrc:/icons/icon-ok_01.svg'
                    height: 20
                    width: 20
                    rotation: availableUsername == 1? 0 : 180
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 7
                    visible: checkUsername == 1
                }
            }

            Label {
                id: usernameWarningText1
                text: userName.text != ""? (usernameWarning == 0? "" : (usernameWarning == 1? "This Username already exists!" : (usernameWarning == 2? "Username unknown!": (usernameWarning == 3? "Username too short!" : (usernameWarning == 4? "Username too long" : ""))))) : ""
                color: usernameWarning == 2 ? "#4BBE2E" : "#FD2E2E"
                anchors.left: userName.left
                anchors.leftMargin: 5
                anchors.top: userName.bottom
                anchors.topMargin: 1
                font.pixelSize: 11
                font.family: "Brandon Grotesque"
                font.weight: Font.Normal
            }

            Text {
                id: createPasswordText
                width: doubbleButtonWidth
                maximumLineCount: 4
                anchors.left: createUsernameText.left
                anchors.top: userName.bottom
                anchors.topMargin: 20
                horizontalAlignment: Text.AlignJustify
                wrapMode: Text.WordWrap
                text: "Choose a password, it should contain at least one capital letter, one number and one special character, and it must be at least 8 characters long."
                color: "#F2F2F2"
                font.pixelSize: 18
                font.family: xciteMobile.name
            }

            Controls.TextInput {
                id: passWord1
                height: 34
                width: doubbleButtonWidth
                placeholder: "PASSWORD"
                text: ""
                mobile: 1
                echoMode: TextInput.Password
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: createPasswordText.bottom
                anchors.topMargin: 10
                color: passWord1.text != "" ? "#F2F2F2" : "#727272"
                textBackground: "#0B0B09"
                font.pixelSize: 14
                deleteBtn: passwordWarning1 == 0? 0 : 1

                onTextChanged: {
                    //check if password has valid format
                    validation(passWord1.text);
                }

                Image {
                    id: pass1OK
                    source: 'qrc:/icons/icon-ok_01.svg'
                    height: 20
                    width: 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 7
                    visible: passWord1.text != "" && passwordWarning1 == 0
                }
            }

            Label {
                id: passwordWarningText1
                text: passWord1.text != ""? (passwordWarning1 == 0? "" : (passwordWarning1 == 1? "This password does not have the correct format!": "")): ""
                color: "#FD2E2E"
                anchors.left: passWord1.left
                anchors.leftMargin: 5
                anchors.top: passWord1.bottom
                anchors.topMargin: 1
                font.pixelSize: 11
                font.family: "Brandon Grotesque"
                font.weight: Font.Normal
            }

            Controls.TextInput {
                id: passWord2
                height: 34
                width: doubbleButtonWidth
                placeholder: "RETYPE PASSWORD"
                text: ""
                mobile: 1
                echoMode: TextInput.Password
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: passWord1.bottom
                anchors.topMargin: 20
                color: passWord2.text != "" ? "#F2F2F2" : "#727272"
                textBackground: "#0B0B09"
                font.pixelSize: 14
                deleteBtn: passwordWarning2 == 0? 0 : 1

                onTextChanged: {
                    //check if passwords match
                    if (passWord2.text != passWord1.text){
                        passwordWarning2 = 1
                    }
                    else {
                        passwordWarning2 = 0
                    }
                }

                Image {
                    id: pass2OK
                    source: 'qrc:/icons/icon-ok_01.svg'
                    height: 20
                    width: 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 7
                    visible: passWord2.text != "" && passwordWarning2 == 0
                }
            }

            Label {
                id: passwordWarningText2
                text: passWord2.text != ""? (passwordWarning2 == 0? "" : (passwordWarning2 == 1? "The passwords don't match!": "")) : ""
                color: "#FD2E2E"
                anchors.left: passWord2.left
                anchors.leftMargin: 5
                anchors.top: passWord2.bottom
                anchors.topMargin: 1
                font.pixelSize: 11
                font.family: "Brandon Grotesque"
                font.weight: Font.Normal
            }

            Rectangle {
                id: createAccountButton
                width: doubbleButtonWidth
                height: 34
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: passWord2.bottom
                anchors.topMargin: 30
                color: "transparent"
                opacity: 0.5

                LinearGradient {
                    anchors.fill: parent
                    start: Qt.point(x, y)
                    end: Qt.point(x, parent.height)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 1.0; color: (availableUsername == 1 && passwordWarning1 == 0 && passwordWarning2 == 0 && userName.text != "" && passWord1.text != "" && passWord2.text != "")? maincolor : "#727272" }
                    }
                }


                MouseArea {
                    anchors.fill: parent

                    onPressed: {
                        click01.play()
                    }

                    onReleased: {
                        if (availableUsername == 1  && passwordWarning1 == 0 && passwordWarning2 == 0 && userName.text != "" && passWord1.text != "" && passWord2.text != "") {
                            createUser(userName.text, passWord1.text)
                        }
                    }
                }

                Connections {
                    target: UserSettings
                    onUserCreationSucceeded: {
                        userSettings.locale = "en_us"
                        userSettings.defaultCurrency = 0
                        userSettings.theme = "dark"
                        userSettings.pinlock = false
                        saveAppSettings()
                        addOwnContact();
                        var datamodel = []
                        for (var i = 0; i < contactList.count; ++i)
                            datamodel.push(contactList.get(i))

                        var contactListJson = JSON.stringify(datamodel)
                        saveContactList(contactListJson)
                        availableUsername = 0
                        networkError = 0
                        signUpError = 0
                        username = userName.text
                        newAccount = true
                        accountCreated = 1

                    }
                    onUserAlreadyExists: {
                        usernameWarning = 1
                        availableUsername = 0
                        passWord1.text = ""
                        passWord2.text = ""
                    }
                    onUserCreationFailed: {
                        if (networkError == 0) {
                            signUpError = 1
                            userName.text = ""
                            passWord1.text = ""
                            passWord2.text = ""
                        }
                    }
                    onSettingsServerError: {
                        networkError = 1
                        passWord1.text = ""
                        passWord2.text = ""
                    }
                }
            }

            Text {
                id: createButtonText
                text: "CREATE ACCOUNT"
                font.family: xciteMobile.name
                font.pointSize: 14
                color: (availableUsername == 1 && passwordWarning1 == 0 && passwordWarning2 == 0)? "#F2F2F2" : "#979797"
                font.bold: true
                anchors.horizontalCenter: createAccountButton.horizontalCenter
                anchors.verticalCenter: createAccountButton.verticalCenter
            }

            Rectangle {
                width: createAccountButton.width
                height: createAccountButton.height
                anchors.horizontalCenter: createAccountButton.horizontalCenter
                anchors.bottom: createAccountButton.bottom
                color: "transparent"
                opacity: 0.5
                border.width: 1
                border.color: (availableUsername == 1 && passwordWarning1 == 0 && passwordWarning2 == 0 && userName.text != "" && passWord1.text != "" && passWord2.text != "")? maincolor : "#979797"
            }

            Label {
                id: closeButtonLabel
                z:10
                text: "BACK"
                anchors.top: createAccountButton.bottom
                anchors.topMargin: 50
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 14
                font.family: "Brandon Grotesque"
                color: "#F2F2F2"
                visible: accountCreated == 0

                Rectangle{
                    id: closeButton
                    height: 34
                    width: darktheme == true? closeButtonLabel.width : doubbleButtonWidth
                    radius: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: "transparent"
                }

                MouseArea {
                    anchors.fill: closeButton

                    onClicked: {
                        loginTracker = 1
                        mainRoot.pop()
                        mainRoot.push("../Onboarding.qml")
                    }
                }
            }
        }
    }

    Rectangle {
        width: Screen.width
        height: Screen.height
        color: bgcolor
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: signUpError == 1 || accountCreated == 1

        MouseArea {
            anchors.fill: parent
        }
    }

    // Account creation failed

    Rectangle {
        id: accountFailed
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 325
        height: failedIcon.height + creationFailedLabel.height + closeFail.height + 130
        state: signUpError == 1? "up" : "down"
        color: "#14161B"


        states: [
            State {
                name: "up"
                PropertyChanges { target: accountFailed; anchors.verticalCenterOffset: 0}
            },
            State {
                name: "down"
                PropertyChanges { target: accountFailed; anchors.verticalCenterOffset: 1.5 * Screen.height}
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "*"
                NumberAnimation { target: accountFailed; property: "anchors.verticalCenterOffset"; duration: 300; easing.type: Easing.InOutCubic}
            }
        ]

        Image {
            id: failedIcon
            source: 'qrc:/icons/mobile/failed-icon_01_light.svg'
            height: 100
            width: 100
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: creationFailedLabel
            text: "Account creation failed!"
            anchors.top: failedIcon.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: failedIcon.horizontalCenter
            color: maincolor
            font.pixelSize: 14
            font.family: "Brandon Grotesque"
            font.bold: true
        }

        Rectangle {
            id: closeFail
            width: doubbleButtonWidth / 2
            height: 34
            color: maincolor
            opacity: 0.25
            anchors.top: creationFailedLabel.bottom
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: closeFail

                onPressed: {
                    parent.opacity = 0.5
                    click01.play()
                }

                onCanceled: {
                    parent.opacity = 0.25
                }

                onReleased: {
                    parent.opacity = 0.25
                }

                onClicked: {
                    signUpError = 0;

                }
            }
        }
        Text {
            text: "TRY AGAIN"
            font.family: "Brandon Grotesque"
            font.pointSize: 14
            font.bold: true
            color: darktheme == true? "#F2F2F2" : maincolor
            anchors.horizontalCenter: closeFail.horizontalCenter
            anchors.verticalCenter: closeFail.verticalCenter
        }

        Rectangle {
            width: closeFail.width
            height: 34
            anchors.bottom: closeFail.bottom
            anchors.left: closeFail.left
            color: "transparent"
            opacity: 0.5
            border.color: maincolor
            border.width: 1
        }
    }

    Rectangle {
        id: accountSuccess
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 325
        height: 270
        state: accountCreated == 1? "up" : "down"
        color: "#14161B"


        states: [
            State {
                name: "up"
                PropertyChanges { target: accountSuccess; anchors.verticalCenterOffset: 0}
            },
            State {
                name: "down"
                PropertyChanges { target: accountSuccess; anchors.verticalCenterOffset: 1.5 * Screen.height}
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "*"
                NumberAnimation { target: accountSuccess; property: "anchors.verticalCenterOffset"; duration: 300; easing.type: Easing.InOutCubic}
            }
        ]

        Label {
            id: welcomeUser
            text: "WELCOME " + username
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20
            color: maincolor
            font.pixelSize: 24
            font.family: xciteMobile.name
            font.bold: true
            visible: selectStorage == 0
        }

        Label {
            id: confirmCreation
            text: "Your account has been created."
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: welcomeUser.bottom
            anchors.topMargin: 10
            color: "#F2F2F2"
            font.pixelSize: 16
            font.family: xciteMobile.name
            visible: selectStorage == 0
        }

        Text {
            id: passwordWarning
            width: doubbleButtonWidth
            maximumLineCount: 4
            anchors.left: confirmAccountButton.left
            horizontalAlignment: Text.AlignJustify
            wrapMode: Text.WordWrap
            text: "<b>WARNING</b>: Do not forget to backup your password, THERE IS NO PASSWORD RECOVERY, without your password you cannot access your account!"
            anchors.bottom: confirmAccountButton.top
            anchors.bottomMargin: 15
            color: "#F2F2F2"
            font.pixelSize: 16
            font.family: xciteMobile.name
            visible: selectStorage == 0
        }

        Rectangle {
            id: confirmAccountButton
            width: doubbleButtonWidth
            height: 34
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            color: "transparent"
            opacity: 0.5
            visible: selectStorage == 0

            LinearGradient {
                anchors.fill: parent
                start: Qt.point(x, y)
                end: Qt.point(x, parent.height)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 1.0; color: "#0ED8D2" }
                }
            }


            MouseArea {
                anchors.fill: parent

                onPressed: {
                    click01.play()
                }

                onReleased: {
                    // save account status to server
                    selectStorage = 1
                    storageSwitchState = 0
                }
            }
        }

        Text {
            id: confirmButtonText
            text: "UNDERSTOOD"
            font.family: xciteMobile.name
            font.pointSize: 14
            color: "#F2F2F2"
            font.bold: true
            anchors.horizontalCenter: confirmAccountButton.horizontalCenter
            anchors.verticalCenter: confirmAccountButton.verticalCenter
            visible: selectStorage == 0
        }

        Rectangle {
            width: doubbleButtonWidth
            height: 34
            anchors.horizontalCenter: confirmAccountButton.horizontalCenter
            anchors.bottom: confirmAccountButton.bottom
            color: "transparent"
            opacity: 0.5
            border.width: 1
            border.color: "#0ED8D2"
            visible: selectStorage == 0
        }

        Item {
            id: addWalletText
            width: parent.width
            height : addWalletText1.height + addWalletText2.height + addWalletText3.height + storageSwitch.height + continueButton.height + 90
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -50
            visible: selectStorage = 1

            Label {
                id: addWalletText1
                width: doubbleButtonWidth
                maximumLineCount: 3
                anchors.left: continueButton.left
                horizontalAlignment: Text.AlignJustify
                wrapMode: Text.WordWrap
                text: "You can now add a wallet. You can choose to store your wallet keys on your device or in your account."
                anchors.top: parent.top
                color: themecolor
                font.pixelSize: 16
                font.family: xciteMobile.name
                font.bold: true
            }

            Label {
                id: addWalletText2
                width: doubbleButtonWidth
                maximumLineCount: 3
                anchors.left: continueButton.left
                horizontalAlignment: Text.AlignJustify
                wrapMode: Text.WordWrap
                text: "Storing your keys on your device will require you to import your keys in all the devices you wish to access your wallet from."
                anchors.top: addWalletText1.bottom
                anchors.topMargin: 20
                color: themecolor
                font.pixelSize: 16
                font.family: xciteMobile.name
                font.bold: true
            }

            Label {
                id: addWalletText3
                width: doubbleButtonWidth
                maximumLineCount: 3
                anchors.left: continueButton.left
                horizontalAlignment: Text.AlignJustify
                wrapMode: Text.WordWrap
                text: "Storing your keys in your account will alow you to access your wallet from any device running XCITE Mobile."
                anchors.top: addWalletText2.bottom
                anchors.topMargin: 20
                color: themecolor
                font.pixelSize: 16
                font.family: xciteMobile.name
                font.bold: true
            }

            Controls.Switch_mobile {
                id: storageSwitch
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: addWalletText3.bottom
                anchors.topMargin: 20
                state: storageSwitchState == 0 ? "off" : "on"


                onStateChanged: {
                    if (storageSwitch.state == "off") {
                        userSettings.localKeys = false
                    }
                    else {
                        userSettings.localKeys = true
                    }
                }
            }

            Text {
                id: receiveText
                text: "ACCOUNT"
                anchors.right: storageSwitch.left
                anchors.rightMargin: 7
                anchors.verticalCenter: storageSwitch.verticalCenter
                font.pixelSize: 14
                font.family: xciteMobile.name
                color: storageSwitch.on ? "#757575" : maincolor
            }

            Text {
                id: sendText
                text: "DEVICE"
                anchors.left: storageSwitch.right
                anchors.leftMargin: 7
                anchors.verticalCenter: storageSwitch.verticalCenter
                font.pixelSize: 14
                font.family: xciteMobile.name
                color: storageSwitch.on ? maincolor : "#757575"
            }

            Rectangle {
                id: continueButton
                width: doubbleButtonWidth
                height: 34
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: storageSwitch.bottom
                anchors.topMargin: 30
                color: "transparent"
                opacity: 0.5

                LinearGradient {
                    anchors.fill: parent
                    start: Qt.point(x, y)
                    end: Qt.point(x, parent.height)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 1.0; color: "#0ED8D2" }
                    }
                }


                MouseArea {
                    anchors.fill: parent

                    onPressed: {
                        click01.play()
                    }

                    onReleased: {
                        saveAppSettings()
                        mainRoot.pop()
                        mainRoot.push("../InitialSetup.qml")
                        accountCreated = 0
                        selectStorage = 0
                    }
                }
            }

            Text {
                id: continueButtonText
                text: "CONTINUE"
                font.family: xciteMobile.name
                font.pointSize: 14
                color: "#F2F2F2"
                font.bold: true
                anchors.horizontalCenter: continueButton.horizontalCenter
                anchors.verticalCenter: continueButton.verticalCenter
            }

            Rectangle {
                width: doubbleButtonWidth
                height: 34
                anchors.horizontalCenter: continueButton.horizontalCenter
                anchors.bottom: continueButton.bottom
                color: "transparent"
                opacity: 0.5
                border.width: 1
                border.color: "#0ED8D2"
            }
        }
    }

    Image {
        id: combinationMark
        source: 'qrc:/icons/xby_logo_TM.svg'
        height: 23.4
        width: 150
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
    }

    Rectangle {
        id: serverError
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        width: Screen.width
        height: 100
        state: networkError == 0? "up" : "down"
        color: "black"
        opacity: 0.9
        clip: true


        states: [
            State {
                name: "up"
                PropertyChanges { target: serverError; anchors.bottomMargin: 0}
                PropertyChanges { target: serverError; height: 0}
            },
            State {
                name: "down"
                PropertyChanges { target: serverError; anchors.bottomMargin: -100}
                PropertyChanges { target: serverError; height: 100}
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "*"
                NumberAnimation { target: serverError; property: "anchors.bottomMargin"; duration: 300; easing.type: Easing.InOutCubic}
            }
        ]

        Label {
            id: serverErrorText
            text: "A network error occured, please try again later."
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            color: "#FD2E2E"
            font.pixelSize: 18
            font.family: xciteMobile.name
        }

        Rectangle {
            id: okButton
            width: doubbleButtonWidth / 2
            height: 34
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            color: "#1B2934"
            opacity: 0.5

            LinearGradient {
                anchors.fill: parent
                source: parent
                start: Qt.point(x, y)
                end: Qt.point(x, parent.height)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 1.0; color: "#0ED8D2" }
                }
            }


            MouseArea {
                anchors.fill: parent

                onReleased: {
                    networkError = 0
                }
            }
        }

        Text {
            id: okButtonText
            text: "OK"
            font.family: xciteMobile.name
            font.pointSize: 14
            color: "#F2F2F2"
            font.bold: true
            anchors.horizontalCenter: okButton.horizontalCenter
            anchors.verticalCenter: okButton.verticalCenter
        }

        Rectangle {
            width: doubbleButtonWidth / 2
            height: 34
            anchors.horizontalCenter: okButton.horizontalCenter
            anchors.bottom: okButton.bottom
            color: "transparent"
            opacity: 0.5
            border.width: 1
            border.color: "#0ED8D2"
        }

        Rectangle {
            width: parent.width
            height: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            color: bgcolor
        }
    }
}
