module Fuey
  module Inspections
    module Support
      class SAP
        def initialize(config)
          @config = config
        end

        def ping
          gem 'sapnwrfc'
          SAPNW::Base.config =  @config
          conn = SAPNW::Base.rfc_connect
          attrib = conn.connection_attributes
          fld = conn.discover("RFC_PING")
          fl = fld.new_function_call
          fl.invoke
          true
        rescue Gem::LoadError
          Log.write %(Could not ping SAP instance. The sapnwrfc gem is not installed)
          false
        rescue Exception => caught
          Log.write %(RFC Ping for #{config['ashost']} failed due to #{caught})
          return false
        ensure
          conn.close unless conn.nil?
        end
      end
    end
  end
end
