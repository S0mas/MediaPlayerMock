#pragma once
#include <QMetaProperty>
#include <QObject>
#include <QString>
#include <QUrl>

class MediaPlayerEntry {
  Q_GADGET
  Q_PROPERTY(QString artist_name MEMBER artist_name)
  Q_PROPERTY(QString song_title MEMBER song_title)
  Q_PROPERTY(QString album_title MEMBER album_title)
  Q_PROPERTY(QUrl album_art MEMBER album_art)
public:
  MediaPlayerEntry(){}
  QString artist_name;
  QString song_title;
  QString album_title;
  QUrl album_art;
};
