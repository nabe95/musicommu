class CreateBandPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :band_posts do |t|
      
      t.integer :user_id,null: false
      t.string :title,null: false
      t.text :body, null: false
      t.text :area, null: false
      t.text :instrument, null: false
      t.text :genre, null: false
      t.integer :activity, null: false, default: 0
      t.integer :direction, null: false, default: 0
      t.integer :band_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
