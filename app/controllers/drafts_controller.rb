class DraftsController < ApplicationController
  unloadable
  
  before_filter :require_login

  def autosave
    set_kind_from_params
    case @kind
    when 'issue'
      # for existing issue
      has_to_be_saved = !params[:notes].blank?
      # for new issue
      has_to_be_saved ||= (params[:issue_id].to_i == 0 && !params[:issue][:subject].blank?)
    when 'wiki'
      has_to_be_saved = !params[:content][:text].blank?
    when 'news'
      has_to_be_saved = !params[:news][:description].blank?
    when nil
    end
  
    if !@kind.nil? && request.xhr? && has_to_be_saved
      case @kind
      when 'issue'
        new_content = get_issue_content
      when 'wiki'
        newcontent = get_wiki_content
      when 'news'
        new_content = get_news_content
      end

      unless @draft.content == new_content
        @draft.content = new_content
        if @draft.save
          render :partial => "saved", :layout => false
        else
          render :text => "Error saving draft"
        end
      end
    end
    render :nothing => true unless performed?
  end
  
  def set_kind_from_params
    if !params[:issue].nil? || !params[:issue_id].nil?
      @kind = 'issue'
    elsif !params[:wiki_id].nil?
      @kind = 'wiki'
    elsif !params[:news].nil?
      @kind = 'news'
    else
      @kind = nil
    end
  end
  
  def get_issue_content
      @draft = Draft.find_or_create_for_issue(:user_id => User.current.id,
                                              :element_id => params[:issue_id].to_i)
      new_content = params.reject{|k,v| !%w(issue notes).include?(k)}
      return new_content
  end

  def get_wiki_content
      @draft = Draft.find_or_create_for_wiki(:user_id => User.current.id,
                                              :element_id => params[:wiki_id].to_i)
      new_content = params.reject{|k,v| !%w(content).include?(k)}
      return new_content
  end
  
  def get_news_content
      @draft = Draft.find_or_create_for_news(:user_id => User.current.id,
                                             :element_id => params[:news_id].to_i)
      new_content = params.reject{|k,v| !%w(news).include?(k)}
      return new_content
  end

  def restore
    @draft = Draft.find(params[:id])
    kind = @draft[:element_type].downcase!
    case kind
    when 'issue'
      self.restore_issue
    when 'wiki'
      self.restore_wiki
    when 'news'
      self.restore_news
    end
  end
  
  def restore_issue
    if @draft.element_id == 0
      redirect_to({:controller => 'issues', :action => 'new', :project_id => params[:project_id].to_i, :draft_id => @draft})
    else
      redirect_to({:controller => 'issues', :action => 'edit', 
        :id => @draft.element_id, :draft_id => @draft, :project_id => params[:project_id]
        })
    end
  end
  
  def restore_wiki    
    if @draft.element_id == 0
      redirect_to({:controller => 'wikis', :action => 'new', :project_id => params[:project_id].to_i, :draft_id => @draft})
    else
      @page = WikiPage.find(@draft.element_id)
      @wiki = Project.find(params[:project_id]).wiki
      params.update({ 
        :id => @draft.element_id,
        :draft_id => @draft, 
        :page_id => @page.id, 
        :wiki => @page,
        :content => @draft.content[:content],
      })
      redirect_to({:controller => 'Wiki', :action => 'edit',
        :id => @draft.element_id,
        :draft_id => @draft, 
        :page_id => @page.id, 
        :wiki => @page, # for WikiController
        :wiki => @page.title, # for WikisController
        :content => @draft.content[:content],
        :project_id => params[:project_id]
        })
    end
  end
  
  def restore_news
    if @draft.element_id == 0
      redirect_to({:controller => 'news', :action => 'new', 
                 :draft_id => @draft, :project_id => params[:project_id].to_i
      })
    else
      @news = News.find(@draft.element_id)
      redirect_to({:controller => 'news', :action => 'edit', 
                 :id => @draft.element_id,
                 :draft_id => @draft, :project_id => params[:project_id].to_i
      })
    end
  end
  
  def destroy
    @draft = Draft.find(params[:id])
    @draft.destroy
    render :nothing => true
  end
end
