#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "ContactListEntry.hpp"
#include "GenericGadgetListModel.hpp"
#include "MediaPlayerDataParser.hpp"
#include "MediaPlayerEntry.hpp"

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  QQmlApplicationEngine engine;

  GenericGadgetListModel<MediaPlayerEntry> mediaModel;
  MediaPlayerDataParser parser;

  GenericGadgetListModel<ContactListEntry> contactModel;
  QStringList names {"Adam", "Dawid", "Marzena", "Magda", "Rurek", "Kokosz", "Jan"};
  QVector<int> phoneNumbers {512512152, 678934572, 678512152, 457512152, 893512152, 751512152, 681512152};

  for(int i = 0; i < names.count(); ++i) {
    ContactListEntry entry;
    entry.name = names.at(i);
    entry.surname = QString("%1Surname").arg(entry.name);
    entry.phone_number = phoneNumbers.at(i);
    entry.avatar = QString("qrc:/resources/images/avatar%1.jfif").arg(i%2);
    contactModel.append(QVariant::fromValue(entry));
  }

  engine.rootContext()->setContextProperty("mediaModel", &mediaModel);
  engine.rootContext()->setContextProperty("mediaDataParser", &parser);
  engine.rootContext()->setContextProperty("mediaImagesBaseUrl", ""); // add baseUrl to fetch images for mediaModel
  engine.rootContext()->setContextProperty("contactModel", &contactModel);

  const QUrl url(QStringLiteral("qrc:/source/qml/main.qml"));
  QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                   &app, [url](QObject *obj, const QUrl &objUrl) {
    if (!obj && url == objUrl)
      QCoreApplication::exit(-1);
  }, Qt::QueuedConnection);
  engine.load(url);

  return app.exec();
}
