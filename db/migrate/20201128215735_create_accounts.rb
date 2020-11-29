class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.float :balance, null: false
      t.string :currency, null: false

      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
