require_dependency 'wiki_controller'

class WikiController
  prepend_before_filter :set_draft
  prepend_before_filter :find_existing_or_new_page, :only => [:show, :edit, :update]
  
  private
  
    def set_draft
      if params[:draft_id]
        @draft = Draft.find params[:draft_id] rescue nil
        if @draft
          @page = WikiPage.find(@draft.element_id)
          @project = Project.find(params[:project_id])
          @wiki = @project.wiki
          @wiki.find_page(@page.title)
          params.merge!(@draft.content)
          params.merge!(@draft.content)
          
          # instead of /projects/1 in the url, we want /projects/myproject
          params[:project_id] = @project.identifier 
          
          # Redmine tries really hard to send us to the wiki index... we want to edit
          # perhaps a routing would help?
          if params[:action] != 'edit' && !(params[:draft_redirected] == true)
            # avoid infinite loop
            params[:draft_redirected] = true
            redirect_to params.update(:id => @page.title, :action => 'edit')
          end
        end
      end
    end
    
    # override the old edit method so we can set the data from our params
    # instead of them being read out of the database
    old_edit = instance_method(:edit)
    define_method(:edit) do
      if @draft
        if (@draft.content[:content][:version]).to_i != (@page.content.version).to_i
          flash.now[:warning] = l(:label_draft_version_conflict,
            { :draft_version => @draft.content[:content][:version],
              :current_version => @page.content.version
             }
          )
        end
        @content = @page.content_for_version
        # restore wiki text
        @content.text = @draft.content[:content][:text]
        # restore saved comment (original function sets to nil)
        @content.comments = @draft.content[:content][:comments]
        # To prevent StaleObjectError exception when reverting to a previous version
        @content.version = @page.content.version
      else
        #find_wiki
        old_edit.bind(self).call
      end
    end
    
    # override the find_wiki method
    # if we have a draft, we don't want to use the old method
    old_find_wiki = instance_method(:find_wiki)
    define_method(:find_wiki) do
      if @draft
      else
	    old_find_wiki.bind(self).call
	  end
    end
    
    # override the find_existing_or_new_page method
    # This allows us to set some instance variables that would otherwise not be set
    old_find_existing_or_new_page = instance_method(:find_existing_or_new_page)
    define_method(:find_existing_or_new_page) do
	  @wiki = Project.find(params[:project_id]).wiki if !@wiki
      if @draft
		@page = WikiPage.find(@draft.element_id)
		edit
	  else
        # old_find_existing_or_new_page.bind(self).call
        @page = @wiki.find_or_new_page(params[:id])
        if @wiki.page_found_with_redirect?
          redirect_to params.update(:id => @page.title)
        end
        if params[:action] == 'edit' 
          old_edit.bind(self).call
        end
      end
    end
end

