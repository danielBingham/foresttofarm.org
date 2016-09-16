
##
# Represents one of a plant's possibly many common names.
#
# Properties::
# * id  +int+  The primary key, auto increment.
# * plant_id  +int+  The id of the plant to which this common name belongs.
# * name  +string+  The common name.
#
class CommonName < ApplicationRecord
  belongs_to :plant
end
