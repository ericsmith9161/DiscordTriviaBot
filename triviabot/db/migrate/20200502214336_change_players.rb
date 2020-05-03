class ChangePlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :server, :integer, null: false
  end
end
