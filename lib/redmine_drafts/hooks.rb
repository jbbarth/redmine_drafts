module RedmineDrafts
  class Hooks < Redmine::Hook::ViewListener
    #adds our js on each page
    def view_layouts_base_html_head(context)
      javascript_include_tag('jquery.bind-with-delay.js', :plugin => 'redmine_drafts')
    end
  end
end
