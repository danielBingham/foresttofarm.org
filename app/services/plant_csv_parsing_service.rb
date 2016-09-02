# PlantCSVParsingService 
#
#
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
    USES = 16
    FUNCTIONS = 17
    DRAWBACKS = 18

    def initialize(output_level=:none)
        @error_level = output_level
    end


    # Parse a CSV file from the given filename and load it into the database.
    # Will overwrite existing data with new data where new data differs from
    # existing data.
    #
    # * *Params*::
    #   - +filename+: The file path of the file to be read and parsed.
    # * *Returns*:: nil
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
    # * *Params*::
    #   - +line+: The line of CSV data to parse.
    # * *Returns*:: nil
    #
    def parsePlant(line)
        data = line.split(',').map { |d| d.strip }

        genus = data[GENUS]
        species = data[SPECIES]

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
        

        debug(plant.inspect)
    end

    #  
    # Parse out this plant's Soil pH requirements.
    #
    # Format: [0-2]:[0-2]:[0-2]:[0-2]
    # Examples: 0:0:2:2, 0:1:2:1, 1:2:2:1, 0:0:0:2
    #
    # * *Params*::
    #   - +ph_string+ String  The parsed CSV data.
    # * *Returns*:: Hash  A hash containing the minimum and maximum pH
    #   values in list form: ``{:minimum=>minimum_ph, :maximum=>maximum_ph)``
    #
    def parsePh(ph_string)
        phs = ph_string.split(':').map { |ph| ph.strip.to_i }
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
       
        for i in 0..3 
			if phs[i] == 1 || phs[i] == 2 
				minimum_ph = minimum_ph_values[i][phs[i]]
				break
            elsif phs[i] > 2 || phs[i] < 0 
                error('Bad data in pH values.')
            end 
        end

        3.downto(0) do |i|
			if phs[i] == 1 || phs[i] == 2 
				maximum_ph = maximum_ph_values[i][phs[i]]
				break
             elsif phs[i] > 2 || phs[i] < 0 
                error('Bad data in pH values.')
             end
        end

        { :minimum => minimum_ph, :maximum => maximum_ph }
    end

    #
    # Parse this plant's USDA zone.
    #
    # Formats: [Minimum Zone] - [Maximum Zone] OR [Minimum Zone]
    # Examples: 3 - 7 OR 3b
    #
    # @param   mixed[] $zone_string    The parsed CSV data.
    # @return  string[]   An array containing the minimum and maximum zone values
    #      in list form: ``array(0=>minimum_zone, 1=>maximum_zone)``
    #
    def parseZone(zone_string) 
        if zone_string.index("-") != nil
            zones = zone_string.split('-').map { |zone| zone.strip }

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
    # * *Params*::
    #   -   mixed[] +form_string+    The parsed CSV data.
    # * *Returns*::  String  This plant's form.
    #
    def parseForm(form_string)
        forms = form_string.split(' ').map { |form| form.strip } 
        if forms.count > 2 
            error("Failed to parse form.  Possible data error? [#{form_string}]")
            return nil 
        end

        if forms[1].nil?
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
    # * *Params*::
    #   -  mixed[] +height_string+  The parsed CSV data.
    # * *Returns*::  Hash   A hash containing this plant's minimum and maximum
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
    


    private

        def debug(output)
            if @error_level == :debug || @error_level == :error
                puts Time.now.utc.iso8601 + ':: ' + output
            end
        end

        def error(output)
            if @error_level == :error
                puts Time.now.utc.iso8601 + ':: ' + output
            end
        end
end
