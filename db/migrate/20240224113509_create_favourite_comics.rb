class CreateFavouriteComics < ActiveRecord::Migration[7.1]
  def change
    create_table :favourite_comics do |t|
      t.string :user_id
      t.string :comic_id

      t.timestamps
    end
  end
end
