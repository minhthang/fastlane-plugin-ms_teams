require 'fastlane/action'
require_relative '../helper/ms_teams_helper'

module Fastlane
  module Actions
    class MsTeamsAction < Action
      def self.run(params)
        require 'net/http'
        require 'uri'
        #https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/connectors-using#example-connector-message
        payload = {
          "@type" => "MessageCard",
          "@context" => "http://schema.org/extensions",
          "themeColor" => params[:theme_color],
          "title" => params[:title],
          "summary" => params[:title],
          "sections" => params[:sections]
        }

        if params[:potential_action]
          payload["potentialAction"] = params[:potential_action]
        end

        json_headers = { 'Content-Type' => 'application/json' }
        uri = URI.parse(params[:teams_url])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        response = http.post(uri.path, payload.to_json, json_headers)

        check_response_code(response)
      end

      def self.check_response_code(response)
        if response.code.to_i == 200 && response.body.to_i == 1
          true
        else
          UI.user_error!("An error occurred: #{response.body}")
        end
      end

      def self.description
        "Send a message to your Microsoft Teams channel via the webhook connector"
      end

      def self.authors
        ["Thang Nguyen"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Send a message to your Microsoft Teams channel"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :title,
                                       env_name: "MS_TEAMS_TITLE",
                                       description: "The title that should be displayed on Teams"),
          FastlaneCore::ConfigItem.new(key: :sections,
                                       type: Array,
                                       env_name: "MS_TEAMS_SECTIONS",
                                       description: "The section that should be displayed on Teams"),
          FastlaneCore::ConfigItem.new(key: :potential_action,
                                       type: Array,
                                       env_name: "MS_TEAMS_ACTION",
                                       description: "Optional Potential Action"),
          FastlaneCore::ConfigItem.new(key: :teams_url,
                                       env_name: "MS_TEAMS_URL",
                                       sensitive: true,
                                       description: "Create an Incoming WebHook for your Teams channel",
                                       verify_block: proc do |value|
                                         UI.user_error!("Invalid URL, must start with https://") unless value.start_with? "https://"
                                       end),
          FastlaneCore::ConfigItem.new(key: :theme_color,
                                       env_name: "FL_TEAMS_THEME_COLOR",
                                       description: "Theme color of the message card",
                                       default_value: "0078D7")
        ]
      end

      def self.example_code
        [
          'ms_teams(
             title: "Title",
             sections: [{
                "activityTitle": "TEST",
                "activitySubtitle": "Version: 1.0",
                "activityImage": "https://...icon.png",
                "facts": [{
                 "name": "Change logs:",
                 "value": "- function 1 \t - function 2"
                }],
                "markdown": true
             }],
             potential_action: [
               {
                "@type": "OpenUri",
                "name": "Download",
                "targets": [{
                    "os": "default",
                    "uri": "https://app.download"
                }]
              }
             ],
             theme_color: "FFFFFF",
             teams_url: https://outlook.office.com/webhook/...
          )'
        ]
      end

      def self.category
        :notifications
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
