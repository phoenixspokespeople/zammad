# Copyright (C) 2012-2016 Zammad Foundation, http://zammad-foundation.org/

class Group < ApplicationModel
  include LogsActivityStream
  include NotifiesClients
  include LatestChangeObserved
  include Historisable

  has_and_belongs_to_many  :users
  has_and_belongs_to_many  :roles
  belongs_to               :email_address
  belongs_to               :signature
  validates                :name, presence: true

  activity_stream_permission 'admin.group'

=begin

get users of group

  group = Group.find(123)
  users = group.users('ro')

returns

  [user1, user2, ...]

=end

  def users(type = 'rw')
    User.joins(:groups)
        .where('groups_users.user_id = users.id')
        .where(groups_users: { group_id: id }, users: { active: true })
        .where('(groups_users.permission = ? OR groups_users.permission = ?)', type, 'rw')
        .order(:id)
  end

end
