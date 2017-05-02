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
  users = group.users('read')

returns

  [user1, user2, ...]

=end

  def users(type = 'all')
    user_group_ids = User.joins(:groups)
                         .where('groups_users.user_id = users.id')
                         .where(groups_users: { group_id: id }, users: { active: true })
                         .where('(groups_users.permission = ? OR groups_users.permission = ?)', type, 'all')
                         .order(:id)
                         .pluck('users.id')
    roles = Role.joins(:groups)
                .where(groups_roles: { group_id: id }, roles: { active: true } )
                .where('(groups_roles.permission = ? OR groups_roles.permission = ?)', type, 'all')
                .order(:id)
                .distinct('roles.id')
    roles.each { |role|
      user_group_ids = user_group_ids.concat(role.user_ids)
    }
    # user_role_ids = User.joins(:roles)
    #     .where('groups_roles.user_id = users.id')
    #     .where(groups_roles: { group_id: id }, users: { active: true })
    #     .where('(groups_roles.permission = ? OR groups_roles.permission = ?)', type, 'all')
    #     .order(:id)
    #     .pluck('users.id')
    users = []
    # user_group_ids.concat(user_role_ids).uniq.each { |user_id|
    user_group_ids.uniq.each { |user_id|
      users.push User.find(user_id)
    }
    users
  end

end
