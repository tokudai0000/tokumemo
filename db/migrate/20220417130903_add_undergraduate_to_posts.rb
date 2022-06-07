class AddUndergraduateToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :undergraduate, :string
  end
end
