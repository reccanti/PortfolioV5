require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'CopyDownloader'
CLIENT_SECRETS_PATH = 'credentials/GoogleSheets/client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials', "sheets.googleapis.com-ruby-quickstart.yaml")
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

##
# A module with a class to load and interact with a google spreadsheet
#
module Spreadsheet 
  class Spreadsheet 

    ##
    # Ensure valid credentials, either by restoring from the saved credentials
    # files or intitiating an OAuth2 authorization. If authorization is required,
    # the user's default browser will be launched to approve the request.
    #
    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def self.authorize
      FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

      client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)

      if credentials.nil?
        url = authorizer.get_authorization_url(base_url: OOB_URI)
        puts "Open the following URL in the browser and enter the resulting code after authorization"
        puts url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: OOB_URI)
      end
      
      credentials
    end

    ##
    # Perform all the necessary steps for authenticating a user and
    # returning a Google Spreadsheet instance
    #
    # @return [Google::Apis::SheetsV4::BatchGetValuesResponse] The response object
    def self.getValues(id, sheetname, range)
      # Initialize the API
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = self.authorize

      # Get a spreadsheet from the service
      combinedRange = "#{sheetname}!#{range}"
      response = service.get_spreadsheet_values(id, combinedRange)
      response.values
    end   
  end
end

# puts 'Values: '
# puts 'No data found.' if response.values.empty?
# response.values.each do |row|
#   puts "#{row[0]}"
# end


