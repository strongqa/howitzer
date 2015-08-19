class User
  include Her::Model
  include_root_in_json true
  parse_root_in_json true, format: :active_model_serializers
end