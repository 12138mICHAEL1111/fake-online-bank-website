class CreateThemes < ActiveRecord::Migration[6.0]
  def change
    create_table :themes do |t|
      t.string :name, null: false
      t.string :font, null: false
      t.string :buttons_color, null: false
    end
  end
end
