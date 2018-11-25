require 'redmine'

Rails.logger.info 'Better project overview'

plugin = Redmine::Plugin.register :redmine_better_overview do
  name 'Redmine Better Project Overview plugin'
  author 'Massimo Rossello'
  description 'Displays a better project overview'
  version '1.0.0'
  url 'https://github.com/maxrossello/redmine_better_overview.git'
  author_url 'https://github.com/maxrossello'
  requires_redmine :version_or_higher => '2.6.0'
end

Rails.configuration.to_prepare do
    plugin.requires_redmine_plugin :redmine_base_deface, '0.0.1'
end

ProjectsController.send(:helper, :reports)
