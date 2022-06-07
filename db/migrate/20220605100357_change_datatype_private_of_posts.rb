class ChangeDatatypePrivateOfPosts < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :private, :integer
  end
end
