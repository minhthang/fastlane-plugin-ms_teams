require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class MsTeamsHelper
      # class methods that you define here become available in your action
      # as `Helper::MsTeamsHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the ms_teams plugin helper!")
      end
    end
  end
end
