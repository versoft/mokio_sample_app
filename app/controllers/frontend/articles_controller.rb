class Frontend::ArticlesController < Frontend::BaseController
  
  
  def show
    @content = Mokio::Article.find(params[:id])
    choose_meta(@content)
    render_single @content
  end
  
  
end