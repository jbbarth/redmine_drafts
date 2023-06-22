require 'redmine'

require 'redmine_drafts/hooks'

ActiveSupport::Reloader.to_prepare do
  require_dependency 'redmine_drafts/issue_patch'
  require_dependency 'redmine_drafts/user_patch'
  require_dependency 'redmine_drafts/issues_controller_patch'
end

Redmine::Plugin.register :redmine_drafts do
  name 'Redmine Drafts plugin'
  description 'This plugin avoids losing data when editing issues by saving it regularly as a draft'
  version '4.0.0'
  url 'https://github.com/jbbarth/redmine_drafts'
  author 'Jean-Baptiste BARTH'
  author_url 'mailto:jeanbaptiste.barth@gmail.com'
  requires_redmine :version_or_higher => '2.1.0'
  requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.4' if Rails.env.test?
  requires_redmine_plugin :redmine_base_deface, :version_or_higher => '0.0.1'
end
