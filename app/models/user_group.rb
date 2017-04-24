# Copyright (C) 2012-2016 Zammad Foundation, http://zammad-foundation.org/

class UserGroup < ApplicationModel
  self.table_name = 'groups_users'
  self.primary_keys = :user_id, :group_id, :permission
  belongs_to          :user
  belongs_to          :group
  validates           :permission, presence: true

end
