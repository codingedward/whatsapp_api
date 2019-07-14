class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone
      t.references :photo, foreign_key: true, null: true
      t.text :status

      t.timestamps
    end
  end
end
