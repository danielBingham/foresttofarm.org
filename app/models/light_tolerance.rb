##
# This is a model representing the different types of light a plant may
# tolerate.  The types typically used in plant literature are "Full Sun",
# "Partial Shade" and "Full Shade".
#
# Properties::
# * id  +int+  The primary key.
# * name  +string+  The name of light tolerance in question.
#
class LightTolerance < ApplicationRecord
end
