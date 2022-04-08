#include "GenericGadgetListModel.hpp"

#include <algorithm>

using GenericGadgetListModelPrivate::PrivateListModel;

PrivateListModel::PrivateListModel(QObject* parent) : QAbstractListModel(parent) {}

auto PrivateListModel::rowCount(const QModelIndex& /*parent*/) const -> int {
  return data_.size();
}

auto PrivateListModel::data(const QModelIndex& index, int role) const -> QVariant {
  return dataAccessCallback_(QVariant::fromValue(data_.at(index.row())), role);
}

auto PrivateListModel::setRoleNames(const QStringList& roleNames) -> void {
  roleNames_ = QAbstractListModel::roleNames();
  int i = Qt::UserRole;
  for(auto const& roleName : roleNames) {
    roleNames_.insert(i++, roleName.toUtf8());
  }
}

auto PrivateListModel::insert(QVector<QVariant>::iterator before, QVector<QVariant>::const_iterator input_beg, QVector<QVariant>::const_iterator input_end) -> void {
  auto insertPos = std::distance(data_.begin(), before);
  auto count = std::distance(input_beg, input_end);
  beginInsertRows(QModelIndex(), insertPos, insertPos + count - 1);
  std::copy(input_beg, input_end, std::inserter(data_, before));
  endInsertRows();
  dataChanged(index(insertPos, 0), index(insertPos + count - 1, 0), { Qt::DisplayRole});
}

auto PrivateListModel::insert(QVector<QVariant>::iterator before, const QVariant& value) -> void {
  auto insertPos = std::distance(data_.begin(), before);
  beginInsertRows(QModelIndex(), insertPos, insertPos);
  data_.insert(before, value);
  endInsertRows();
  dataChanged(index(insertPos, 0), index(insertPos, 0), { Qt::DisplayRole});
}

auto PrivateListModel::insert(const int pos, const QVariant& value) -> void {
  insert(std::next(data_.begin(), pos), value);
}

auto PrivateListModel::append(const QVariant& value) -> void {
  insert(data_.end(), value);
}

auto PrivateListModel::roleNames() const -> QHash<int, QByteArray> {
  return roleNames_;
}
