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
#  When 'I fill first name field with {factory} value' do |name|
#     ...
#  end
ParameterType(
  name: 'factory',
  regexp: /(?:factory|FACTORY)_([A-Za-z_]+)(\d*)(?:\[\:(.+)\])?/,
  transformer: lambda do |_, factory, num, property|
    res = FactoryBot.given_by_number(factory.downcase, num)
    res = res.send(property) if property
    res
  end
)
