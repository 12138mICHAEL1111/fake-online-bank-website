class AddNameToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :name, :string
    change_column_null :accounts, :name, false
  end
end
