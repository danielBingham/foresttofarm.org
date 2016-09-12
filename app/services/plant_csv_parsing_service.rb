##
# Author:: Daniel Bingham <dbingham@theroadgoeson.com>
# License:: MIT
#
# Service class that parses plant CSV data files and saves them to the
# database.  
#
# Usage:
#
# ```
#
# csvService = PlantCSVParsingService.new
# csvService.parseCSVFile(filename)
# ```
# Alternately, if the CSV file has already been parsed into individual lines,
# you can parse it a line at the time by passing each line to
# ``parsePlant``:
#
# ```
# csvService = PlantCSVParsingService.new;
# lines = csv_data_string.split("\n");
# lines.each do |line|
#      csvService.parsePlant(line)
# end 
# ```
#
class PlantCsvParsingService

  # Constants defining the position of each field in the data array generated
  # from a line of the CSV file.
  GENUS = 0
  SPECIES = 1
  COMMON_NAME = 2
  FAMILY = 3
  ZONE = 4
  LIGHT = 5
  MOISTURE = 6
  PH = 7
  FORM = 8
  HABIT = 9
  ROOT_PATTERN = 10
  HEIGHT = 11
  WIDTH = 12
  GROWTH_RATE = 13
  NATIVE_REGION = 14
  HABITATS = 15
  HARVESTS = 16
  ROLES = 17
  DRAWBACKS = 18

  def initialize(output_level=:none)
    @error_level = output_level
  end


  # Parse a CSV file from the given filename and load it into the database.
  # Will overwrite existing data with new data where new data differs from
  # existing data.
  #
  # Params::
  # * filename     +String+   The file path of the file to be read and parsed.
  #
  # Returns:: nil
  #
  def parseCsvFile(filename)
    debug("Starting processing of #{filename}")
    File.open(filename) do |file|
      line_counter = 0
      file.each do |line|
        debug("Processing line #{line_counter}")
        parsePlant(line)
        line_counter += 1
      end
      debug("Finished processing of #{filename} processed #{line_counter} lines.")
    end
  end

  # Parse a Plant model out of a line of CSV data.  Create any associated models
  # and save them all to the database.
  #
  # Params::
  # * line    +String+    The line of CSV data to parse.
  # 
  # Returns:: nil
  #
  def parsePlant(line)
    data = line.split(',').map { |d| d.strip }

    genus = data[GENUS]
    species = data[SPECIES]
    plant_name = "#{genus} #{species}"

    debug("Beginning processing of #{plant_name}...")


    plant = Plant.where('genus = ? AND species = ?', genus, species).first
    if plant == nil
      plant = Plant.new
      plant.genus = genus
      plant.species = species
    end

    plant.family = data[FAMILY]

    phs = parsePh(data[PH])
    plant.minimum_PH = phs[:minimum]
    plant.maximum_PH = phs[:maximum]

    zones = parseZone(data[ZONE])
    plant.minimum_zone = zones[:minimum]
    plant.maximum_zone = zones[:maximum]

    plant.form = parseForm(data[FORM])

    heights = parseHeight(data[HEIGHT])
    plant.minimum_height = heights[:minimum]
    plant.maximum_height = heights[:maximum]

    widths = parseWidth(data[WIDTH])
    plant.minimum_width = widths[:minimum]
    plant.maximum_width = widths[:maximum]    

    # ---------------------------- Growth Rate ---------------------------
    # Format: [Growth Rate]
    # Examples: F, M, S
    unless data[GROWTH_RATE].empty?
      plant.growth_rate = data[GROWTH_RATE].downcase
    else
      plant.growth_rate = nil
    end

    # ---------------------------- Native Region -------------------------
    # Format: [Native Region]
    # Examples: ENA, EURA, ASIA
    unless data[NATIVE_REGION].empty?
      plant.native_region = data[NATIVE_REGION]
    else
      plant.native_region = nil
    end


    if data[COMMON_NAME]
      debug("Parsing common names for #{plant_name}...")
      name = data[COMMON_NAME]
      if ! plant.id || 
          CommonName.where("name=? AND plant_id=?", name, plant.id).first == nil  
        common_name = CommonName.new
        common_name.name = name
        plant.common_names << common_name 
      end
    end

    unless data[LIGHT].empty?
      debug("Parsing light tolerances for #{plant_name}...")
      light_tolerances = parseLightTolerances(data[LIGHT])
      plant.light_tolerances = light_tolerances
    end

    unless data[MOISTURE].empty?
      debug("Parsing moisture tolerances for #{plant_name}...")
      moisture_tolerances = parseMoistureTolerances(data[MOISTURE])
      plant.moisture_tolerances = moisture_tolerances
    end

    unless data[HABIT].empty?
      debug("Parsing habits for #{plant_name}...")
      habits = parseHabits(data[HABIT])
      plant.habits = habits
    end

    unless data[ROOT_PATTERN].empty?
      debug("Parsing root patterns for #{plant_name}...")
      root_patterns = parseRootPatterns(data[ROOT_PATTERN])
      plant.root_patterns = root_patterns
    end

    unless data[HABITATS].empty?
      debug("Parsing habitats for #{plant_name}...")
      habitats = parseHabitats(data[HABITATS])
      plant.habitats = habitats
    end

    unless data[HARVESTS].empty?
      debug("Parsing harvests for #{plant_name}...")
      harvests = parseHarvests(data[HARVESTS])
      plant.harvests = harvests
    end

    unless data[ROLES].empty?
      debug("Parsing roles for #{plant_name}...")
      roles = parseRoles(data[ROLES])
      plant.roles = roles
    end

    unless data[DRAWBACKS].empty?
      debug("Parsing drawbacks for #{plant_name}...")
      drawbacks = parseDrawbacks(data[DRAWBACKS])
      plant.drawbacks = drawbacks
    end

    debug("Saving #{plant_name} to the database...")
    plant.save
  end

  ##
  # Parse the plant's habitats.
  #
  # Format: habitat;habitat*
  # Possible values: Disturbed, Meadows, Prairies, Oldfields, Thickets,
  #      Edges, Gaps/Clearings, Open Woods, Forest, Conifer Forest, Other
  # Examples: Disturbed;Meadows;Oldfields, Forest;Open Woods,
  #      Gaps/Clearings;Open Woods;Conifer Forest
  #
  # Params::
  # * habitat_string +String+ The parsed CSV data.
  # 
  # Returns::  int[]   An array of Habitat ids.
  #
  def parseHabitats(habitat_string) 
    habitat_names = habitat_string.split(';').map { |habitat| habitat.strip }
    habitats = []

    habitat_names.each do |name| 
      if name.nil? || name.empty?
        next
      end

      habitat = Habitat.where('name=?', name).first
      if habitat.blank? 
        error("Failed to find habitat '#{name}'")
        next
      end

      habitats.push(habitat)
    end

    habitats
  end
    

  ##
  # Parse the plant's possible harvests.
  #
  # Format: harvest(rating);harvest(rating)*
  # Possible Harvests: Fruit, Nuts/Mast, Greens, Roots, Culinary, Tea,
  #      Other, Medicinal 
  # Possible Ratings: E, G, F, Y, S
  # Examples: Fruit(E);Medicinal(Y), Greens(F);Roots(E);Tea(F);
  #
  # @param   mixed[] harvest_string The parsed CSV data.
  # @return  int[]   An array of Harvest ids.
  #
  def parseHarvests(harvest_string)
    harvest_descriptions = harvest_string.split(';').map { |string| string.strip }

    harvests = []
    harvest_descriptions.each do |description| 
      if matches = /(\w+\s*\w*)\((\w+)\)/.match(description)
        name = matches[1]
        rating = matches[2]
      else
        error("Failed to parse harvest '#{description}'")
        next
      end

      harvest_type = HarvestType.where('name=?', name).first
      if harvest_type.blank?
        error("Failed to find a harvest type for '#{name}'")
        next
      end

      harvests.push(Harvest.new(harvest_type_id: harvest_type.id, rating: rating))
    end

    harvests
  end
    

  ##
  # Parse this plants roles in the ecosystem.
  #
  # Format: role;role*
  # Possible Values: N2, Dynamic Accumulator, Wildlife(F), Wildlife(S),
  #      Wildlife(B), Invert Shelter, Nectary(G), Nectary(S), Ground Cover,
  #      Other(A), Other(C) 
  # Examples: N2;Willife(F);Invert Shelter, Dynamic Accumulator;Wildlife(S)
  #
  # Params::
  # * role_string +String+  The parsed CSV data.
  #
  # Returns::  +Role[]+   An array of Roles.
  #
  def parseRoles(role_string)
    role_descriptions = role_string.split(';').map { |string| string.strip.downcase }

    roles = []
    # The names in our csv file won't match perfectly to the names in the
    # database, so we'll need to perform a mapping before we hit the database.
    role_names = {
      'n2'=>'Nitrogen Fixer',
      'dynamic accumulator'=>'Dynamic Accumulator',
      'wildlife(f)'=>'Wildlife Food',
      'wildlife(s)'=>'Wildlife Shelter',
      'wildlife(b)'=>['Wildlife Food', 'Wildlife Shelter'],
      'invert shelter'=>'Invertabrate Shelter',
      'nectary(g)'=>'Generalist Nectary',
      'nectary(s)'=>'Specialist Nectary',
      'ground cover'=>'Ground Cover',
      'other(a)'=>'Aromatic',
      'other(c)'=>'Coppice'}

    role_descriptions.each do |description| 
      unless role_names.has_key?(description)
        error("Found invalid role '#{description}'")
        next
      end

      if role_names[description].respond_to?('each') 
        role_names[description].each do |name|
          role = Role.where('name=?', name).first
          if role.blank?
            error("Failed to find role for '#{description}'")
            next
          end
          roles.push(role)
        end
      else 
        role = Role.where('name=?', role_names[description]).first
        if role.blank? 
          error("Failed to find role for '#{description}'")
          next
        end
        roles.push(role)
      end
    end

    roles
  end
    

  ##
  # Parse this plant's drawbacks.
  #
  # Format: drawback;drawback*
  # Possible Values: A, D, E, H, Ps, S, St, T P
  # Examples: P;D, D, P;H;Ps, A;D
  #
  # Params::
  # * drawbacks_string  +String+  The parsed CSV data.
  #
  # Returns::  +Drawback[]+   An array of Drawbacks parsed from the string.
  #
  def parseDrawbacks(drawbacks_string)
    drawback_symbols = drawbacks_string.split(';').map { |string| string.strip.downcase }

    drawbacks = []
    # The names in our csv file won't match perfectly to the names in the
    # database, so we'll need to perform a mapping before we hit the database.
    drawback_names = {
      'a'=>'Allelopathic',
      'd'=>'Dispersive',
      'e'=>'Expansive',
      'h'=>'Hay Fever',
      'ps'=>'Persistent',
      's'=>'Sprawling vigorous vine',
      'st'=>'Stings',
      't'=>'Thorny',
      'p'=>'Poison'
    }

    drawback_symbols.each do |symbol| 
      if symbol.empty? 
        next
      end

      drawback = Drawback.where('name=?', drawback_names[symbol]).first
      if drawback.blank? 
        error("Failed to find drawback for '#{symbol}'")
        next
      end

      drawbacks.push(drawback)
    end

    drawbacks
  end

  ##
  # Parse the plant's root patterns.
  #
  # Format: symbol;symbol*
  # Possible values: F, FB, H, T, Sk, St, B, C, R, Tu, Fl, St
  # Examples: F;FB, St;F, Sk;R;FB  
  #
  # @param   mixed[] $root_pattern_string    The parsed CSV data.
  # @return  int[]   An array of RootPattern ids.
  #
  def parseRootPatterns(root_pattern_string)
    root_pattern_symbols = root_pattern_string.split(';').map { |symbol| symbol.strip }
    root_patterns = []

    root_pattern_symbols.each do |symbol|
      root_pattern = RootPattern.where('symbol=?', symbol).first
      if root_pattern == nil
        error("Failed to find root pattern '#{symbol}'")
        next 
      end
      root_patterns.push(root_pattern)
    end

    root_patterns 
  end
    

  ##
  # Parse the plant's growth habit.
  #
  # Format: symbol symbol* 
  # Possible Values: E, std, skr, spr, ms, Ctkt, Rtkt, Cmat, Rmat, w, r,
  #      vine, v/kr, a, e, clmp, run
  # Examples: clmp, w vine, Rtkt, r vine, a e clmp
  #
  # Params::
  # * habit_string  +string+  The parsed CSV data.
  #
  # Returns:: +int[]+   An array of Habit ids.
  #
  def parseHabits(habit_string)
    habit_symbols = habit_string.split(' ').map { |habit| habit.strip }
    habits = []

    habit_symbols.each do |symbol| 
      habit = Habit.where('symbol=?', symbol).first
      if habit == nil 
        error("Failed to find habit '#{symbol}'")
        next 
      end
      habits.push(habit)
    end

    habits
  end 


  ##
  # Parse the plant's moisture tolerances.
  #
  # Format: tolerance;tolerance*
  # Possible Values: Xeric, Mesic, Hydric
  # Examples: Xeric, Xeric;Mesic, Hydric;Mesic 
  #
  # Params::
  # * moisture_string +string+  The moisture data parsed from the
  #      CSV file.
  #
  # Returns:: +MoistureTolerance[]+ An array of MoistureTolerance ids. 
  #
  def parseMoistureTolerances(moisture_string)
    moisture_tolerance_names = moisture_string.split(';').map { |moisture| moisture.strip }
    moisture_tolerances = []

    moisture_tolerance_names.each do |name|
      moisture_tolerance = MoistureTolerance.where('name=?', name).first
      if moisture_tolerance == nil
        error("Found invalid moisture tolerance '#{name}'")
        next 
      end
      unless moisture_tolerances.include?(moisture_tolerance)
        moisture_tolerances.push(moisture_tolerance)
      end
    end
    moisture_tolerances
  end

  ##
  # Parse the plant's light tolerances and return an array of ids.
  #
  # Format: tolerance;tolerance*
  # Possible Values: Sun, Shade, Partial
  # Examples: Shade;Partial, Sun;Partial, Sun;Shade
  #
  # Params::   
  # * light_string    +String+   The light data parsed from the CSV file.
  #
  # Returns::  +LightTolerance[]+   An array of LightTolerance ids. 
  #
  def parseLightTolerances(light_string) 
    light_tolerance_names = light_string.split(';').map { |light| light.strip.downcase }

    light_tolerances = [] 
    light_tolerances_name_map = {
      'sun' => 'Full Sun',
      'partial' => 'Partial Shade',
      'shade' => 'Full Shade'
    }

    light_tolerance_names.each do |name|
      unless light_tolerances_name_map.has_key?(name)
        error("Found invalid light tolerance #{name}")
        next 
      end

      name = light_tolerances_name_map[name]
      light_tolerance = LightTolerance.where('name=?', name).first
      if light_tolerance.nil? 
        error("Found invalid light tolerance #{name}")
        next 
      end
      unless light_tolerances.include?(light_tolerance)
        light_tolerances.push(light_tolerance)
      end
    end
    light_tolerances
  end


  #  
  # Parse out this plant's Soil pH requirements.
  #
  # Format: [0-2]:[0-2]:[0-2]:[0-2]
  # Examples: 0:0:2:2, 0:1:2:1, 1:2:2:1, 0:0:0:2
  #
  # Params::
  # * ph_string   +String+    The parsed CSV data.
  # 
  # Returns:: +Hash+  A hash containing the minimum and maximum pH
  #   values in list form: ``{:minimum=>minimum_ph, :maximum=>maximum_ph)``
  #
  def parsePh(ph_string)
    phs = ph_string.split(':').map { |ph| ph.strip.to_i }

    if phs.count != 4
      return { minimum: 6.1, maximum: 7.0 }
    end

    minimum_ph_values = {
      0=>{1=>4.00, 2=>3.5},
      1=>{1=>5.35, 2=>5.1},
      2=>{1=>6.35, 2=>6.1},
      3=>{1=>7.50, 2=>7.1}}
    maximum_ph_values = {
      0=>{1=>4.50, 2=>5.0},
      1=>{1=>5.80, 2=>6.0},
      2=>{1=>6.80, 2=>7.0},
      3=>{1=>7.80, 2=>8.5}}
    minimum_ph = 6.1;
    maximum_ph = 7.0;

    (0..3).each do |i|
      if phs[i] == 1 || phs[i] == 2 
        minimum_ph = minimum_ph_values[i][phs[i]]
        break
      elsif phs[i].nil? || (phs[i] > 2 || phs[i] < 0)
        error('Bad data in pH values.')
      end 
    end

    3.downto(0) do |i|
      if phs[i] == 1 || phs[i] == 2 
        maximum_ph = maximum_ph_values[i][phs[i]]
        break
      elsif phs[i].nil? || (phs[i] > 2 || phs[i] < 0)
        error('Bad data in pH values.')
      end
    end

    { minimum: minimum_ph, maximum: maximum_ph }
  end

  #
  # Parse this plant's USDA zone.
  #
  # Formats: [Minimum Zone] - [Maximum Zone] OR [Minimum Zone]
  # Examples: 3 - 7 OR 3b
  #
  # Params::
  # * zone_string   +mixed[]* The parsed CSV data.
  #
  # Returns::  +String[]+   An array containing the minimum and maximum zone values
  #      in list form: ``array(0=>minimum_zone, 1=>maximum_zone)``
  #
  def parseZone(zone_string) 
    if zone_string.index("-") != nil
      zones = zone_string.split('-').map { |zone| zone.strip.downcase }

      minimum_zone = zones[0]
      maximum_zone = zones[1]
    else 
      minimum_zone = zone_string.strip
      maximum_zone = nil
    end

    # Generate the list of valid zones.  They range from 1 - 13 and each
    # zone can have an 'a' or a 'b'.  Examples: 1, 1a, 1b, 10a, 7b, 3
    valid_zones = []
    (1..13).each do |zone|
      valid_zones.push(zone.to_s)
      valid_zones.push(zone.to_s + 'a')
      valid_zones.push(zone.to_s + 'b')
    end

    if  minimum_zone != nil && ! valid_zones.include?(minimum_zone)  
      error("Invalid zone detected [#{minimum_zone}]")
      minimum_zone = null
    end

    if maximum_zone != nil && ! valid_zones.include?(maximum_zone) 
      error("Invalid zone detected [$maximum_zone]")
      maximum_zone = null
    end

    {:minimum => minimum_zone, :maximum => maximum_zone}
  end 


  ##
  # Parse this plant's form.
  #
  # Format: [size] [form]
  # Examples: m Shrub, l Tree, s-m Herb
  #
  # Params::
  # * form_string +mixed[]+   The parsed CSV data.
  #
  # Returns::  +String+  This plant's form.
  #
  def parseForm(form_string)
    forms = form_string.split(' ').map { |form| form.strip.downcase } 
    if forms.count > 2 
      error("Failed to parse form.  Possible data error? [#{form_string}]")
      return nil 
    end

    if forms[1].empty?
      error("Failed to parse form.  Possible data error? [#{form_string}]")
      return nil 
    end

    valid_forms = ['tree', 'shrub', 'vine', 'herb']
    unless valid_forms.include?(forms[1])
      error("Failed to parse form.  Possible data error? [#{form_string}]")
      return nil
    end

    # We're ignoring size.  You can get it from the height / width.
    # So we're just going to return the form, the second part of it.
    forms[1].downcase 
  end


  ##
  # Parse the plant's height (minimum and maximum).
  #
  # Format:  [Minimum Height]' - [Maximum Height]' OR [Maximum Height]' 
  #      OR [Minimum Height]" - [Maximum Height]" OR [Maximum Height]"
  # Examples: 20' - 100', 7', 24", 12" - 24"
  #
  # Params::
  # * height_string   +String+  The parsed CSV data.
  # 
  # Returns::  +Hash+   A hash containing this plant's minimum and maximum
  #       heights (``{:minimum=>minimum_height, :maximum=>maximum_height}``).
  #
  def parseHeight(height_string)
    if height_string.index('-') != nil 
      heights = height_string.split('-').map { |height| height.strip }
      minimum_height = heights[0]
      maximum_height = heights[1]
    else 
      maximum_height = height_string.strip
      minimum_height = nil # If we've only got one value, then it's the maximum.
    end

    # Parse the minimum_height and ensure good data.
    if minimum_height != nil && matches = /^(\d+)(\'|")/.match(minimum_height) 
      minimum_height = matches[1].to_f
      if matches[2] == '"' 
        minimum_height = minimum_height / 12
      end
    elsif minimum_height != nil 
      error("Invalid minimum height [#{minimum_height}]")
      minimum_height = nil
    end

    # Parse the maximum_height and ensure good data.
    if maximum_height != nil && matches = /^(\d+)(\'|")/.match(maximum_height) 
      maximum_height = matches[1].to_f
      if matches[2] == '"' 
        maximum_height = maximum_height / 12
      end
    elsif maximum_height != nil
      error("Invalid minimum width [#{maximum_height}]")
      maximum_height = nil;
    end

    {:minimum => minimum_height, :maximum => maximum_height}
  end


  ##
  # Parse the plant's width (minimum and maximum).
  # Format:  [Minimum Width]' - [Maximum Width]' OR [Maximum Width]' 
  #      OR [Minimum Width]" - [Maximum Width]" OR [Maximum Width]"
  # Examples: 20' - 100', 7', 24", 12" - 24"
  #
  # Params:: 
  # * width_string    +String+   The parsed CSV data.
  #
  # Returns::  +float[]+   An array containing this plant's minimum and maximum
  #      widths(``array(0=>minimum_width, 1=>maximum_width)``).
  #
  def parseWidth(width_string)

    if width_string.index('-') != nil 
      widths = width_string.split('-').map { |width| width.strip } 
      minimum_width = widths[0]
      maximum_width = widths[1]
    else 
      maximum_width = width_string.strip
      minimum_width = nil # If we've only got one value, then it's
      # the maximum.
    end

    # Parse the minimum_width and ensure good data.
    if minimum_width != nil && matches = /^(\d+)(\'|")/.match(minimum_width) 
      minimum_width = matches[1].to_f
      if (matches[2] == '"') 
        minimum_width = minimum_width / 12
      end
    elsif minimum_width != nil
      error("Invalid minimum width [#{minimum_width}]")
      minimum_width = nil
    end

    # Parse the maximum_width and ensure good data.
    if maximum_width != nil && matches = /^(\d+)(\'|")/.match(maximum_width) 
      maximum_width = matches[1].to_f
      if matches[2] == '"'
        maximum_width = maximum_width / 12
      end
    elsif maximum_width.downcase == 'indefinite' 
      maximum_width = -1 
    elsif maximum_width != nil
      error("Invalid minimum width [#{maximum_width}]")
      maximum_width = nil
    end

    {:minimum => minimum_width, :maximum => maximum_width}
  end


  private

  def debug(output)
    if @error_level == :debug || @error_level == :error
      Rails.logger.debug output
    end
  end

  def error(output)
    if @error_level == :error
      Rails.logger.error output
    end
  end
end
