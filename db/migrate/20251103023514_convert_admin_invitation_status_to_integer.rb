class ConvertAdminInvitationStatusToInteger < ActiveRecord::Migration[8.1]
  def up
    # Add temporary integer column
    add_column :admin_invitations, :status_int, :integer

    # Map existing string values to integers
    # pending: 0, accepted: 1, declined: 2, expired: 3
    execute <<-SQL
      UPDATE admin_invitations
      SET status_int = CASE status
        WHEN 'pending' THEN 0
        WHEN 'accepted' THEN 1
        WHEN 'declined' THEN 2
        WHEN 'expired' THEN 3
        ELSE 0
      END
    SQL

    # Remove old string column and its index
    remove_index :admin_invitations, :status
    remove_column :admin_invitations, :status

    # Rename new column to status
    rename_column :admin_invitations, :status_int, :status

    # Add constraints and index
    change_column_null :admin_invitations, :status, false
    change_column_default :admin_invitations, :status, 0
    add_index :admin_invitations, :status
  end

  def down
    # Add temporary string column
    add_column :admin_invitations, :status_string, :string

    # Map integers back to strings
    execute <<-SQL
      UPDATE admin_invitations
      SET status_string = CASE status
        WHEN 0 THEN 'pending'
        WHEN 1 THEN 'accepted'
        WHEN 2 THEN 'declined'
        WHEN 3 THEN 'expired'
        ELSE 'pending'
      END
    SQL

    # Remove integer column and its index
    remove_index :admin_invitations, :status
    remove_column :admin_invitations, :status

    # Rename back to status
    rename_column :admin_invitations, :status_string, :status

    # Add constraints and index
    change_column_null :admin_invitations, :status, false
    change_column_default :admin_invitations, :status, 'pending'
    add_index :admin_invitations, :status
  end
end
