class UserGroupPermission < ActiveRecord::Migration
  def up

    # return if it's a new setup
    return if !Setting.find_by(name: 'system_init_done')

    add_column :groups_users, :permission, :string, limit: 50, null: false, default: 'all'
    add_index :groups_users, [:permission]
    UserGroup.connection.schema_cache.clear!
    UserGroup.reset_column_information

    create_table :groups_roles, id: false do |t|
      t.integer :role_id
      t.integer :group_id
      t.string :permission,       limit: 50, null: false, default: 'all'
    end
    add_index :groups_roles, [:role_id]
    add_index :groups_roles, [:group_id]
    add_index :groups_roles, [:permission]

  end

end
