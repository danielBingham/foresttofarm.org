##
# A class representing one of the plants in our database.
#
# Properties::
# * genus +String+  This plant's latin genus
# * species +String+  This plant's latin species name
# * family  +String+  This plant's latin family name
# * minimum_PH  +String+  The minimum soil pH this plant will tolerate.
# * maximum_PH  +String+  The maximum soil pH this plant will tolerate.
# * minimum_height  +float+ The minimum height to which this plant will grow.
# Nil if no minimum known.
# * maximum_height  +float+ The maximum height to which this plant will grow.
# * minimum_width +float+ The minimum width to which this plant will grow.  Nil
# if no minimum known.
# * maximum_width +float+ The maximum height to which this plant will grow.
# * minimum_zone +String+ The minimum USDA zone in which this plant will grow.
# Nil if no minimum.
# * maximum_zone  +String+  The maximum USDA zone in which this plant will
# grow.  Nil if no maximum.
# * growth_rate +String+  The rate at which this plant grows.
# * form  +String+  The form this plant takes (herb, vine, shrub, or tree).
# * native_region +String+  The region in which this plant grows natively.
#
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
