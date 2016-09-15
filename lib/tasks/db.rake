namespace :db do
  desc "Load data into the database from a CSV file"
  task :load_data_from_csv, [:filename] => :environment do |task, args|
    csv_parsing_service = PlantCsvParsingService.new(:debug)
    csv_parsing_service.parseCsvFile(args.filename)
  end

end
