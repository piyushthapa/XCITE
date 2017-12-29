import QtQuick 2.0
import QtQuick.Layouts 1.3

PolygonalBackground {
    id: root

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 40
        Logo {
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            font.family: "Roboto Thin"
            text: qsTr("XCITE")
            font.pointSize: 30
            color: "#10B9C5"
            anchors.horizontalCenter: parent.horizontalCenter
            font.weight: Font.Thin
        }

        Text {
            font.family: "Roboto Thin"
            text: qsTr("Enter your email and we'll send you a reset link.")
            font.pointSize: 10
            color: "#FFFFFF"
            opacity: 0.9
            anchors.horizontalCenter: parent.horizontalCenter
        }

        BlueTextInput {
          anchors.horizontalCenter: parent.horizontalCenter
          placeholder: qsTr("john@email.com")
        }

        SimpleButton {
            text: qsTr("Send Link")
            backgroundColor: "transparent"
            hoverBackgroundColor: "#1A10B9C5"
            anchors.horizontalCenter: parent.horizontalCenter
            onButtonClicked: {
                mainRoot.replace("LoginForm.qml")
            }
        }

        PlainTextButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: (rememberedPasswordText.width + goBackText.width)
            onButtonClicked: {
                mainRoot.push("LoginForm.qml")
            }

            RowLayout {
                anchors.centerIn: parent

                Text {
                    id: rememberedPasswordText
                    text: qsTr("Remembered your password?")
                    font.family: "Roboto Thin"
                    font.pointSize: 10
                    color: "#FFFFFF"
                    opacity: 0.8
                }

                Text {
                    id: goBackText
                    text: qsTr("Go Back!")
                    font.family: "Roboto Thin"
                    font.pointSize: 10
                    color: "#28D4E0"
                    opacity: 0.8
                }
            }
        }
    }
}