#############################################################
#                      TRANSFORMERS                         #
#############################################################

Transform /FACTORY_(\w+)(\d*)(?:\[\:(.+)\])?/ do |factory, num, property|
  res = FactoryGirl.given_factory_by_number(factory.downcase, num)
  res = res.send(property) if property
  res
end

Transform /^table:.*$/ do |table|
  raw = table.raw.map do |array|
    array.map do |el|
      res = el

      data = /FACTORY_(?<factory>\w+)(?<num>\d*)(?:\[\:(?<property>.+)\])?/.match(el)
      if data
        res = FactoryGirl.given_factory_by_number(data[:factory].downcase, data[:num])
        res = res.send(data[:property]) if data[:property]
      end

      res
    end
  end
  location = Cucumber::Core::Ast::Location.of_caller
  ast_table = Cucumber::Core::Ast::DataTable.new(raw, location)
  Cucumber::MultilineArgument::DataTable.new(ast_table)
end
