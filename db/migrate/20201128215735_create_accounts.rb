class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.float :balance, index: true
      t.integer :user_id
      t.string :currency

      t.timestamps
    end
  end
end
