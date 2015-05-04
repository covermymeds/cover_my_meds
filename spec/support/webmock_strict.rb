module WebMockStrict
  # Monkey patching of WebMock's query parser is required to detect a 
  # problem with URI creation
  #
  # The code below replaces WebMock's query parser with the one from the
  # URI standard library
  #
  def self.start
    class << WebMock::Util::QueryMapper
      alias_method :old_query_to_values, :query_to_values

      def query_to_values(query, options = {})
        Hash[Object::URI.decode_www_form(query)]
      end
    end
  end

  # Here we restore WebMock's built in query parser
  def self.stop
    class << WebMock::Util::QueryMapper
      alias_method :query_to_values, :old_query_to_values
    end
  end
end
