##
# Describes what harvests a plant provides and attaches a rating of quality to
# each one. 
#
# Properties
# * id  +int+  The primary key.
# * plant_id  +int+ The id of the plant to which this harvest belongs.
# * harvest_type_id  +int+ The id of the type of harvest this is.
# * rating  +string+  The quality rating of this harvest type provided by this plant.
#
class Harvest < ApplicationRecord
end
