<?php

use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

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
 * A command to load our data from a CSV file where we are compiling it
 * in to the database.
 *
 * To run from the command line:
 * php artisan data:load [datafile]
 *
 */
class DataLoad extends Command {

	/**
	 * The console command name.
	 *
	 * @var string
	 */
	protected $name = 'data:load';

	/**
	 * The console command description.
	 *
	 * @var string
	 */
	protected $description = 'Load data from a csv file.';

	/**
	 * Do we want verbose debugging messages?
	 */
	protected $debug = true;

	/**
	 * Create a new command instance.
	 *
	 * @return void
	 */
	public function __construct()
	{
		parent::__construct();
	}

	/**
	 * Execute the console command.
	 *
	 * @return void
	 */
	public function fire()
	{
		$filename = $this->argument('csv_file');
		$this->debug('Starting processing of data file: ' . $filename);
		$lines = explode("\n", file_get_contents($filename));

		$this->debug('Data file contains ' . count($lines) . ' lines of data.');
		$counter = 1;
		foreach($lines as $line) {
			if (strlen($line) < 1) {
				break;
			}
			$this->debug('Processing line ' . $counter . ' of ' . count($lines));
			$data = explode(',', $line);

            $genus = trim($data[GENUS]);
            $species = trim($data[SPECIES]);
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

            list($plant->minimum_ph, $plant->maximum_ph) = $this->parsePH($data);
            list($plant->minimum_zone, $plant->maximum_zone) = $this->parseZone($data);
            $plant->form = $this->parseForm($data);
            list($plant->minimum_height, $plant->maximum_height) = $this->parseHeight($data);
            list($plant->minimum_width, $plant->maximum_width) = $this->parseWidth($data);
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
                $name = $this->parseCommonNames($data);
                if($plant->commonNames()->where('name', $name)->first() === null) {
                    $common_name = new PlantCommonName();
                    $common_name->name = $name;
                    $plant->commonNames()->save($common_name);
                }
            }

            if(!empty($data[LIGHT])) {
                $this->debug('Processing ' . $plant_name . '\'s light tolerances.');
                $light_tolerance_ids = $this->parseLightTolerances($data);
                $plant->lightTolerances()->sync($light_tolerance_ids);
            }
            
            if(!empty($data[MOISTURE])) {
                $this->debug('Processing ' . $plant_name . '\'s moisture tolerances.');
                $moisture_tolerance_ids = $this->parseMoistureTolerances($data);
                $plant->moistureTolerances()->sync($moisture_tolerance_ids);
            }

			if(!empty($data[HABIT])) {
                $this->debug("Processing $plant_name's habit.");
                $habit_ids = $this->parseHabit($data);
				$plant->habits()->sync($habit_ids);
			}

            if(!empty($data[ROOT_PATTERN])) {
                $this->debug("Processing $plant_name's root pattern.");
                $root_pattern_ids = $this->parseRootPattern($data);
				$plant->rootPatterns()->sync($root_pattern_ids);
			}

			if(!empty($data[HABITATS])) {
                $this->debug("Processing $plant_name's habitats.");
                $habitat_ids = $this->parseHabitats($data);
				$plant->habitats()->sync($habitat_ids);
			}

			if(!empty($data[USES])) {
                $this->debug("Processing $plant_name's harvests.");
                $plant_harvests = $this->parseHarvest($data);
				$plant->harvests()->sync($plant_harvests);
			}

			if(!empty($data[FUNCTIONS])) {
                $this->debug("Processing $plant_name's roles.");
                $role_ids = $this->parseRoles($data);
				$plant->roles()->sync($role_ids);
			}

            if( ! empty($data[DRAWBACKS])) {
                $this->debug("Processing $plant_name's drawbacks [". trim($data[DRAWBACKS]). "].");
                $drawback_ids = $this->parseDrawbacks($data);
                $plant->drawbacks()->sync($drawback_ids);
			}
			$counter++;
		}
		$this->debug('Processing complete.');
	}

    /**
     * Parse the plant's common name and build a CommonName object.
     *
     * @param   mixed[] $data   The data parsed from the CSV file.
     * @return  PlantCommonName The parsed common name of the Plant.
     */
    protected function parseCommonNames($data) 
    {
        return $data[COMMON_NAME];
    }

    /**
     * Parse the plant's light tolerances and return an array of ids.
     *
     * Format: tolerance;tolerance*
     * Possible Values: Sun, Shade, Partial
     * Examples: Shade;Partial, Sun;Partial, Sun;Shade
     *
     * @param   mixed[] $data   The data parsed from the CSV file.
     * @return  int[]   An array of LightTolerance ids. 
     */
    protected function parseLightTolerances($data) 
    {
        $light_tolerance_names = array_map('trim', explode(';', $data[LIGHT]));
        $light_tolerance_map = array('Sun'=>1, 'Partial'=>2, 'Shade'=>3);
        $light_tolerance_ids = array();
        foreach($light_tolerance_names as $name)
        {
            $light_tolerance_ids[] = $light_tolerance_map[$name];
        }
        return $light_tolerance_ids;
    }

    /**
     * Parse the plant's moisture tolerances.
     *
     * Format: tolerance;tolerance*
     * Possible Values: Xeric, Mesic, Hydric
     * Examples: Xeric, Xeric;Mesic, Hydric,Mesic 
     *
     * @param   mixed[] $data   The data parsed from the CSV file.
     * @return  int[]  An array of MoistureTolerance ids. 
     */
    protected function parseMoistureTolerances($data)
    {
        $moisture_tolerance_names = array_map('trim', explode(';', $data[MOISTURE]));
        $moisture_tolerance_map = array('Xeric'=>1, 'Mesic'=>2, 'Hydric'=>3);
        $moisture_tolerance_ids = array();
        foreach($moisture_tolerance_names as $name) {
            $moisture_tolerance_ids[] = $moisture_tolerance_map[$name];
        }
        return $moisture_tolerance_ids;
    }

    /**
     * Parse the plant's growth habit.
     *
     * Format: symbol symbol* 
     * Possible Values: E, std, skr, spr, ms, Ctkt, Rtkt, Cmat, Rmat, w, r,
     *      vine, v/kr, a, e, clmp, run
     * Examples: clmp, w vine, Rtkt, r vine, a e clmp
     *
     * @param   mixed[] $data   The parsed CSV data.
     * @return  int[]   An array of Habit ids.
     */
    protected function parseHabit($data)
    {
        $habit_symbols = array_map('trim', explode(' ', $data[HABIT]));
        $habit_ids = array();
        foreach($habit_symbols as $symbol) {
            $habit = Habit::where('symbol', $symbol)->first();
            if ( ! $habit) {
                $this->error('Failed to find habit "' . $symbol . '"');
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
     * @param   mixed[] $data   The parsed CSV data.
     * @return  int[]   An array of RootPattern ids.
     */
    protected function parseRootPattern($data)
    {
        $root_pattern_symbols = array_map('trim', explode(';', $data[ROOT_PATTERN]));
        $root_pattern_ids = array();
        foreach($root_pattern_symbols as $symbol) {
            $root_pattern = RootPattern::where('symbol', $symbol)->first();
            if ( ! $root_pattern) {
                $this->error('Failed to find root pattern "' . $symbol . '"');
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
     * @param   mixed[] $data   The parsed CSV data.
     * @return  int[]   An array of Habitat ids.
     */
    protected function parseHabitats($data) 
    {
        $habitats = array_map('trim', explode(';', $data[HABITATS]));
        $habitat_ids = array();
        foreach($habitats as $name) {
            if (strlen($name) == 0) {
                continue;
            }
            $habitat = Habitat::where('name', $name)->first();
            if ( ! $habitat) {
                $this->error('Failed to find habitat "' . $name . '"');
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
     * @param   mixed[] $data   The parsed CSV data.
     * @return  int[]   An array of Harvest ids.
     */
    protected function parseHarvest($data)
    {
        $harvest_strings = array_map('trim', explode(';', $data[USES]));
        $plant_harvests = array();
        foreach($harvest_strings as $harvest_string) {
            $this->debug('Processing harvest "' . $harvest_string . '"');

            preg_match('/(\w+\s*\w*)\((\w+)\)/', $harvest_string, $matches);
            $name = $matches[1];
            $rating = $matches[2];

            $harvest = Harvest::where('name', $name)->first();
            if ( ! $harvest) {
                $this->error('Failed to find a harvest for "' . $name . '"');
            }
            $plant_harvests[$harvest->id] = array('rating'=>$rating);
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
     * @param   mixed[] $data   The parsed CSV data.
     * @return  int[]   An array of Role ids.
     */
    protected function parseRoles($data)
    {
        $role_strings = array_map('trim', explode(';', $data[FUNCTIONS]));
        $role_ids = array();
        $role_names = array(
            'N2'=>'Nitrogen Fixer',
            'Dynamic Accumulator'=>'Dynamic Accumulator',
            'Wildlife(F)'=>'Wildlife Food',
            'Wildlife(S)'=>'Wildlife Shelter',
            'Wildlife(B)'=>array('Wildlife Food', 'Wildlife Shelter'),
            'Invert Shelter'=>'Invertabrate Shelter',
            'Nectary(G)'=>'Generalist Nectary',
            'Nectary(S)'=>'Specialist Nectary',
            'Ground Cover'=>'Ground Cover',
            'Other(A)'=>'Aromatic',
            'Other(C)'=>'Coppice');
        foreach($role_strings as $role_string) {
            $this->debug('Processing role "' . $role_string . '"');
            if(is_array($role_names[$role_string])) {
                foreach($role_names[$role_string] as $name) {
                    $role = Role::where('name', $name)->first();
                    if ( ! $role) {
                        $this->error('Failed to find role for "' . $role_string . '"');
                    }
                    $role_ids[]  = $role->id;
                }
            } else {
                $role = Role::where('name', $role_names[$role_string])->first();
                if ( ! $role) {
                    $this->error('Failed to find role for "' . $role_string . '"');
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
     * @param   mixed[] $data   The parsed CSV data.
     * @return  int[]   An array of Drawback ids.
     */
    protected function parseDrawbacks($data)
    {
        $drawback_symbols = array_map('trim', explode(';', $data[DRAWBACKS]));
        $drawback_ids = array();
        $drawback_names = array(
            'A'=>'Allelopathic',
            'D'=>'Dispersive',
            'E'=>'Expansive',
            'H'=>'Hay Fever',
            'Ps'=>'Persistent',
            'S'=>'Sprawling vigorous vine',
            'St'=>'Stings',
            'T'=>'Thorny',
            'P'=>'Poison'
        );
        foreach($drawback_symbols as $symbol) {
            if ( strlen($symbol) == 0 ) {
                continue;
            }
            $drawback = Drawback::where('name', $drawback_names[$symbol])->first();
            if ( ! $drawback) {
                $this->error('Failed to find drawback for "' . $symbol. '"');
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
     * @param   mixed[] $data   The parsed CSV data.
     * @return  float[]   An array containing the minimum and maximum pH values
     *      in list form: ``array(0=>minimum_ph, 1=>maximum_ph)``
     */
    public function parsePH($data) 
    {
		$phs = array_map('trim', explode(':', $data[PH]));
		$minimum_ph_values = array(
			0=>array(1=>4.25, 2=>3.5),
			1=>array(1=>5.55, 2=>5.1),
			2=>array(1=>6.55, 2=>6.1),
			3=>array(1=>7.55, 2=>7.1));
		$maximum_ph_values = array(
			0=>array(1=>4.25, 2=>5.0),
			1=>array(1=>5.55, 2=>6.0),
			2=>array(1=>6.55, 2=>7.0),
            3=>array(1=>7.55, 2=>8.5));
        $ph_list = array();
		for($i = 0; $i < 4; $i++) {
			if( $phs[$i] > 0 ) {
				$ph_list[] = $minimum_ph_values[$i][$phs[$i]];
				break;
			}
		}
		for($i = 3; $i > 0; $i--) {
			if( $phs[$i] > 0 ) {
				$ph_list[] = $maximum_ph_values[$i][$phs[$i]];
				break;
			}
        }
        return $ph_list; 
    }

    /**
     * Parse this plant's USDA zone.
     *
     * Formats: [Minimum Zone] - [Maximum Zone] OR [Minimum Zone]
     * Examples: 3 - 7 OR 3b
     *
     * @param   mixed[] $data   The parsed CSV data.
     * @return  string[]   An array containing the minimum and maximum zone values
     *      in list form: ``array(0=>minimum_zone, 1=>maximum_zone)``
     */
    public function parseZone($data) 
    {
        if (strpos($data[ZONE], '-') !== FALSE) {
            list($minimum_zone, $maximum_zone) = array_map('trim', explode('-', $data[ZONE]));
        } else {
            $minimum_zone = $data[ZONE]; 
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
     * @param   mixed[] $data   The parsed CSV data.
     * @return  string  This plant's form.
     */
    public function parseForm($data)
    {
        $forms = array_map('trim', explode(' ', $data[FORM]));
        if (empty($forms[1])) {
            $this->error('Failed to properly parse form.  Possible data error? [' . $data[FORM] .']');
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
     * @param   mixed[] $data   The parsed CSV data.
     * @return  float[] An array containing this plant's minimum and maximum
     *      heights (``array(0=>minimum_height, 1=>maximum_height)``).
     */
    public function parseHeight($data)
    {
		if (strpos($data[HEIGHT], '-') !== FALSE) {
			list($minimum_height, $maximum_height) = array_map('trim', explode('-', $data[HEIGHT]));
		} else {
            $maximum_height = $data[HEIGHT];
            $minimum_height = null; // If we've only got one value, then it's the maximum.
		}

		if ($minimum_height !== null && strpos($minimum_height, "'") !== FALSE)  {
			$minimum_height = str_replace('\'', '', $minimum_height);
		} else if ($minimum_height !== null && strpos($minimum_height, '"') !== FALSE) {
			$minimum_height = ((float)str_replace('"', '', $minimum_height))/12;
		}

		if (strpos($maximum_height, "'") !== FALSE)  {
			$maximum_height = str_replace('\'', '', $maximum_height);
		} else if(strpos($maximum_height, '"') !== FALSE) {
			$maximum_height = ((float)str_replace('"', '', $maximum_height))/12;
        }
        return array($minimum_height, $maximum_height);
    }

    /**
     * Parse the plant's width (minimum and maximum).
     * Format:  [Minimum Width]' - [Maximum Width]' OR [Maximum Width]' 
     *      OR [Minimum Width]" - [Maximum Width]" OR [Maximum Width]"
     * Examples: 20' - 100', 7', 24", 12" - 24"
     * 
     * @param   mixed[] $data   The parsed CSV data.
     * @return  float[] An array containing this plant's minimum and maximum
     *      widths(``array(0=>minimum_width, 1=>maximum_width)``).
     */
    public function parseWidth($data)
    {
		if (strpos($data[WIDTH], '-') !== FALSE) {
			list($minimum_width, $maximum_width) = array_map('trim', explode('-', $data[WIDTH]));
		} else {
            $maximum_width = $data[WIDTH];
            $minimum_width = null; // If we've only got one value, then it's
            // the maximum.
		}

        if ($minimum_width !== null && strpos($minimum_width, "'") !== FALSE) {
            // Minimum Width given in feet.  Just parse out the unit.
			$minimum_width = str_replace('\'', '', $minimum_width);
        } else if ($minimum_width !== null && strpos($minimum_width, '"') !== FALSE) {
            // Minimum Width given in inches.  Parse out the unit and convert
            // to feet.
			$minimum_width = ((float)str_replace('"', '', $minimum_width))/12;
		}

		if (strpos($maximum_width, "'") !== FALSE) {
            // Maximum Width given in feet.  Just parse out the unit.
            $maximum_width = str_replace('\'', '', $maximum_width);
		} else if (strpos($maximum_width, '"') !== FALSE) { 
            // Maximum Width given in inches.  Parse out the unit and convert
            // to feet.
			$maximum_width = ((float)str_replace('"', '', $maximum_width))/12;
        }
        return array($minimum_width, $maximum_width);
    }

	/**
	 * Print a Debug Message
	 *
	 * @param	string $message The message to print.
	 * @return void
	 */
	protected function debug($message)
	{
		$now = new DateTime();
		$this->info($now->format("Y-m-d\tH:i:sO") . ':: ' . $message);
    }

    /**
     * Print an Error message to the console.
     *
     * @param   string  $message    The message to print.
     * @return void
     */
    public function error($message)
    {
		$now = new DateTime();
        $message = $now->format("Y-m-d\tH:i:sO") . ':: ' . $message . "\n";
        parent::error($message);
    }

	/**
	 * Print an error message and kill execution
	 *
	 * @param	string	$message The message to print.
	 *
	 * @return void
	 */
	protected function fatalError($message)
	{
		$this->debug('**FATAL ERROR**: ' . $message);
		exit();
	}

	/**
	 * Get the console command arguments.
	 *
	 * @return array
	 */
	protected function getArguments()
	{
		return array(
			array('csv_file', InputArgument::REQUIRED, 'The file to be processed into the database.'),
		);
	}

	/**
	 * Get the console command options.
	 *
	 * @return array
	 */
	protected function getOptions()
	{
		return array();
	}

}
