import QtQuick

/*
      requires declaration of:
        -property int index
        -property variant delegateData

      into the delegateComponent
*/

PathView {
  id: root

  function indexInRangeFromCurrent(idx, rangeSize) {
    let toLeft = idx - rangeSize;
    let toRight = idx + rangeSize;

    if (currentIndex >= idx) {
      return toRight >= currentIndex
          || toLeft <= currentIndex - count
    }
    else if (currentIndex <= idx) {
      return toLeft <= currentIndex
          || toRight >= currentIndex + count
    }
    return false
  }

  property Component delegateComponent
  property int delegateSize: 200
  property int cachedImagesCount: 100

  width: Math.min(delegateSize * 2.1, delegateSize * count/2.2)
  height: delegateSize
  pathItemCount: 5
  preferredHighlightBegin: 0.5
  preferredHighlightEnd: 0.5
  highlightRangeMode: PathView.StrictlyEnforceRange

  path: Path {
    startX: 0; startY: root.height/2
    PathAttribute { name: "delegateZ"; value: 0 }
    PathAttribute { name: "delegateScale"; value: 0.65 }
    PathAttribute { name: "delegateAngle"; value: 40 }
    PathAttribute { name: "delegateOpacity"; value: 0.5 }

    PathLine { x: root.width/2 - 180; y: root.height/2; }
    PathAttribute { name: "delegateZ"; value: 1 }
    PathAttribute { name: "delegateScale"; value: 0.8 }
    PathAttribute { name: "delegateAngle"; value: 60 }
    PathAttribute { name: "delegateOpacity"; value: 1 }
    PathPercent { value: 0.20 }
    PathLine { x: root.width/2 + 180; y: root.height/2;  }
    PathAttribute { name: "delegateZ"; value: 1 }
    PathAttribute { name: "delegateScale"; value: 0.8 }
    PathAttribute { name: "delegateAngle"; value: -60 }
    PathAttribute { name: "delegateOpacity"; value: 1 }
    PathPercent { value: 0.80 }

    PathLine { x: root.width; y: root.height/2; }
    PathAttribute { name: "delegateZ"; value: 0 }
    PathAttribute { name: "delegateScale"; value: 0.65 }
    PathAttribute { name: "delegateAngle"; value: -40 }
    PathAttribute { name: "delegateOpacity"; value: 0.5 }
    PathPercent { value: 1 }
  }

  delegate: Item {
    id: delegateItem
    readonly property variant delegateItemData: model
    property double angle: PathView.isCurrentItem ? 0 : PathView.delegateAngle
    Behavior on angle { NumberAnimation { duration: 200 } }

    width: root.delegateSize
    height: root.delegateSize
    opacity: root.indexInRangeFromCurrent(index, 2) ? 1 : 0
    z: PathView.isCurrentItem ? 3 : PathView.delegateZ
    scale: PathView.isCurrentItem ? 1 : PathView.delegateScale
    transform: [
      Rotation {
        id: delegateRotation
        axis { x: 0; y: 1; z:0 }
        angle: delegateItem.angle
        origin.x: delegateItem.width/2
        origin.y: delegateItem.height/2
      }
    ]

    Loader {
      anchors.fill: parent
      sourceComponent: delegateComponent

      onSourceComponentChanged: {
        item.delegateData = model
        item.index = index
      }
    }

    MouseArea {
      anchors.fill: parent
      onClicked: root.currentIndex = index
    }
  }
}

