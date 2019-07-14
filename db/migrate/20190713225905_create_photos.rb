class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.text :image_data
      t.references :owner, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end
  end
end
