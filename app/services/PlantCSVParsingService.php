<?php
/**
 * Service to handle the parsing of Plant CSV formatted data files.
 *
 * @author  Daniel Bingham  <dbingham@theroadgoeson.com>
 * @license MIT
 */


/** 
 * These are the columns in the CSV file we'll be loading from.  We're defining
 * names for them to more easily reference them.
 */
define('GENUS', 0);
define('SPECIES', 1);
define('COMMON_NAME', 2);
define('FAMILY', 3);
define('ZONE', 4);
define('LIGHT', 5);
define('MOISTURE', 6);
define('PH', 7);
define('FORM', 8);
define('HABIT', 9);
define('ROOT_PATTERN', 10);
define('HEIGHT', 11);
define('WIDTH', 12);
define('GROWTH_RATE', 13);
define('NATIVE_REGION', 14);
define('HABITATS', 15);
define('USES', 16);
define('FUNCTIONS', 17);
define('DRAWBACKS', 18);

/**
 * Service class that parses plant CSV data files and saves them to the
 * database.  
 *
 * Usage:
 *
 * ```
 *
 * $csvService = new PlantCSVParsingService();
 * $csvService->parseCSVFile($filename);
 * ```
 * Alternately, if the CSV file has already been parsed into individual lines,
 * you can parse it a line at the time by passing each line to
 * ``parsePlant()``:
 *
 * ```
 * $csvService = new PlantCSVParsingService();
 * $lines = explode("\n", $csv_data_string);
 * foreach($lines as $line) {
 *      $csvService->parsePlant($line);
 * }
 * ```
 *
 * If you would like for debug and error output to be printed to an 
 * interface, such as the console, then you must provide an output
 * interface that implements a ``debug()`` and an ``error()`` method to
 * the ``setOutput()`` method.  
 *
 * Example interface:
 *
 * ```
 * interface Output {
 *
 *      public function debug($message);
 *      public function error($message);
 * }
 * ```
 *
 * Laravel Commands implement these methods, thus a laravel command can be used
 * for this purpose.  To use this service to parse CSV file input from a
 * laravel Command and have the input routed to the console through the
 * Command, do the following from with in a the Command's method:
 *
 * ```
 * $csvService = new PlantCSVParsingService();
 * $csvService->setOutput($this);
 * $csvService->parseCSVFile($filename);
 * ```
 */
class PlantCSVParsingService {

    private $output = null;

    /**
     * Set an output class on this service.  Must implement two
     * methods: ``debug($message)`` and ``error($message)``.  If 
     * no output class is set, then no output will be reported.
     *
     * @param   Object  $output The class implementing the output methods.
     * @return  $this
     */
    public function setOutput($output) 
    {
        $this->output = $output;
        return $this;
    }

    /**
     * Print a debug message to our output's ``debug()`` method, if we have
     * an output set.
     *
     * @param   string  $message    The message to print.
     * @return  void
     */
    protected function debug($message) 
    {
        if($this->output !== null) {
            $this->output->debug($message);
        }
    }

    /**
     * Print an error message to our output's ``error()`` method, if we have an
     * output set.
     *
     * @param   string  $message    The message to print.
     * @return  void
     */
    protected function error($message) 
    {
        if($this->output !== null) {
            $this->output->error($message);
        }
    }

    /**
     * Parse a CSV formatted file of plant data and save the parsed Plant
     * models to the database.
     *
     * @param   string  $filename   The filepath of the file to open and parse.
     * @return void
     */
    public function parseCSVFile($filename)
    {
		$this->debug('Starting processing of data file: ' . $filename);
		$lines = explode("\n", file_get_contents($filename));


		$this->debug('Data file contains ' . count($lines) . ' lines of data.');
		$counter = 1;
		foreach($lines as $line) {
			if (strlen($line) < 1) {
				break;
			}
			$this->debug('Processing line ' . $counter . ' of ' . count($lines));
            $this->parsePlant($line);

			$counter++;
		}
		$this->debug('Processing complete.');

    }


    /**
     * Parse a Plant model from the given CSV data line and save it to the
     * database.
     *
     * @param   string  $line   A line from a CSV plant data file. 
     *
     * @return void
     */
    public function parsePlant($line) 
    {
        // We want to work with the line as an array.  Blow it up.
        $data = array_map('trim', explode(',', $line));

        $genus = $data[GENUS];
        $species = $data[SPECIES];
        $this->debug("Processing '{$genus} {$species}'...");

        $plant = Plant::where('genus', $genus)
            ->where('species', $species)
            ->first();
        if ( $plant === NULL ) {
            $this->debug("Creating new plant for '{$genus} {$species}'...");
            $plant = new Plant();
            $plant->species = $species;
            $plant->genus = $genus;
        }

        $plant->family = $data[FAMILY];

        list($plant->minimum_ph, $plant->maximum_ph) = $this->parsePH($data[PH]);
        list($plant->minimum_zone, $plant->maximum_zone) = $this->parseZone($data[ZONE]);
        $plant->form = $this->parseForm($data[FORM]);
        list($plant->minimum_height, $plant->maximum_height) = $this->parseHeight($data[HEIGHT]);
        list($plant->minimum_width, $plant->maximum_width) = $this->parseWidth($data[WIDTH]);
        // ---------------------------- Growth Rate ---------------------------
        // Format: [Growth Rate]
        // Examples: F, M, S
        $plant->growth_rate = strtolower($data[GROWTH_RATE]);

        // ---------------------------- Native Region -------------------------
        // Format: [Native Region]
        // Examples: ENA, EURA, ASIA
        $plant->native_region = $data[NATIVE_REGION];

        $plant_name = $plant->genus . ' ' . $plant->species;
        $this->debug('Saving plant "' . $plant_name . '".');
        $plant->save();

        // Begin parsing data for related models.

        if(!empty($data[COMMON_NAME])) {
            $this->debug('Processing ' . $plant_name . '\'s common names.');
            $name = $data[COMMON_NAME];
            if($plant->commonNames()->where('name', $name)->first() === null) {
                $common_name = new PlantCommonName();
                $common_name->name = $name;
                $plant->commonNames()->save($common_name);
            }
        }

        if(!empty($data[LIGHT])) {
            $this->debug('Processing ' . $plant_name . '\'s light tolerances.');
            $light_tolerance_ids = $this->parseLightTolerances($data[LIGHT]);
            $plant->lightTolerances()->sync($light_tolerance_ids);
        }
        
        if(!empty($data[MOISTURE])) {
            $this->debug('Processing ' . $plant_name . '\'s moisture tolerances.');
            $moisture_tolerance_ids = $this->parseMoistureTolerances($data[MOISTURE]);
            $plant->moistureTolerances()->sync($moisture_tolerance_ids);
        }

        if(!empty($data[HABIT])) {
            $this->debug("Processing $plant_name's habit.");
            $habit_ids = $this->parseHabit($data[HABIT]);
            $plant->habits()->sync($habit_ids);
        }

        if(!empty($data[ROOT_PATTERN])) {
            $this->debug("Processing $plant_name's root pattern.");
            $root_pattern_ids = $this->parseRootPattern($data[ROOT_PATTERN]);
            $plant->rootPatterns()->sync($root_pattern_ids);
        }

        if(!empty($data[HABITATS])) {
            $this->debug("Processing $plant_name's habitats.");
            $habitat_ids = $this->parseHabitats($data[HABITATS]);
            $plant->habitats()->sync($habitat_ids);
        }

        if(!empty($data[USES])) {
            $this->debug("Processing $plant_name's harvests.");
            $plant_harvests = $this->parseHarvest($data[USES]);
            $plant->harvests()->sync($plant_harvests);
        }

        if(!empty($data[FUNCTIONS])) {
            $this->debug("Processing $plant_name's roles.");
            $role_ids = $this->parseRoles($data[FUNCTIONS]);
            $plant->roles()->sync($role_ids);
        }

        if( ! empty($data[DRAWBACKS])) {
            $this->debug("Processing $plant_name's drawbacks [{$data[DRAWBACKS]}].");
            $drawback_ids = $this->parseDrawbacks($data[DRAWBACKS]);
            $plant->drawbacks()->sync($drawback_ids);
        }
    }

    /**
     * Parse the plant's light tolerances and return an array of ids.
     *
     * Format: tolerance;tolerance*
     * Possible Values: Sun, Shade, Partial
     * Examples: Shade;Partial, Sun;Partial, Sun;Shade
     *
     * @param   mixed[] $light_string   The light data parsed from the CSV file.
     * @return  int[]   An array of LightTolerance ids. 
     */
    public function parseLightTolerances($light_string) 
    {
        $light_tolerance_names = array_map('trim', explode(';', $light_string));
        $light_tolerance_map = ['Sun'=>1, 'Partial'=>2, 'Shade'=>3];
        $light_tolerance_ids = []; 
        foreach($light_tolerance_names as $name)
        {
            if (empty($light_tolerance_map[$name])) {
                $this->error('Found invalid light tolerance "' . $name . '"');
                continue;
            }

            $light_tolerance_ids[$light_tolerance_map[$name]] = true;
        }
        return array_keys($light_tolerance_ids);
    }

    /**
     * Parse the plant's moisture tolerances.
     *
     * Format: tolerance;tolerance*
     * Possible Values: Xeric, Mesic, Hydric
     * Examples: Xeric, Xeric;Mesic, Hydric,Mesic 
     *
     * @param   mixed[] $moisture_string     The moisture data parsed from the
     *      CSV file.
     * @return  int[]  An array of MoistureTolerance ids. 
     */
    public function parseMoistureTolerances($moisture_string)
    {
        $moisture_tolerance_names = array_map('trim', explode(';', $moisture_string));
        $moisture_tolerance_map = ['Xeric'=>1, 'Mesic'=>2, 'Hydric'=>3];
        $moisture_tolerance_ids = [];
        foreach($moisture_tolerance_names as $name) {
            if(empty($moisture_tolerance_map[$name])) {
                $this->error('Found invalid moisture tolerance "' . $name . '"');
                continue;
            }
            $moisture_tolerance_ids[$moisture_tolerance_map[$name]] = true;
        }
        return array_keys($moisture_tolerance_ids);
    }

    /**
     * Parse the plant's growth habit.
     *
     * Format: symbol symbol* 
     * Possible Values: E, std, skr, spr, ms, Ctkt, Rtkt, Cmat, Rmat, w, r,
     *      vine, v/kr, a, e, clmp, run
     * Examples: clmp, w vine, Rtkt, r vine, a e clmp
     *
     * @param   mixed[] $habit_string   The parsed CSV data.
     * @return  int[]   An array of Habit ids.
     */
    public function parseHabit($habit_string)
    {
        $habit_symbols = array_map('trim', explode(' ', $habit_string));
        $habit_ids = [];
        foreach($habit_symbols as $symbol) {
            $habit = Habit::where('symbol', $symbol)->first();
            if ( ! $habit) {
                $this->error('Failed to find habit "' . $symbol . '"');
                continue;
            }
            $habit_ids[] = $habit->id;
        }
        return $habit_ids;
    }

    /**
     * Parse the plant's root patterns.
     *
     * Format: symbol;symbol*
     * Possible values: F, FB, H, T, Sk, St, B, C, R, Tu, Fl, St
     * Examples: F;FB, St;F, Sk;R;FB  
     *
     * @param   mixed[] $root_pattern_string    The parsed CSV data.
     * @return  int[]   An array of RootPattern ids.
     */
    public function parseRootPattern($root_pattern_string)
    {
        $root_pattern_symbols = array_map('trim', explode(';', $root_pattern_string));
        $root_pattern_ids = [];
        foreach($root_pattern_symbols as $symbol) {
            $root_pattern = RootPattern::where('symbol', $symbol)->first();
            if ( ! $root_pattern) {
                $this->error('Failed to find root pattern "' . $symbol . '"');
                continue;
            }
            $root_pattern_ids[] = $root_pattern->id;
        }
        return $root_pattern_ids;
    }

    /**
     * Parse the plant's habitats.
     *
     * Format: habitat;habitat*
     * Possible values: Disturbed, Meadows, Prairies, Oldfields, Thickets,
     *      Edges, Gaps/Clearings, Open Woods, Forest, Conifer Forest, Other
     * Examples: Disturbed;Meadows;Oldfields, Forest;Open Woods,
     *      Gaps/Clearings;Open Woods;Conifer Forest
     *
     * @param   mixed[] $habitat_string The parsed CSV data.
     * @return  int[]   An array of Habitat ids.
     */
    public function parseHabitats($habitat_string) 
    {
        $habitats = array_map('trim', explode(';', $habitat_string));
        $habitat_ids = [];
        foreach($habitats as $name) {
            if (strlen($name) == 0) {
                continue;
            }
            $habitat = Habitat::where('name', $name)->first();
            if ( ! $habitat) {
                $this->error('Failed to find habitat "' . $name . '"');
                continue;
            }
            $habitat_ids[] = $habitat->id;
        }
        return $habitat_ids;
    }

    /**
     * Parse the plant's possible harvests.
     *
     * Format: harvest(rating);harvest(rating)*
     * Possible Harvests: Fruit, Nuts/Mast, Greens, Roots, Culinary, Tea,
     *      Other, Medicinal 
     * Possible Ratings: E, G, F, Y, S
     * Examples: Fruit(E);Medicinal(Y)
     *
     * @param   mixed[] $harvest_string The parsed CSV data.
     * @return  int[]   An array of Harvest ids.
     */
    public function parseHarvest($harvest_string)
    {
        $harvest_strings = array_map('trim', explode(';', $harvest_string));
        $plant_harvests = [];
        foreach($harvest_strings as $harvest_string) {
            preg_match('/(\w+\s*\w*)\((\w+)\)/', $harvest_string, $matches);
            $name = $matches[1];
            $rating = $matches[2];

            $harvest = Harvest::where('name', $name)->first();
            if ( ! $harvest) {
                $this->error('Failed to find a harvest for "' . $name . '"');
                continue;
            }
            $plant_harvests[$harvest->id] = ['rating'=>$rating];
        }
        return $plant_harvests;
    }

    /**
     * Parse this plants roles in the ecosystem.
     *
     * Format: role;role*
     * Possible Values: N2, Dynamic Accumulator, Wildlife(F), Wildlife(S),
     *      Wildlife(B), Invert Shelter, Nectary(G), Nectary(S), Ground Cover,
     *      Other(A), Other(C) 
     * Examples: N2;Willife(F);Invert Shelter, Dynamic Accumulator;Wildlife(S)
     *
     * @param   mixed[] $role_string    The parsed CSV data.
     * @return  int[]   An array of Role ids.
     */
    public function parseRoles($role_string)
    {
        $role_strings = array_map('trim', explode(';', $role_string));
        $role_ids = [];
        $role_names = [
            'N2'=>'Nitrogen Fixer',
            'Dynamic Accumulator'=>'Dynamic Accumulator',
            'Wildlife(F)'=>'Wildlife Food',
            'Wildlife(S)'=>'Wildlife Shelter',
            'Wildlife(B)'=>['Wildlife Food', 'Wildlife Shelter'],
            'Invert Shelter'=>'Invertabrate Shelter',
            'Nectary(G)'=>'Generalist Nectary',
            'Nectary(S)'=>'Specialist Nectary',
            'Ground Cover'=>'Ground Cover',
            'Other(A)'=>'Aromatic',
            'Other(C)'=>'Coppice'];
        foreach($role_strings as $role_string) {

            if ( empty($role_names[$role_string])) {
                $this->error('Found invalid role "' . $role_string . '"');
                continue;
            }

            if(is_array($role_names[$role_string])) {
                foreach($role_names[$role_string] as $name) {
                    $role = Role::where('name', $name)->first();
                    if ( ! $role) {
                        $this->error('Failed to find role for "' . $role_string . '"');
                        continue;
                    }
                    $role_ids[]  = $role->id;
                }
            } else {
                $role = Role::where('name', $role_names[$role_string])->first();
                if ( ! $role) {
                    $this->error('Failed to find role for "' . $role_string . '"');
                    continue;
                }
                $role_ids[] = $role->id;
            }
        }
        return $role_ids;
    }

    /**
     * Parse this plant's drawbacks.
     *
     * Format: drawback;drawback*
     * Possible Values: A, D, E, H, Ps, S, St, T P
     * Examples: P;D, D, P;H;Ps, A;D
     *
     * @param   mixed[] $drawbacks_string  The parsed CSV data.
     * @return  int[]   An array of Drawback ids.
     */
    public function parseDrawbacks($drawbacks_string)
    {
        $drawback_symbols = array_map('trim', explode(';', $drawbacks_string));
        $drawback_ids = [];
        $drawback_names = [
            'A'=>'Allelopathic',
            'D'=>'Dispersive',
            'E'=>'Expansive',
            'H'=>'Hay Fever',
            'Ps'=>'Persistent',
            'S'=>'Sprawling vigorous vine',
            'St'=>'Stings',
            'T'=>'Thorny',
            'P'=>'Poison'
        ];
        foreach($drawback_symbols as $symbol) {
            if ( strlen($symbol) == 0 ) {
                continue;
            }
            $drawback = Drawback::where('name', $drawback_names[$symbol])->first();
            if ( ! $drawback) {
                $this->error('Failed to find drawback for "' . $symbol. '"');
                continue;
            }
            $drawback_ids[] = $drawback->id;
        }
        return $drawback_ids;
    }

    /**  
     * Parse out this plant's Soil pH requirements.
     *
     * Format: [0-2]:[0-2]:[0-2]:[0-2]
     * Examples: 0:0:2:2, 0:1:2:1, 1:2:2:1, 0:0:0:2
     *
     * @param   mixed[] $ph_string  The parsed CSV data.
     * @return  float[]   An array containing the minimum and maximum pH values
     *      in list form: ``array(0=>minimum_ph, 1=>maximum_ph)``
     */
    public function parsePH($ph_string) 
    {
		$phs = array_map('trim', explode(':', $ph_string));
		$minimum_ph_values = [
			0=>[1=>4.00, 2=>3.5],
			1=>[1=>5.35, 2=>5.1],
			2=>[1=>6.35, 2=>6.1],
			3=>[1=>7.50, 2=>7.1]];
		$maximum_ph_values = [
			0=>[1=>4.50, 2=>5.0],
			1=>[1=>5.80, 2=>6.0],
			2=>[1=>6.80, 2=>7.0],
            3=>[1=>7.80, 2=>8.5]];
        $minimum_ph = 6.1;
        $maximum_ph = 7.0;
        if ( count($phs) < 4) {
            $this->error('Failed to parse pH values.  Bad data in pH values.');
            return [$minimum_ph, $maximum_ph];
        }

		for($i = 0; $i < 4; $i++) {
			if( $phs[$i] == 1 || $phs[$i] == 2) {
				$minimum_ph = $minimum_ph_values[$i][$phs[$i]];
				break;
            } else if ($phs[$i] > 2 || $phs[$i] < 0) {
                $this->error('Bad data in pH values.');
            }
		}
		for($i = 3; $i >= 0; $i--) {
			if( $phs[$i] == 1 || $phs[$i] == 2) {
				$maximum_ph = $maximum_ph_values[$i][$phs[$i]];
				break;
            } else if ($phs[$i] > 2 || $phs[$i] < 0) {
                $this->error('Bad data in pH values.');
            }
        }

        return [$minimum_ph, $maximum_ph]; 
    }

    /**
     * Parse this plant's USDA zone.
     *
     * Formats: [Minimum Zone] - [Maximum Zone] OR [Minimum Zone]
     * Examples: 3 - 7 OR 3b
     *
     * @param   mixed[] $zone_string    The parsed CSV data.
     * @return  string[]   An array containing the minimum and maximum zone values
     *      in list form: ``array(0=>minimum_zone, 1=>maximum_zone)``
     */
    public function parseZone($zone_string) 
    {
        if (strpos($zone_string, '-') !== FALSE) {
            list($minimum_zone, $maximum_zone) = array_map('trim', explode('-', trim($zone_string)));
        } else {
            $minimum_zone = trim($zone_string); 
            $maximum_zone = null;
        }

        // Generate the list of valid zones.  They range from 1 - 13 and each
        // zone can have an 'a' or a 'b'.  Examples: 1, 1a, 1b, 10a, 7b, 3
        $valid_zones = [];
        for($i = 1; $i <= 13; $i++) {
            $valid_zones[] = (string)$i; // We have to cast it to a string
            // because in_array cannot intelligently perform this check using
            // loose checking and strict checking fails unless the types match.
            $valid_zones[] = $i.'a';
            $valid_zones[] = $i.'b';
        }

        if ( $minimum_zone !== null && ! in_array($minimum_zone, $valid_zones, true)) {
            $this->error("Invalid zone detected [$minimum_zone]");
            $minimum_zone = null;
        }

        if ( $maximum_zone !== null && ! in_array($maximum_zone, $valid_zones, true)) {
            $this->error("Invalid zone detected [$maximum_zone]");
            $maximum_zone = null;
        }

        return array($minimum_zone, $maximum_zone);
    }

    /**
     * Parse this plant's form.
     *
     * Format: [size] [form]
     * Examples: m Shrub, l Tree, s-m Herb
     *
     * @param   mixed[] $form_string    The parsed CSV data.
     * @return  string  This plant's form.
     */
    public function parseForm($form_string)
    {
        $forms = array_map('trim', explode(' ', $form_string));
        if (count($forms) > 2) {
            $this->error('Failed to properly parse form.  Possible data error? [' . $form_string .']');
            return '';
        }

        if (empty($forms[1])) {
            $this->error('Failed to properly parse form.  Possible data error? [' . $form_string .']');
            return '';
        }
		return strtolower($forms[1]); // We're ignoring size.  You can get it from the height / width.
    }
    
    /**
     * Parse the plant's height (minimum and maximum).
     *
     * Format:  [Minimum Height]' - [Maximum Height]' OR [Maximum Height]' 
     *      OR [Minimum Height]" - [Maximum Height]" OR [Maximum Height]"
     * Examples: 20' - 100', 7', 24", 12" - 24"
     *
     * @param   mixed[] $height_string  The parsed CSV data.
     * @return  float[] An array containing this plant's minimum and maximum
     *      heights (``array(0=>minimum_height, 1=>maximum_height)``).
     */
    public function parseHeight($height_string)
    {
		if (strpos($height_string, '-') !== FALSE) {
			list($minimum_height, $maximum_height) = array_map('trim', explode('-', $height_string));
		} else {
            $maximum_height = trim($height_string);
            $minimum_height = null; // If we've only got one value, then it's the maximum.
        }

        // Parse the minimum_height and ensure good data.
        if ($minimum_height !== null && preg_match('/^(\d+)(\'|")$/', $minimum_height, $matches)) {
            $minimum_height = (float)$matches[1];
            if ($matches[2] == '"') {
                $minimum_height = $minimum_height / 12;
            }
        } else if($minimum_height !== null){
            $this->error("Invalid minimum height [$minimum_height]");
            $minimum_height = null;
        }

        // Parse the maximum_height and ensure good data.
        if ($maximum_height !== null && preg_match('/^(\d+)(\'|")$/', $maximum_height, $matches)) {
            $maximum_height = (float)$matches[1];
            if ($matches[2] == '"') {
                $maximum_height = $maximum_height / 12;
            }
        } else if($maximum_height !== null){
            $this->error("Invalid minimum width [$maximum_height]");
            $maximum_height = null;
        }

        return array($minimum_height, $maximum_height);
    }

    /**
     * Parse the plant's width (minimum and maximum).
     * Format:  [Minimum Width]' - [Maximum Width]' OR [Maximum Width]' 
     *      OR [Minimum Width]" - [Maximum Width]" OR [Maximum Width]"
     * Examples: 20' - 100', 7', 24", 12" - 24"
     * 
     * @param   mixed[] $width_string   The parsed CSV data.
     * @return  float[] An array containing this plant's minimum and maximum
     *      widths(``array(0=>minimum_width, 1=>maximum_width)``).
     */
    public function parseWidth($width_string)
    {
		if (strpos($width_string, '-') !== FALSE) {
			list($minimum_width, $maximum_width) = array_map('trim', explode('-', $width_string));
		} else {
            $maximum_width = trim($width_string);
            $minimum_width = null; // If we've only got one value, then it's
            // the maximum.
        }

        // Parse the minimum_width and ensure good data.
        if ($minimum_width !== null && preg_match('/^(\d+)(\'|")$/', $minimum_width, $matches)) {
            $minimum_width = (float)$matches[1];
            if ($matches[2] == '"') {
                $minimum_width = $minimum_width / 12;
            }
        } else if($minimum_width !== null){
            $this->error("Invalid minimum width [$minimum_width]");
            $minimum_width = null;
        }

        // Parse the maximum_width and ensure good data.
        if ($maximum_width !== null && preg_match('/^(\d+)(\'|")$/', $maximum_width, $matches)) {
            $maximum_width = (float)$matches[1];
            if ($matches[2] == '"') {
                $maximum_width = $maximum_width / 12;
            }
        } else if(strtolower($maximum_width) === 'indefinite') {
            $maximum_width = -1; 
        } else if($maximum_width !== null){
            $this->error("Invalid minimum width [$maximum_width]");
            $maximum_width = null;
        }
        return array($minimum_width, $maximum_width);
    }

}
