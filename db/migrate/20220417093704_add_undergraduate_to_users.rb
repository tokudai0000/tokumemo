class AddUndergraduateToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :undergraduate, :string
  end
end
