class Plant < ApplicationRecord
    has_many :common_names
    has_and_belongs_to_many :drawbacks
    has_and_belongs_to_many :habits
    has_and_belongs_to_many :habitats
    has_and_belongs_to_many :harvests
    has_and_belongs_to_many :light_tolerances, join_table: 'plants_light_tolerances'
    has_and_belongs_to_many :moisture_tolerances
    has_and_belongs_to_many :roles
    has_and_belongs_to_many :root_patterns
end
