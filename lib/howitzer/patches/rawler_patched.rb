module Rawler
  class Base
    def record_response(code, link, from_url, redirection=nil)
      message = "#{code} - #{link}"

      if code.to_i >= 300
        message += " - Called from: #{from_url}"
      end

      message += " - Following redirection to: #{redirection}" if redirection
      log_fields = {code: code, link: link, message: message}

      code = code.to_i
      case code / 100
        when 1,2
          Rawler.output.info(message)
          add_xml_log_item(log_fields) if settings.add_rawler_xml_log
          add_html_log_item(log_fields) if settings.add_rawler_html_log
        when 3 then
          Rawler.output.warn(message)
          add_xml_log_item(log_fields) if settings.add_rawler_xml_log
          add_html_log_item(log_fields) if settings.add_rawler_html_log
        when 4,5 then
          Rawler.output.error(message)
          log_fields[:failed] = true
          add_xml_log_item(log_fields) if settings.add_rawler_xml_log
          add_html_log_item(log_fields) if settings.add_rawler_html_log
        else
          Rawler.output.error("Unknown code #{message}")
          log_fields[:failed] = true
          log_fields[:message] = "Unknown code #{message}"
          add_xml_log_item(log_fields) if settings.add_rawler_xml_log
          add_html_log_item(log_fields) if settings.add_rawler_html_log
      end
      @logfile.puts(message) if Rawler.log
    end

    def add_xml_log_item(fields)
      log_file_path = File.expand_path(settings.rawler_xml_log, "#{settings.log_dir}")

      doc = File.exists?(log_file_path) ? Nokogiri::XML::Document.parse(File.read log_file_path) : Nokogiri::XML::Document.new

      doc.encoding = 'UTF-8'

      if doc.root
        tests = doc.root > ("testcase")
        failures = doc.root > ("testcase failure")
        doc.root[:failures] = failures.to_a.size.to_s
        doc.root[:tests] = tests.to_a.size.to_s
        doc.root[:time] = "#{tests.to_a.size} sec."
      else
        root = doc.create_element('testsuite')
        root[:errors] = "0"
        root[:failures] = "0"
        root[:name] = "Check links"
        root[:skipped] = "0"
        root[:tests] = "0"
        root[:time] = "0 sec."
        doc.root = root
      end

      testcase = doc.create_element('testcase')
      testcase[:classname] = "Check links"
      testcase[:name] = "Check: link '#{fields[:link]}'"
      testcase[:time] = "1"

      if fields[:failed]
        failure = doc.create_element('failure', message: "Failed responce code: '#{fields[:code]}'", type:'failed')
        failure << doc.create_cdata("#{fields[:message]}")
        testcase << failure
      end

      testcase << doc.create_element('system-out')
      testcase << doc.create_element('system-err')
      doc.root << testcase

      File.open(log_file_path, 'w+') do |f|
        f.write(doc.serialize(:encoding => 'UTF-8', :save_with => Nokogiri::XML::Node::SaveOptions::FORMAT))
      end
    end

    def add_html_log_item(fields)
      #Todo: should be implemented
    end
  end
end