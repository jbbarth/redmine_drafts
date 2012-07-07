require_dependency 'news_controller'

class NewsController
  unloadable
  
  prepend_before_filter :set_draft

  # override the NewsController.new() so we can fill in the saved draft data
  def new
	@news = News.new(:project => @project, :author => User.current)
    update_news_from_params unless @draft.nil?
  end
  
  # override the NewsController.edit() so we can fill in the saved draft data
  def edit
    update_news_from_params unless @draft.nil?
  end
  
  private

    def set_draft
      if params[:draft_id]
        @draft = Draft.find params[:draft_id] rescue nil
        if @draft
          params.merge!(@draft.content)
        end
      end
    end
    
    def update_news_from_params
      @news[:title] = @draft.content[:news][:title]
      @news[:summary] = @draft.content[:news][:summary]
      @news[:description] = @draft.content[:news][:description]
    end

end

