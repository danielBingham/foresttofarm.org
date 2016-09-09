Drawback.create!([
  {name: "Allelopathic"},
  {name: "Dispersive"},
  {name: "Expansive"},
  {name: "Hay fever"},
  {name: "Persistent"},
  {name: "Sprawling vigorous vine"},
  {name: "Stings"},
  {name: "Thorny"},
  {name: "Poison"}
])
Habit.create!([
  {name: "Evergreen", symbol: "E", description: ""},
  {name: "Standard", symbol: "std", description: "Single-trunked and nonsuckering."},
  {name: "Suckering", symbol: "skr", description: "Sending up shoots at a distance from the trunk from roots, rhizomes, or stolons."},
  {name: "Sprouting", symbol: "spr", description: "A standard tree that sends up shoots from the base."},
  {name: "Multistemmed", symbol: "ms", description: "Multiple shoots arising from the crown."},
  {name: "Clumping Thicket Former", symbol: "Ctkt", description: "Forming a colony by sending up shoots at a distance from the crown, but not spreading beyond a certain size."},
  {name: "Running Thicket Former", symbol: "Rtkt", description: "Forming a colony by spreading up shoots at a distance from the crown and spreading indefinitly."},
  {name: "Clumping Mat Former", symbol: "Cmat", description: "Makes a dense prostrate carpet that does not spread beyond a certain size."},
  {name: "Running Mat Former", symbol: "Rmat", description: "Makes a dense prostrate carpet that spreads indefinitely."},
  {name: "Woody", symbol: "w", description: ""},
  {name: "Herbacious", symbol: "r", description: ""},
  {name: "Vine", symbol: "vine", description: "Ordinary vine sending a single shoot or multiple shoots from a crown."},
  {name: "Suckering Vine", symbol: "v/skr", description: "Sends up suckers at a distance from the parent plant from roots, rhizomes or stolons."},
  {name: "Annual", symbol: "a", description: "Self seeding annual herb."},
  {name: "Ephemeral", symbol: "e", description: "Emerging in spring and dying back by summer every year."},
  {name: "Clumper", symbol: "clmp", description: "Spreading to a certain width and no wider."},
  {name: "Runner", symbol: "run", description: "Spreading indefinitely by stolons or rhizomes."}
])
Habitat.create!([
  {name: "Disturbed"},
  {name: "Meadows"},
  {name: "Prairies"},
  {name: "Oldfields"},
  {name: "Thickets"},
  {name: "Edges"},
  {name: "Gaps/Clearings"},
  {name: "Open Woods"},
  {name: "Forest"},
  {name: "Conifer Forest"},
  {name: "Other"}
])
HarvestType.create!([
  {name: "Fruit"},
  {name: "Nuts/Mast"},
  {name: "Greens"},
  {name: "Roots"},
  {name: "Culinary"},
  {name: "Tea"},
  {name: "Other"},
  {name: "Medicinal"}
])
LightTolerance.create!([
  {name: "Full Sun"},
  {name: "Partial Shade"},
  {name: "Full Shade"}
])
MoistureTolerance.create!([
  {name: "Xeric"},
  {name: "Mesic"},
  {name: "Hydric"}
])
Role.create!([
  {name: "Nitrogen Fixer"},
  {name: "Dynamic Accumulator"},
  {name: "Wildlife Food"},
  {name: "Wildlife Shelter"},
  {name: "Invertabrate Shelter"},
  {name: "Generalist Nectary"},
  {name: "Specialist Nectary"},
  {name: "Ground Cover"},
  {name: "Aromatic"},
  {name: "Coppice"}
])
RootPattern.create!([
  {name: "Flat", symbol: "F", description: "Mostly shallow roots forming a \"plate\" near the soil surface.  May also develope vertical \"sinkers\" or \"strikers\" in various places."},
  {name: "Fibrous", symbol: "FB", description: "Dividing into a large number of fine roots immediately upon leaving the crown."},
  {name: "Heart", symbol: "H", description: "Dividing from the crown into a number of main roots that both angle downward and spread outward."},
  {name: "Tap", symbol: "T", description: "A carrotlike root (sometimes branching) driving directly downward."},
  {name: "Suckering", symbol: "Sk", description: "Sending up new Plants from underground runners (either rhizomes or root sprouts) at a distance from the trunk or crown."},
  {name: "Stoloniferous", symbol: "St", description: "Rooting from creeping stems above the ground."},
  {name: "Bulb", symbol: "B", description: "Modified leaves forming a swollen base.  Onions and garlic are bulbs."},
  {name: "Corm", symbol: "C", description: "A thick swelling at the base of the stem."},
  {name: "Rhizomatous", symbol: "R", description: "Underground stems that send out shoots and roots periodically along their length.  They can travel great distances, or stay close to the crown."},
  {name: "Tuberous", symbol: "Tu", description: "Producing swollen potato-like \"roots\" (actually modified stems)."},
  {name: "Fleshy", symbol: "Fl", description: "Thick or swollen, usually a form of fibrous or tap roots."}
])
