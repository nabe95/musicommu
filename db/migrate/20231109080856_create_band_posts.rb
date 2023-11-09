class CreateBandPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :band_posts do |t|
      
      t.integer :user_id,null: false
      t.string :title,null: false
      t.text :body, null: false
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
