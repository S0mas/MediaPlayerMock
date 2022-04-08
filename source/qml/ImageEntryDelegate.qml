import QtQuick
import Qt5Compat.GraphicalEffects

Item {
  property alias source: image.source
  property alias cache: image.cache
  property bool blurImage: false

  Image {
    id: image
    anchors.fill: parent
    visible: false
  }

  Rectangle {
    id: mask
    width: image.width
    height: image.height
    radius: 10
    visible: false
  }

  FastBlur {
    id: blurredImage
    anchors.fill: parent
    source: image
    radius: 36
    visible: false
  }

  OpacityMask {
    id: maskedImage
    anchors.fill: parent
    source: image
    maskSource: mask
  }

  OpacityMask {
    id: blurredMaskedImage
    anchors.fill: parent
    source: blurredImage
    maskSource: mask
    opacity: blurImage ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 200 } }
  }

  Behavior on scale { NumberAnimation { duration: 200 } }
  Behavior on opacity { NumberAnimation { duration: 200 } }
}

