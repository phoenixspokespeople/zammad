class UserGroupPermission < ActiveRecord::Migration
  def up

    # return if it's a new setup
    return if !Setting.find_by(name: 'system_init_done')

    add_column :groups_users, :permission, :string, limit: 50, null: false, default: 'rw'
    add_index :groups_users, [:permission]
    UserGroup.connection.schema_cache.clear!
    UserGroup.reset_column_information

  end

end
