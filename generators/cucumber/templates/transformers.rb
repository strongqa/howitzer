#############################################################
#                      TRANSFORMERS                         #
#############################################################
Transform /UNIQ_USER(\d*)(?:\[\:(.+)\])?/ do |num, property|
  res = Gen::given_user_by_number(num)
  res = res.send(property) if property
  res
end

Transform /^table:.*$/ do |table|
  raw = table.raw.map do |array|
    array.map do |el|
      res = el

      # UNIQ_USER
      data = /UNIQ_USER(?<num>\d*)(?:\[\:(?<property>.+)\])?/.match(el)
      if data
        res = Gen::given_user_by_number(data[:num])
        if data[:property]
          res = res.send(data[:property])
        end
      end

      res
    end
  end
  location = Cucumber::Core::Ast::Location.of_caller
  ast_table = Cucumber::Core::Ast::DataTable.new(raw, location)
  Cucumber::MultilineArgument::DataTable.new(ast_table)
end