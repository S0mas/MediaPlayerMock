#pragma once
#include <QObject>
#include <QString>
#include <QUrl>

class ContactListEntry {
  Q_GADGET
  Q_PROPERTY(QString name MEMBER name)
  Q_PROPERTY(QString surname MEMBER surname)
  Q_PROPERTY(int phone_number MEMBER phone_number)
  Q_PROPERTY(QUrl avatar MEMBER avatar)
public:
  QString name;
  QString surname;
  int phone_number;
  QUrl avatar;
};
