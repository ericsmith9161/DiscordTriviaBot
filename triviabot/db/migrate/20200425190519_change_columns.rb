class ChangeColumns < ActiveRecord::Migration[5.2]
  def change
    change_column :players, :score, :integer, :default => 0
  end
end
