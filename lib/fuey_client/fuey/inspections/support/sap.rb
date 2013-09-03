module Fuey
  module Inspections
    module Support
      class SAP
        def initialize(config)
          @config = config
        end

        def ping
          require 'sapnwrfc'
          ::SAPNW::Base.config =  @config
          conn = ::SAPNW::Base.rfc_connect
          attrib = conn.connection_attributes
          fld = conn.discover("RFC_PING")
          fl = fld.new_function_call
          response = fl.invoke
          [true, response]
        rescue Gem::LoadError
          return [false, %(Could not RFC Ping because the sapnwrfc gem is not available)]
        rescue Exception => caught
          return [false, caught.error] if caught.respond_to?(:error) #SAP errors
          [false, caught.inspect]
        ensure
          conn.close unless conn.nil?
        end
      end
    end
  end
end
