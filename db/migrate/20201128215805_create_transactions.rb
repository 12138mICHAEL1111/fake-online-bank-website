class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.string :description
      t.datetime :completed_on

      t.integer :account_id

      t.timestamps
    end
  end
end
