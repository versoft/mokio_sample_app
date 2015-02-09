class Frontend::ContentController < Frontend::BaseController
  
  
  def home
    
  end
  
  def show
    @menu = Mokio::Menu.friendly.find(params[:menu_id])
    @contents = @menu.contents.displayed

    if @contents.any? && @menu.active
      @content = @contents.first
      @gmap = @content.gmap
      choose_meta(@content, @menu)
      if @content.tpl.present?
        render :template => "frontend/content/#{@content.tpl}" if stale?(:etag => @content, :last_modified => @content.etag, :public => true)
      else
        if @contents.length > 1
          render :template => "frontend/content/index"
        elsif @contents.length == 1
          render_single @content
        else
          redirect_to root_path 
        end
      end
    end
  end
  
  
end