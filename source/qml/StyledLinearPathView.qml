import QtQuick
import Qt5Compat.GraphicalEffects

/*
      requires declaration of:
        -property int index
        -property variant delegateData

      into the delegateComponent
*/

Item {
  function indexInRangeFromCurrent(idx, rangeSize) { return pathView.indexInRangeFromCurrent(idx, rangeSize) }

  property alias mainText: mainText.text
  property alias secondaryText: secondaryText.text
  property alias model: pathView.model
  property alias delegateComponent: pathView.delegateComponent
  property alias delegateSize: pathView.delegateSize
  property alias cachedImagesCount: pathView.cachedImagesCount
  property alias currentIndex: pathView.currentIndex
  property alias currentItem: pathView.currentItem
  property alias backgroundColor: background.color

  Rectangle {
    id: background
    anchors.fill: parent
  }

  Item {
    id: bluredPathViewWithBackground
    anchors.fill: parent
    visible: false

    Rectangle {
      anchors.fill: parent
      color: backgroundColor
    }

    FastBlur {
      x: pathView.x
      y: pathView.y
      width: pathView.width
      height: pathView.height
      source: pathView
      radius: 36
    }
  }

  FastBlur {
    id: bluredPathViewWithBluredBackground
    anchors.horizontalCenter: pathView.horizontalCenter
    anchors.top: pathView.bottom
    anchors.topMargin: -80
    width: pathView.width+40
    height: pathView.height
    source: bluredPathViewWithBackground
    radius: 36
    opacity: 0.18
    scale: 2.6
  }

  LinearPathView {
    id: pathView
    anchors.centerIn: parent
    delegateSize: 200
    cachedImagesCount: 100
  }

  Text {
    id: mainText
    anchors.horizontalCenter: pathView.horizontalCenter
    anchors.bottom: pathView.top
    anchors.bottomMargin: 60
    color: "#9a9db3"
    font.pointSize: 22
    font.bold: true
  }

  Text {
    id: secondaryText
    anchors.horizontalCenter: pathView.horizontalCenter
    anchors.top: mainText.bottom
    color: "#535975"
    font.pointSize: 16
  }
}




