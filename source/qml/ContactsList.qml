import QtQuick

Item {
  StyledLinearPathView {
    id: pathView

    anchors.fill: parent
    model: contactModel
    backgroundColor: "#1e2433"
    delegateComponent: ImageEntryDelegate {
      property int index
      property variant delegateData

      cache: pathView.indexInRangeFromCurrent(index, pathView.cachedImagesCount/2)
      blurImage: !pathView.indexInRangeFromCurrent(index, 1)
      source: delegateData ? delegateData.avatar : ""  // replace when mediaImagesBaseUrl is set in main.cpp: mediaImagesBaseUrl + "/artwork/" + delegateData.album_title
    }
    onCurrentItemChanged: {
      pathView.mainText = currentItem.delegateItemData.name + " " + currentItem.delegateItemData.surname
      pathView.secondaryText = currentItem.delegateItemData.phone_number
    }
  }
}




