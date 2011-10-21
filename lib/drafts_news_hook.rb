class DraftsNewsHook < Redmine::Hook::ViewListener
  
  # Add our own elements to News views
  #

  def view_layouts_base_content(context={})
    if User.current.logged? && context[:controller].is_a?(NewsController)
      template = context[:controller].instance_variable_get("@template")
      template.render :partial => "drafts/news_form", :locals => {:context => context}
    end
  end
  
end
