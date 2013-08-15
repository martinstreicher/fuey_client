module Fuey
  module ModelInitializer
    def initialize(params={})
      params.each do |attr, value|
        self.send("#{attr}=", value)
      end if params
    end
  end
end
