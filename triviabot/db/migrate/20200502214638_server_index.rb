class ServerIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :players, :server
  end
end
