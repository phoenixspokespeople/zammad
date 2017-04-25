# Copyright (C) 2012-2016 Zammad Foundation, http://zammad-foundation.org/
module Groupable
  extend ActiveSupport::Concern

  included do
    attr_accessor :group_buffer

    after_create  :check_group_buffer
    after_update  :check_group_buffer
    #after_destroy :group_cleanup
  end

=begin

set groups of user

  user = User.find(123)
  success = user.groups = [
    1: 'rw',
    2: 'ro',
    3: ['ro', 'note'],
  ]

returns

  true | false

=end

  def groups=data
    @group_buffer = {}
    if data.class == String || data.class == Integer
      data = [data]
    end
    if data.class == Array || data.class == Group::ActiveRecord_Relation
      data.each { |item|
        if item.class == String
          item = Group.find_by(name: item)
        end
        raise 'Only Group is accepted for groups param.' if item.class != Group
        @group_buffer[item.id] ||= []
        @group_buffer[item.id].push 'rw'
      }
      check_group_buffer if id
      return true
    end
    data.each { |group_id, permission|
      @group_buffer[group_id] ||= []
      @group_buffer[group_id].push permission
    }
    check_group_buffer if id
    true
  end

=begin

get groups of user

  user = User.find(123)
  groups = user.groups(type)

returns

  [group1, group2, ...]

=end

  def groups(type = 'rw')
    Group.joins(:groups_users)
         .where('groups_users.group_id = groups.id')
         .where(groups_users: { user_id: id }, groups: { active: true })
         .where('(groups_users.permission = ? OR groups_users.permission = ?)', type, 'rw')
         .distinct('groups.name')
         .order(:id)
  end

=begin

set group_ids of user

  user = User.find(123)
  success = user.group_ids = [1, 2, 3, ...]
returns

  [1, 2, 3, ...]

=end

  def group_ids=data
    @group_buffer = {}
    if data.class == String || data.class == Integer
      data = [data]
    end
    if data.class == Array
      data.each { |group_id|
        @group_buffer[group_id] ||= []
        @group_buffer[group_id].push 'rw'
      }
      check_group_buffer if id
      return data
    end
    data.each { |group_id, permission|
      @group_buffer[group_id] ||= []
      if permission.class == Array
        permission.each { |item|
          @group_buffer[group_id].push item
        }
        next
      end
      @group_buffer[group_id].push permission
    }
    check_group_buffer if id
    data
    #raise "Invalid data structure: #{data.inspect}"
  end

=begin

get group_ids of user

  user = User.find(123)
  success = user.group_ids('rw')

returns

  [1, 2, 3, ...]

  user = User.find(123)
  success = user.group_ids

returns

  {
    1: 'ro',
    2: ['rw', 'note'],
  }

=end

  def group_ids(type = 'rw')
    Group.joins(:groups_users)
         .where('groups_users.group_id = groups.id')
         .where(groups_users: { user_id: id }, groups: { active: true })
         .where('(groups_users.permission = ? OR groups_users.permission = ?)', type, 'rw')
         .distinct('groups.name')
         .order(:id)
         .pluck(:id)
  end

  private

  def check_group_buffer
    return if @group_buffer.nil?
    model = Kernel.const_get('UserGroup')
    model.where(user_id: id).destroy_all
    @group_buffer.each { |group_id, permission|
      if permission.class != Array
        permission = [permission]
      end
      permission.each { |item|
        model.create!(
          user_id: id,
          group_id: group_id,
          permission: item,
        )
      }
    }
    @group_buffer = nil
    cache_delete
    true
  end

end
