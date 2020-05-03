class FixServer < ActiveRecord::Migration[5.2]
  def change
    remove_index :players, [:server, :name]
    remove_column :players, :server
    add_column :players, :server, :string, null: false
    add_index :players, [:server, :name], unique: true
  end
end
