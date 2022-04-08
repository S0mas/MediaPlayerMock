import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
  width: 1048
  height: 640
  visible: true
  color: "transparent"

  SwipeView {
    id: view
    anchors.fill: parent
    focus: true
    Keys.onPressed: function(event) {
      if (event.key === Qt.Key_K) {
        event.accepted = true;
        if (!currentIndex) {
          view.incrementCurrentIndex()
        }
        else {
          view.decrementCurrentIndex()
        }
      }
    }
    MediaPlayer {}
    ContactsList {}
  }
}
