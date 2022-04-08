#pragma once
#include <QAbstractListModel>
#include <QMetaProperty>
#include <QObject>
#include <QVariant>
#include <QVector>

namespace GenericGadgetListModelPrivate {
class PrivateListModel : public QAbstractListModel {
  Q_OBJECT
public:
  PrivateListModel(QObject* parent = nullptr);
  auto rowCount(const QModelIndex& parent = QModelIndex()) const -> int override;
  auto data(const QModelIndex& index, int role = Qt::UserRole) const -> QVariant override;

  auto insert(QVector<QVariant>::iterator before, const QVariant& value) -> void;
  auto insert(QVector<QVariant>::iterator before, QVector<QVariant>::const_iterator input_beg, QVector<QVariant>::const_iterator input_end) -> void;
  auto insert(const int pos, const QVariant& value) -> void;
  Q_INVOKABLE void append(const QVariant& value);
protected:
  auto roleNames() const -> QHash<int, QByteArray> override;
  auto setRoleNames(const QStringList& roleNames) -> void;
protected:
  QVector<QVariant> data_;
  QHash<int, QByteArray> roleNames_;
protected:
  std::function<QVariant(QVariant const&, int const role)> dataAccessCallback_ = nullptr;
};
}

template<typename T>
class GenericGadgetListModel : public GenericGadgetListModelPrivate::PrivateListModel {
private:
  typename T::QtGadgetHelper enforces_q_gadget() {}
public:
  GenericGadgetListModel() {
    populateRoleNames();
    initDataAccessCallback();
  }

private:
  void populateRoleNames() {
    QStringList propertiesNames;
    auto const& metaObj = T::staticMetaObject;
    for(int propertyIndex = 0; propertyIndex < metaObj.propertyCount(); ++propertyIndex) {
      propertiesNames << metaObj.property(propertyIndex).name();
    }
    setRoleNames(propertiesNames);
  }

  void initDataAccessCallback() {
    dataAccessCallback_ = [this](QVariant const& variant, int const role) {
      return role == Qt::DisplayRole ? variant : readGadgetProperty(variant, role);
    };
  }

  QVariant readGadgetProperty(QVariant const& variant, int const role) {
    auto const& metaObj = T::staticMetaObject;
    auto const propertyIndex = metaObj.indexOfProperty(roleNames()[role]);
    auto const property = metaObj.property(propertyIndex);

    auto const& item = variant.value<T>();
    return property.readOnGadget(&item);
  }
};
