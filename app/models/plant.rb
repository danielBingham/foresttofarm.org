class Plant < ApplicationRecord
    has_many :common_names, dependent: :destroy
    has_many :harvests, dependent: :destroy
    has_and_belongs_to_many :drawbacks, join_table: 'plants_drawbacks'
    has_and_belongs_to_many :habits, join_table: 'plants_habits'
    has_and_belongs_to_many :habitats, join_table: 'plants_habitats'
    has_and_belongs_to_many :light_tolerances, join_table: 'plants_light_tolerances'
    has_and_belongs_to_many :moisture_tolerances, join_table: 'plants_moisture_tolerances'
    has_and_belongs_to_many :roles, join_table: 'plants_roles'
    has_and_belongs_to_many :root_patterns, join_table: 'plants_root_patterns'
end
