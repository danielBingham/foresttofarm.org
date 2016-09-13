require 'rails_helper'

describe PlantCsvParsingService do

  context "parseLightTolerance" do
    before(:context) do
      @sun = LightTolerance.where('name=?', 'Full Sun').first
      @partial = LightTolerance.where('name=?', 'Partial Shade').first
      @shade = LightTolerance.where('name=?', 'Full Shade').first
    end

    it "should parse light tolerance data formatted as semi-colon separated values from among 'Sun', 'Partial', or 'Shade' and return an array of matching LightTolerance models" do 
      fixtures = [
        {'test'=>'Sun;Partial', 'result'=>[@sun,@partial]},
        {'test'=> 'Sun;Shade', 'result'=>[@sun,@shade]},
        {'test'=>'Sun;Partial;Shade', 'result'=>[@sun,@partial,@shade]},
        {'test'=>'Partial;Shade', 'result'=>[@partial,@shade]},
        {'test'=>'Shade;Partial;Sun', 'result'=>[@shade,@partial,@sun]},
        {'test'=>'','result'=>[]}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseLightTolerances(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should be case insensitive" do
      fixtures = [
        {'test'=>'sun;Shade', 'result'=>[@sun,@shade]},
        {'test'=>'Sun;shade', 'result'=>[@sun,@shade]},
        {'test'=>'sun;partial;Shade', 'result'=>[@sun,@partial,@shade]}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseLightTolerances(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should ignore duplicated light tolerance values" do
      fixtures = [
        {'test'=>'Sun;Sun;Shade', 'result'=>[@sun,@shade]},
        {'test'=>'Sun;Sun;Shade;Shade', 'result'=>[@sun,@shade]},
        {'test'=>'Sun;Partial;Partial;Shade', 'result'=>[@sun,@partial,@shade]}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseLightTolerances(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should ignore invalid values" do
      fixtures = [
        {'test'=>'Suun;Shade', 'result'=>[@shade]},
        {'test'=>'Sun,Shade', 'result'=>[]},
        {'test'=>'Sun;Partial;Shade;Cloudy', 'result'=>[@sun,@partial,@shade]},
        {'test'=>'Sun;Partial;', 'result'=>[@sun,@partial]},
        {'test'=>'Sun;;:;Partial;', 'result'=>[@sun,@partial]}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseLightTolerances(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end
  end

  context "parseMoistureTolerance" do
    before(:context) do
      @xeric = MoistureTolerance.where('name=?', 'Xeric').first
      @mesic = MoistureTolerance.where('name=?', 'Mesic').first
      @hydric = MoistureTolerance.where('name=?', 'Hydric').first
    end

    it "should parse semi-colon separated values from among 'Xeric', 'Mesic', 'Hydric' and return an array of MoistureTolerance models" do
        fixtures = [
            {'test'=>'Xeric;Mesic', 'result'=>[@xeric,@mesic]},
            {'test'=>'Xeric', 'result'=>[@xeric]},
            {'test'=>'Mesic;Hydric', 'result'=>[@mesic,@hydric]},
            {'test'=>'Hydric;Mesic;Xeric', 'result'=>[@hydric,@mesic,@xeric]},
            {'test'=>'Xeric;Mesic;Hydric', 'result'=>[@xeric,@mesic,@hydric]},
            {'test'=>'Xeric; Mesic; Hydric', 'result'=>[@xeric,@mesic,@hydric]},
            {'test'=>'', 'result'=>[]}
        ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseMoistureTolerances(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should be case insensitive" do
        fixtures = [
            {'test'=>'Xeric;mesic', 'result'=>[@xeric,@mesic]},
            {'test'=>'xeric', 'result'=>[@xeric]},
            {'test'=>'hydric;mesic;Xeric', 'result'=>[@hydric,@mesic,@xeric]},
            {'test'=>'xeric;Mesic;hydric', 'result'=>[@xeric,@mesic,@hydric]},
        ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseMoistureTolerances(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should ignore duplicated values" do
        fixtures = [
            {'test'=>'Xeric;Xeric;Mesic', 'result'=>[@xeric,@mesic]},
            {'test'=>'Xeric;Xeric', 'result'=>[@xeric]},
            {'test'=>'hydric;Hydric;mesic;Mesic;Xeric', 'result'=>[@hydric,@mesic,@xeric]},
            {'test'=>'xeric;Mesic;Mesic;hydric', 'result'=>[@xeric,@mesic,@hydric]},
        ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseMoistureTolerances(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should ignore invalid values" do
      fixtures = [
        {'test'=>'Xeric;Partial', 'result'=>[@xeric]},
        {'test'=>'Xeeric;Mesic', 'result'=>[@mesic]},
        {'test'=>'Xeric;Xeric;Mesic', 'result'=>[@xeric,@mesic]},
        {'test'=>'Xeric,Mesic;Hydric', 'result'=>[@hydric]},
        {'test'=>'Xeric;Mesic;Watery', 'result'=>[@xeric,@mesic]},
        {'test'=>'Xeric;Mesic;', 'result'=>[@xeric,@mesic]}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseMoistureTolerances(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end
  end

  context "parsePh" do

    it "should parse pH data presented as a series of four colon separated integers from 0-2 with out spaces representing a range of pH tolerances and returning a hash of minimum and maximum pH" do
      fixtures = [
        {'test'=>'0:0:2:0', 'result'=>{minimum: 6.1, maximum: 7.0}},
        {'test'=>'2:2:2:2', 'result'=>{minimum: 3.5, maximum: 8.5}},
        {'test'=>'1:2:2:1', 'result'=>{minimum: 4.0, maximum: 7.8}},
        {'test'=>'0:1:2:1', 'result'=>{minimum: 5.35, maximum: 7.8}},
        {'test'=>'1:2:1:0', 'result'=>{minimum: 4.0, maximum: 6.8}},
        {'test'=>'1:1:0:0', 'result'=>{minimum: 4.0, maximum: 5.8}},
        {'test'=>'0:0:1:1', 'result'=>{minimum: 6.35, maximum: 7.8}},
        {'test'=>'1:0:0:0', 'result'=>{minimum: 4.0, maximum: 4.5}},
        {'test'=>'0:1:0:0', 'result'=>{minimum: 5.35, maximum: 5.8}},
        {'test'=>'0:0:1:0', 'result'=>{minimum: 6.35, maximum: 6.8}},
        {'test'=>'0:0:0:1', 'result'=>{minimum: 7.5, maximum: 7.8}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parsePh(fixture['test'])
        expect(result).to eql(fixture['result'])
      end


    end

    it "should treat invalid integer values as 0 and return a range generated from any valid values found" do
      fixtures = [
        {'test'=>'0:3:2:1', 'result'=>{minimum: 6.1, maximum: 7.8}},
        {'test'=>'0:0:0:0', 'result'=>{minimum: 6.1, maximum: 7.0}},
        {'test'=>'-1:0:2:1', 'result'=>{minimum: 6.1, maximum: 7.8}},
        {'test'=>'-1:22:2:1', 'result'=>{minimum: 6.1, maximum: 7.8}}

      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parsePh(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end


    it "should ignore any non-integer values and return a range generated from any valid values found" do
      fixtures = [
        {'test'=>'and:1:2:1', 'result'=>{minimum: 5.35, maximum: 7.8}},
        {'test'=>'0:now:2:1', 'result'=>{minimum: 6.1, maximum: 7.8}},
        {'test'=>'0:2:2:for', 'result'=>{minimum: 5.1, maximum: 7.0}},
        {'test'=>'something:0:2:1', 'result'=>{minimum: 6.1, maximum: 7.8}},
        {'test'=>'completely:0:2:different', 'result'=>{minimum: 6.1, maximum: 7.0}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parsePh(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should return a default range when there are more or less than 4 colon separated values" do
      fixtures = [
        {'test'=>'0:3:2:1:0', 'result'=>{minimum: 6.1, maximum: 7.0}},
        {'test'=>'0:22:0', 'result'=>{minimum: 6.1, maximum: 7.0}},
        {'test'=>'0:0:', 'result'=>{minimum: 6.1, maximum: 7.0}},
        {'test'=>'0:0', 'result'=>{minimum: 6.1, maximum: 7.0}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parsePh(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should return a default range when no valid values are found" do
      fixtures = [
        {'test'=>'0:0:0:0', 'result'=>{minimum: 6.1, maximum: 7.0}},
        {'test'=>'0:22:0:0', 'result'=>{minimum: 6.1, maximum: 7.0}},
        {'test'=>'-1:-3:3:4', 'result'=>{minimum: 6.1, maximum: 7.0}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parsePh(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end
  end

  context "parseZone" do
    it "should parse valid USDA zones from range string and return a hash with a minimum and maximum zone" do
      fixtures = [
        {'test'=>'3 - 7', 'result'=>{minimum: '3', maximum: '7'}},
        {'test'=>'7-10', 'result'=>{minimum: '7', maximum: '10'}},
        {'test'=>'4a-10', 'result'=>{minimum: '4a', maximum: '10'}},
        {'test'=>'4-7b', 'result'=>{minimum: '4', maximum: '7b'}},
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseZone(fixture['test'])
        expect(result).to eql(fixture['result'])
      end

    end


    it "should parse a valid USDA zone from a single zone string and return a hash with the parse zone set to the minimum and the maximum set to nil" do
      fixtures = [
        {'test'=>'3b', 'result'=>{minimum: '3b', maximum: nil}},
        {'test'=>'2', 'result'=>{minimum: '2', maximum: nil}},
        {'test'=>'6a', 'result'=>{minimum: '6a', maximum: nil}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseZone(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should ignore invalid zone values and return any correctly parsed values" do
      fixtures = [
        {'test'=>'3-20', 'result'=>{minimum: '3', maximum:  nil}},
        {'test'=>'3c-6a',  'result'=>{minimum: nil, maximum:  '6a'}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseZone(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should return a hash of nil values when no valid values are found" do
      fixtures = [
        {'test'=>'3_7', 'result'=>{minimum: nil, maximum:  nil}},
        {'test'=>'20', 'result'=>{minimum: nil, maximum:  nil}},
        {'test'=>'3c',  'result'=>{minimum: nil, maximum:  nil}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseZone(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end
  end

  context "parseForm" do
    it "should parse string formatted as '[size] [form]' and return the plant's from as a string" do
      fixtures = [
        {'test'=>'m Shrub', 'result'=>'shrub'},
        {'test'=>'l Tree', 'result'=>'tree'},
        {'test'=>'s Herb', 'result'=>'herb'},
        {'test'=>'l Vine', 'result'=>'vine'},
        {'test'=>'m-l Tree', 'result'=>'tree'},
        {'test'=>'s-m Herb', 'result'=>'herb'},
        {'test'=>'m Shrub', 'result'=>'shrub'},
        {'test'=>'m-l Tree', 'result'=>'tree'}
      ] 

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseForm(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should be case insensitive" do
      fixtures = [
        {'test'=>'m shrub', 'result'=>'shrub'},
        {'test'=>'l tree', 'result'=>'tree'},
        {'test'=>'s herb', 'result'=>'herb'},
        {'test'=>'l vine', 'result'=>'vine'},
        {'test'=>'m-l Tree', 'result'=>'tree'},
        {'test'=>'s-m Herb', 'result'=>'herb'},
        {'test'=>'m shrub', 'result'=>'shrub'},
        {'test'=>'m-l Vine', 'result'=>'vine'}
      ] 

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseForm(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should ignore the size value" do
      fixtures = [
        {'test'=>'This shrub', 'result'=>'shrub'},
        {'test'=>'can tree', 'result'=>'tree'},
        {'test'=>'be herb', 'result'=>'herb'},
        {'test'=>'42 vine', 'result'=>'vine'},
        {'test'=>'for Tree', 'result'=>'tree'},
        {'test'=>'all Herb', 'result'=>'herb'},
        {'test'=>'we shrub', 'result'=>'shrub'},
        {'test'=>'care Vine', 'result'=>'vine'}
      ] 

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseForm(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should return 'nil' for invalid values" do
      fixtures = [
        {'test'=>'mShrub', 'result'=>nil},
        {'test'=>'ltree', 'result'=>nil},
        {'test'=>'s l tree', 'result'=>nil}
      ] 

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseForm(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end
  end

  context "parseHeight" do
    it "should parse valid height data from range string formatted as [minimum]' - [maximum]' with units in either inches (\") or feet (') and return a hash with keys :minimum and :maximum in feet" do
      fixtures = [
        {'test'=>"20' - 100'", 'result'=>{minimum: 20.0, maximum: 100.0}},
        {'test'=>"1'-2'", 'result'=>{minimum: 1.0, maximum: 2.0}},
        {'test'=>'12"-24"', 'result'=>{minimum: 1.0, maximum: 2.0}},
        {'test'=>"15'-30'", 'result'=>{minimum: 15.0, maximum: 30.0}},
        {'test'=>'24" - 20\'', 'result'=>{minimum: 2.0, maximum: 20.0}},
        {'test'=>'12"-36"', 'result'=>{minimum: 1.0, maximum: 3.0}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseHeight(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should parse valid height data from a single value formatted as [height]' with units in either inches (\") or feet (') and return a hash with :minimum set to nil and :maximum with the value in feet" do
      fixtures = [
        {'test'=>"20'", 'result'=>{minimum: nil, maximum:  20.0}},
        {'test'=>'24"', 'result'=>{minimum: nil, maximum: 2.0}},
        {'test'=>'18"', 'result'=>{minimum: nil, maximum: 1.5}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseHeight(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should ignore non-integer values and return only valid values" do
      fixtures = [
        {'test'=>"one to twenty", 'result'=>{minimum: nil, maximum: nil}},
        {'test'=>'24" - ten', 'result'=>{minimum: 2.0, maximum: nil}},
        {'test'=>'one - 18"', 'result'=>{minimum: nil, maximum: 1.5}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseHeight(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should ignore invalidly formatted values and return a hash with nil values" do
      fixtures = [
        {'test'=>"one to twenty", 'result'=>{minimum: nil, maximum: nil}},
        {'test'=>'1-10 ', 'result'=>{minimum: nil, maximum: nil}},
        {'test'=>'2\'_18"', 'result'=>{minimum: nil, maximum: nil}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseHeight(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

  end

  context "parseWidth" do
    it "should parse valid width data from range string formatted as [minimum]' - [maximum]' with units in either inches (\") or feet (') and return a hash with keys :minimum and :maximum" do
      fixtures = [
        {'test'=>"20' - 100'", 'result'=>{minimum: 20.0, maximum: 100.0}},
        {'test'=>"1'-2'", 'result'=>{minimum: 1.0, maximum: 2.0}},
        {'test'=>'12"-24"', 'result'=>{minimum: 1.0, maximum: 2.0}},
        {'test'=>"15'-30'", 'result'=>{minimum: 15.0, maximum: 30.0}},
        {'test'=>'24" - 20\'', 'result'=>{minimum: 2.0, maximum: 20.0}},
        {'test'=>'12"-36"', 'result'=>{minimum: 1.0, maximum: 3.0}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseWidth(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should parse valid width data from a single value formatted as [height]' with units in either inches (\") or feet (') and return a hash with :minimum set to nil and :maximum set to the parsed value" do
      fixtures = [
        {'test'=>"20'", 'result'=>{minimum: nil, maximum:  20.0}},
        {'test'=>'24"', 'result'=>{minimum: nil, maximum: 2.0}},
        {'test'=>'18"', 'result'=>{minimum: nil, maximum: 1.5}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseWidth(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should ignore non-integer values and return only valid values" do
      fixtures = [
        {'test'=>"one to twenty", 'result'=>{minimum: nil, maximum: nil}},
        {'test'=>'24" - ten', 'result'=>{minimum: 2.0, maximum: nil}},
        {'test'=>'one - 18"', 'result'=>{minimum: nil, maximum: 1.5}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseWidth(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

    it "should ignore invalidly formatted values and return a hash with nil values" do
      fixtures = [
        {'test'=>"one to twenty", 'result'=>{minimum: nil, maximum: nil}},
        {'test'=>'1-10 ', 'result'=>{minimum: nil, maximum: nil}},
        {'test'=>'2\'_18"', 'result'=>{minimum: nil, maximum: nil}}
      ]

      plant_csv_parsing_service = PlantCsvParsingService.new
      fixtures.each do |fixture|
        result = plant_csv_parsing_service.parseWidth(fixture['test'])
        expect(result).to eql(fixture['result'])
      end
    end

  end

end
