class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table(:friendships, primary_key: [:user_id, :rqstuser_id]) do |t|
      t.references :user, foreign_key: true, index: true
      t.references :rqstuser, index: true
      t.boolean :status

      t.timestamps null: false
    end

    add_foreign_key :friendships, :users, column: :rqstuser_id
  end
end
