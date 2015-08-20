# For more information about configuration please refer to https://github.com/remiprev/her
class User
  include Her::Model
  include_root_in_json true
  parse_root_in_json true, format: :active_model_serializers
end