class CreateAdminInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :admin_invitations do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.integer :invited_by_id, null: false
      t.integer :admin_user_id
      t.string :status, null: false, default: "pending"
      t.datetime :expires_at, null: false
      t.datetime :accepted_at

      t.timestamps
    end

    add_index :admin_invitations, :email
    add_index :admin_invitations, :token, unique: true
    add_index :admin_invitations, :status
    add_index :admin_invitations, :expires_at
    add_index :admin_invitations, :admin_user_id

    add_foreign_key :admin_invitations, :admin_users, column: :invited_by_id
    add_foreign_key :admin_invitations, :admin_users, column: :admin_user_id
  end
end
