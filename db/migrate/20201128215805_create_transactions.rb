class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.float :amount, null: false
      t.string :description, null: false
      t.datetime :completed_on, null: false

      t.integer :account_id, null: false

      t.timestamps
    end
  end
end
