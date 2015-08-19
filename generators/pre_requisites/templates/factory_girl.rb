FactoryGirl.define do
  sequence :serial do
    a = [('a'..'z').to_a, (0..9).to_a].flatten.shuffle
    "#{Time.now.utc.strftime("%j%H%M%S")}#{a[0..4].join}"
  end
end

FactoryGirl.definition_file_paths = [File.join(File.dirname(__FILE__), "pre_requisites/factories")]
FactoryGirl.find_definitions