import QtQuick

Item {
  id: root

  function request() {
    const xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function() {
      if(xhr.readyState === XMLHttpRequest.DONE) {
        parseToModel(xhr.responseText)
      }
    }
    xhr.open("GET", "https://raw.githubusercontent.com/Currie32/500-Greatest-Albums/master/albumlist.csv")
    xhr.send()
  }

  function parseToModel(text) {
    let lines = text.match(/[^\r\n]+/g)
    for(let i = 1; i < lines.length; ++i) {
      mediaModel.append(mediaDataParser.parse(lines[i]))
    }
  }

  StyledLinearPathView {
    id: pathView

    anchors.fill: parent
    model: mediaModel
    backgroundColor: "#1e2433"
    delegateComponent: ImageEntryDelegate {
      property int index
      property variant delegateData

      cache: pathView.indexInRangeFromCurrent(index, pathView.cachedImagesCount/2)
      blurImage: !pathView.indexInRangeFromCurrent(index, 1)
      source: delegateData ? mediaImagesBaseUrl != "" ?  mediaImagesBaseUrl + "/artwork/" + delegateData.album_title : delegateData.album_art : ""

      MouseArea {
        anchors.fill: parent
        onClicked: pathView.currentIndex = index
      }
    }
    onCurrentItemChanged: {
      pathView.mainText = currentItem.delegateItemData.song_title
      pathView.secondaryText = currentItem.delegateItemData.album_title
    }
  }

  Rectangle {
    id: progressBar
    width: 200
    height: 10
    radius: 10
    anchors.horizontalCenter: pathView.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 180
    color: "#9a9db3"
  }

  Text {
    id: time
    anchors.horizontalCenter: pathView.horizontalCenter
    anchors.top: progressBar.bottom
    anchors.topMargin: 20
    text: "0:46"
    color: "#6d6f85"
    font.pointSize: 16
  }

  Component.onCompleted: request()
}




