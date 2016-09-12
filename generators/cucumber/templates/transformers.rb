#############################################################
#                      TRANSFORMERS                         #
#############################################################

# Revives factory or factory property from step to real value
# @note any factory is building once per scenario for the same number.
#  if number is ommited, then it is assigned to 0 number.
#  Built factories are stored in Howitzer::Cache and cleared after each
#  scenario automatically
# @example
#  'When I fill first name field with FACTORY_USER1[:first_name] value'
#  #=> build(:user).first_name
Transform /FACTORY_([a-z_]+)(\d*)(?:\[\:(.+)\])?/i do |factory, num, property|
  res = FactoryGirl.given_by_number(factory.downcase, num)
  res = res.send(property) if property
  res
end

# Revives factories or factory properties from table to real values
# @example
#  When I sign up with following data:
#   | name                 | email                 |
#   | FACTORY_USER1[:name] | FACTORY_USER1[:email] |
#  #=> build(:user).name and build(:user).email
Transform /^table:.*$/ do |table|
  raw = table.raw.map do |array|
    array.map do |el|
      data = /FACTORY_(?<factory>[a-z_]+)(?<num>\d*)(?:\[\:(?<property>.+)\])?/i.match(el)
      next(el) unless data
      res = FactoryGirl.given_by_number(data[:factory].downcase, data[:num])
      next(res) if data[:property].blank?
      res.send(data[:property])
    end
  end
  location = Cucumber::Core::Ast::Location.of_caller
  ast_table = Cucumber::Core::Ast::DataTable.new(raw, location)
  Cucumber::MultilineArgument::DataTable.new(ast_table)
end
