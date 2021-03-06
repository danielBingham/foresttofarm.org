##
# A class of Moisture Tolerance used to describe Plants
#
# One of the classes of moisture tolerance that are traditionally used
# in plant literature to describe how much water they need.  The usual
# classes are:
#
# 	Xeric	-	The plant can handle or needs very dry conditions.  Desert plants.
# 	Mesic	-	The plant needs a type of habitat with a moderate or
# 		well-balanced supply of moisture, e.g., a mesic forest, a temperate
# 		hardwood forest, or dry-mesic prairie.
# 	Hydric	-	The plant needs soil which is permanently or seasonally
# 		saturated by water, resulting in anaerobic conditions, as found in
# 		wetlands.
#
# Propeties::
# * id  +int+  The primary key.
# * name  +string+  The name of the moisture tolerance class, one
# 		of the above.
#
class MoistureTolerance < ApplicationRecord
end
