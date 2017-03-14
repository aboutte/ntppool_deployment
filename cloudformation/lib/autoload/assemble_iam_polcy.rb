
Dir["#{File.dirname(File.expand_path($PROGRAM_NAME))}/iam_policies/*.rb"].each { |file| load_from_file(file) }
