module Howitzer
  module Utils
    # This module adds transformers methods for cucumber step arguments
    module Transformers
      # Transforms factories or factory properties from table to real values
      # @example
      #  When I sign up with following data:
      #   | name                 | email                 |
      #   | FACTORY_USER1[:name] | FACTORY_USER1[:email] |
      #  #=> build(:user).name and build(:user).email
      # In step:
      # Given 'example step' do |table|
      #   table = transform_table(table)
      #     ...
      # end

      def transform_table(table)
        raw = process_table(table)
        location = Cucumber::Core::Ast::Location.of_caller
        ast_table = Cucumber::Core::Ast::DataTable.new(raw, location)
        Cucumber::MultilineArgument::DataTable.new(ast_table)
      end

      private

      def process_table(table)
        table.raw.map do |array|
          array.map do |el|
            data = /FACTORY_(?<factory>[a-z_]+)(?<num>\d*)(?:\[\:(?<property>.+)\])?/i.match(el)
            next(el) unless data
            res = FactoryGirl.given_by_number(data[:factory].downcase, data[:num])
            next(res) if data[:property].blank?
            res.send(data[:property])
          end
        end
      end
    end
  end
end
