require 'app'
require 'models'

module MrDashboard

  def self.settings
    @settings ||=  begin
                     defaults = {
                       'speed' => ENV['SPEED'] || 15000,
                       'title' => ENV['TITLE'] || 'Mr. Dashboard',
                       'github_org' => ENV['GITHUB_ORG'] || nil,
                       'sites' => ENV['SITES'] || ['http://www.sinatrarb.com', 'http://news.ycombinator.com']
                     }
                     config_file = Pathname.new(File.dirname(__FILE__) + "/config.yml")
                     defaults.merge(YAML.load_file(config_file.to_s)) if config_file.exist?
                     defaults['sites'] = defaults['sites'].split(',') unless defaults['sites'].is_a?(Array)

                     defaults
                   end
  end

  def self.belongs_to_github_organization(user)
    org = MrDashboard.settings['github_org']
    return true if org.nil? || org == ""

    begin
      RestClient.log = STDOUT
      response = RestClient.get("https://api.github.com/orgs/#{org}/members/#{user[:nickname]}", {"Authorization" => "token #{user[:token]}"})
      if response.code == 204
        true
      else
        false
      end
    rescue => e
      false
    end
  end

  def self.display
    { sites: [], pages: [] }
  end

end
