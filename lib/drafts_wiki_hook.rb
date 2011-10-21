class DraftsWikiHook < Redmine::Hook::ViewListener
  
  # Add our own elements to wiki show view
  #

  def view_layouts_base_content(context={})
    if User.current.logged? && context[:controller].is_a?(WikiController)
      template = context[:controller].instance_variable_get("@template")
      template.render :partial => "drafts/wiki_form", :locals => {:context => context}
    end
  end
  
end
