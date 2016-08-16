<?php

use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

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
			$plant = new Plant();

			$this->debug('Processing plant...');
			// If this plant already exists in the database, then
			// move on to the next one.
			if ( ! $this->parsePlant($plant, $data)) {
				$this->debug('Plant ' . $plant->genus . ' ' . $plant->species . ' already exists.  Skipping...');
				continue;
			}
			$plant_name = $plant->genus . ' ' . $plant->species;
			$this->debug('Saving plant "' . $plant_name . '".');
			$plant->save();

			$this->debug('Processing ' . $plant_name . '\'s common names.');
			$common_name = new PlantCommonName();
			$common_name->name = $data[COMMON_NAME];
			$common_name->plant_id = $plant->id;
			$common_name->save();

			$this->debug('Processing ' . $plant_name . '\'s light tolerances.');
			$light_tolerance_names = array_map('trim', explode(';', $data[LIGHT]));
			$light_tolerance_map = array('Sun'=>1, 'Partial'=>2, 'Shade'=>3);
			$light_tolerance_ids = array();
			foreach($light_tolerance_names as $name)
			{
				$light_tolerance_ids[] = $light_tolerance_map[$name];
			}
			$plant->lightTolerances()->sync($light_tolerance_ids);

			$this->debug('Processing ' . $plant_name . '\'s moisture tolerances.');
			$moisture_tolerance_names = array_map('trim', explode(';', $data[MOISTURE]));
			$moisture_tolerance_map = array('Xeric'=>1, 'Mesic'=>2, 'Hydric'=>3);
			$moisture_tolerance_ids = array();
			foreach($moisture_tolerance_names as $name)
			{
				$moisture_tolerance_ids[] = $moisture_tolerance_map[$name];
			}
			$plant->moistureTolerances()->sync($moisture_tolerance_ids);


			$this->debug("Processing $plant_name's habit.");
			if(!empty($data[HABIT])) {
				$habit_symbols = array_map('trim', explode(' ', $data[HABIT]));
				$habit_ids = array();
				foreach($habit_symbols as $symbol) {
					$habit = Habit::where('symbol', $symbol)->first();
					if ( ! $habit) {
						$this->fatalError('Failed to find habit "' . $symbol . '"');
					}
					$habit_ids[] = $habit->id;
				}
				$plant->habits()->sync($habit_ids);
			}

			$this->debug("Processing $plant_name's root pattern.");
			if(!empty($data[ROOT_PATTERN])) {
				$root_pattern_symbols = array_map('trim', explode(';', $data[ROOT_PATTERN]));
				$root_pattern_ids = array();
				foreach($root_pattern_symbols as $symbol) {
					$root_pattern = RootPattern::where('symbol', $symbol)->first();
					if ( ! $root_pattern) {
						$this->fatalError('Failed to find root pattern "' . $symbol . '"');
					}
					$root_pattern_ids[] = $root_pattern->id;
				}
				$plant->rootPatterns()->sync($root_pattern_ids);
			}

			$this->debug("Processing $plant_name's habitats.");
			if(!empty($data[HABITATS])) {
				$habitats = array_map('trim', explode(';', $data[HABITATS]));
				$habitat_ids = array();
                foreach($habitats as $name) {
                    if (strlen($name) == 0) {
                        continue;
                    }
					$habitat = Habitat::where('name', $name)->first();
					if ( ! $habitat) {
						$this->fatalError('Failed to find habitat "' . $name . '"');
					}
					$habitat_ids[] = $habitat->id;
				}
				$plant->habitats()->sync($habitat_ids);
			}

			$this->debug("Processing $plant_name's harvests.");
			if(!empty($data[USES])) {
				$harvest_strings = array_map('trim', explode(';', $data[USES]));
				$plant_harvests = array();
				foreach($harvest_strings as $harvest_string) {
					$this->debug('Processing harvest "' . $harvest_string . '"');

					preg_match('/(\w+\s*\w*)\((\w+)\)/', $harvest_string, $matches);
					$name = $matches[1];
					$rating = $matches[2];

					$harvest = Harvest::where('name', $name)->first();
					if ( ! $harvest) {
						$this->fatalError('Failed to find a harvest for "' . $name . '"');
					}
					$plant_harvests[$harvest->id] = array('rating'=>$rating);
				}
				$plant->harvests()->sync($plant_harvests);
			}

			$this->debug("Processing $plant_name's roles.");
			if(!empty($data[FUNCTIONS])) {
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
								$this->fatalError('Failed to find role for "' . $role_string . '"');
							}
							$role_ids[]  = $role->id;
						}
					} else {
						$role = Role::where('name', $role_names[$role_string])->first();
						if ( ! $role) {
							$this->fatalError('Failed to find role for "' . $role_string . '"');
						}
						$role_ids[] = $role->id;
					}
				}
				$plant->roles()->sync($role_ids);
			}

			$this->debug("Processing $plant_name's drawbacks [{$data[DRAWBACKS]}].");
			if( ! empty($data[DRAWBACKS])) {
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
						$this->fatalError('Failed to find drawback for "' . $symbol. '"');
					}
					$drawback_ids[] = $drawback->id;
				}
				$plant->drawbacks()->sync($drawback_ids);
			}
			$counter++;
		}
		$this->debug('Processing complete.');
	}

	/**
	 * Parse the data from the csv into a Plant model.  Check the database
	 * for an existing plant model and return FALSE if found.
	 *
	 * @param Plant $plant The model to parse into.
	 * @param array $data	The data from the csv file for parsing.
	 *
	 * @return boolean	TRUE if successfully parsed, FALSE if plant already exists.
	 */
	protected function parsePlant(Plant $plant, array $data)
	{
		$plant->genus = $data[GENUS];
		$plant->species = $data[SPECIES];
		$plant->family = $data[FAMILY];

		$existing = Plant::where('genus', $plant->genus)->where('species', $plant->species)->first();
		if ( $existing !== NULL ) {
			return FALSE;
		}

        // ---------------------------- Soil pH -------------------------------
        // Format: [0-2]:[0-2]:[0-2]:[0-2]
        // Examples: 0:0:2:2, 0:1:2:1, 1:2:2:1, 0:0:0:2
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
		for($i = 0; $i < 4; $i++) {
			if(isset($minimum_ph_values[$i][$phs[$i]])) {
				$plant->minimum_PH = $minimum_ph_values[$i][$phs[$i]];
				break;
			}
		}
		for($i = 3; $i > 0; $i--) {
			if(isset($maximum_ph_values[$i][$phs[$i]])) {
				$plant->maximum_PH = $maximum_ph_values[$i][$phs[$i]];
				break;
			}
        }

        // ---------------------------- Zone ----------------------------------
        // Formats: [Minimum Zone] - [Maximum Zone] OR [Minimum Zone]
        // Examples: 3 - 7 OR 3b
        if (strpos($data[ZONE], '-') !== FALSE) {
            list($minimum_zone, $maximum_zone) = array_map('trim', explode('-', $data[ZONE]));
        } else {
            $minimum_zone = $data[ZONE]; 
            $maximum_zone = null;
        }
        $plant->minimum_zone = $minimum_zone;
        $plant->maximum_zone = $maximum_zone;
        

        // ---------------------------- Form ----------------------------------
        // Format: [size] [form]
        // Examples: m Shrub, l Tree, s-m Herb
		$forms = array_map('trim', explode(' ', $data[FORM]));
		$plant->form = strtolower($forms[1]); // We're ignoring size.  You can get it from the height / width.

        // ---------------------------- Plant Height --------------------------
        // Format:  [Minimum Height]' - [Maximum Height]' OR [Maximum Height]' 
        //      OR [Minimum Height]" - [Maximum Height]" OR [Maximum Height]"
        // Examples: 20' - 100', 7', 24", 12" - 24"
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
		$plant->minimum_height = $minimum_height;

		if (strpos($maximum_height, "'") !== FALSE)  {
			$maximum_height = str_replace('\'', '', $maximum_height);
		} else if(strpos($maximum_height, '"') !== FALSE) {
			$maximum_height = ((float)str_replace('"', '', $maximum_height))/12;
		}
		$plant->maximum_height = $maximum_height;


        // ---------------------------- Plant Width ---------------------------
        // Format:  [Minimum Width]' - [Maximum Width]' OR [Maximum Width]' 
        //      OR [Minimum Width]" - [Maximum Width]" OR [Maximum Width]"
        // Examples: 20' - 100', 7', 24", 12" - 24"
		if (strpos($data[WIDTH], '-') !== FALSE) {
			list($minimum_width, $maximum_width) = array_map('trim', explode('-', $data[WIDTH]));
		} else {
            $maximum_width = $data[WIDTH];
            $minimum_width = null; // If we've only got one value, then it's the maximum.
		}

        if ($minimum_width !== null && strpos($minimum_width, "'") !== FALSE) {
            // Minimum Width given in feet.  Just parse out the unit.
			$minimum_width = str_replace('\'', '', $minimum_width);
        } else if ($minimum_width !== null && strpos($minimum_width, '"') !== FALSE) {
            // Minimum Width given in inches.  Parse out the unit and convert to feet.
			$minimum_width = ((float)str_replace('"', '', $minimum_width))/12;
		}
		$plant->minimum_width = $minimum_width;

		if (strpos($maximum_width, "'") !== FALSE) {
            // Maximum Width given in feet.  Just parse out the unit.
            $maximum_width = str_replace('\'', '', $maximum_width);
		} else if (strpos($maximum_width, '"') !== FALSE) { 
            // Maximum Width given in inches.  Parse out the unit and convert to feet.
			$maximum_width = ((float)str_replace('"', '', $maximum_width))/12;
		}
		$plant->maximum_width = $maximum_width;

        // ---------------------------- Growth Rate ---------------------------
        // Format: [Growth Rate]
        // Examples: F, M, S
        $plant->growth_rate = strtolower($data[GROWTH_RATE]);

        // ---------------------------- Native Region -------------------------
        // Format: [Native Region]
        // Examples: ENA, EURA, ASIA
		$plant->native_region = $data[NATIVE_REGION];
		return TRUE;
	}

	/**
	 * Print a Debug Message
	 *
	 * @param	string $message The message to print.
	 *
	 * @return void
	 */
	protected function debug($message)
	{
		$now = new DateTime();
		echo $now->format("Y-m-d\tH:i:sO") . ':: ' . $message . "\n";
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
