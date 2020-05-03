class FixPlayerNameIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :players, :name
    remove_index :players, :server
    add_index :players, :name
    add_index :players, [:server, :name], unique: true
  end
end
