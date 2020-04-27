class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.integer :score, null: false
    end

    add_index :players, :name, unique: true
  end
end
