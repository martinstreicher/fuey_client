require "fuey_client/fuey/log"
require "fuey_client/fuey/config"

module Fuey
  class Client
    def run
      Fuey::Log.write "Exited after inspecting nothing."
      0
    end
  end
end
