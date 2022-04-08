#pragma once
#include <QObject>

#include "MediaPlayerEntry.hpp"

class MediaPlayerDataParser : public QObject {
  Q_OBJECT
public:
  inline static int i = 0;
  Q_INVOKABLE MediaPlayerEntry parse(QString str) const {
    MediaPlayerEntry entry;
    entry.album_art =  QString("qrc:/resources/images/player_cover_0%1.png").arg(i++%7 + 1);
    entry.song_title = "TENTS ON FIRE";
    auto tokens = str.split(',');
    if (tokens.size() > 2) {
      entry.album_title = tokens.at(2);
      if (tokens.size() > 3) {
        entry.artist_name = tokens.at(3);
      }
    }
    return entry;
  }
};
