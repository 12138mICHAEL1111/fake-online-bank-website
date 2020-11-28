class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.integer :account_id
      t.string :description

      t.timestamps
    end
  end
end
