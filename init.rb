require 'redmine'

require 'drafts_issue_hook'
require 'drafts_wiki_hook'
require 'drafts_news_hook'

config.to_prepare do
  require_dependency 'drafts_issue_patch'
  require_dependency 'drafts_issues_patch'
  require_dependency 'drafts_wiki_patch'
  require_dependency 'drafts_wiki_controller_patch'
  require_dependency 'drafts_news_patch'
  require_dependency 'drafts_news_controller_patch'
end

Redmine::Plugin.register :redmine_drafts do
  name 'Redmine Drafts plugin'
  description 'This plugin avoids losing data when editing issues by saving it regularly as a draft'
  version '0.1.1'
  url 'http://github.com/jbbarth/redmine_drafts'
  author 'Jean-Baptiste BARTH'
  author_url 'mailto:jeanbaptiste.barth@gmail.com'
end
