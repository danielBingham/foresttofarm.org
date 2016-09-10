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

    it "should ignore malformed light tolerance values and return an array of LightTolerance objects from any correctly formatted values" do
      fixtures = [
        {'test'=>'sun;Partial', 'result'=>[@partial]},
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

    it "should handle bad moisture tolerance data correctly" do
      fixtures = [
        {'test'=>'xeric;Mesic', 'result'=>[@mesic]},
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
    it "should handle good pH data correctly"

    it "should handle bad pH data correctly"
  end

  context "parseZone" do
    it "should handle good zone data correctly"

    it "should handle bad zone data correctly"
  end

  context "parseForm" do
    it "should handle good form data correctly"

    it "should handle bad form data correctly"
  end

  context "parseHeight" do
    it "should handle good height data correctly"

    it "should handle bad height data correctly"
  end

end
