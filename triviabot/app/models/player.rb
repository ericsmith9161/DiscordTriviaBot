class Player < ApplicationRecord
    validates :name, presence: true, uniqueness: { scope: :server }
    validates :server, presence: true
end