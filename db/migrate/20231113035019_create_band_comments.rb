class CreateBandComments < ActiveRecord::Migration[6.1]
  def change
    create_table :band_comments do |t|
      t.text :comment
      t.integer :band_post_id
      t.integer :user_id

      t.timestamps
    end
  end
end
