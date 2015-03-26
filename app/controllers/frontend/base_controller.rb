class Frontend::BaseController < ApplicationController
  protect_from_forgery
  layout "frontend"
  helper :application
  
  before_filter :redirect_to_lang_prefix
  before_action :set_locale
  before_action :set_objects, :only => [:show, :home]
  
  protected
  
  
    def redirect_to_lang_prefix
      redirect_to "/#{I18n.locale}/", status: :moved_permanently if params[:locale].nil?
    end
  
    def render_single(content)
      render :template => "frontend/#{mokio_type(content)}/show" if stale?(:etag => content, :last_modified => content.etag, :public => true)
    end
  
    def mokio_type(content)
      content.type.demodulize.tableize
    end
  
    def choose_meta(obj, menu = nil)
      if menu
        set_meta(menu)
      else
        set_meta(obj)
      end
    end
  
    def set_meta(obj)
      return unless (obj && obj.meta)
      @meta = {
        title:            obj.meta.g_title,
        desc:             obj.meta.g_desc,
        keywords:         obj.meta.g_keywords,
        author:           obj.meta.g_author,
        copyright:        obj.meta.g_copyright,
        application_name: obj.meta.g_application_name,
        f_title:          obj.meta.f_title,
        f_type:           obj.meta.f_type,
        f_image:          obj.meta.f_image,
        f_url:            obj.meta.f_url,
        f_desc:           obj.meta.f_desc
      }
    end
    
  private
  
    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
      @lang = Mokio::Lang.find_by(shortname: I18n.locale.to_s)
    end
  
    def set_objects
      @menu = Mokio::Menu.friendly.find(params[:menu_id]) if params[:menu_id].present?
      
      #fake lang menu
      lang_menu = Mokio::Menu.where(lang_id: @lang.id, ancestry: nil )
      #fake top menu
      @top_menu = lang_menu.first.children.where(name: 'top').first
      
      #init modules Hash with positions
      @modules = {}
      Mokio::ModulePosition.all.each do |pos|
        @modules[pos.name.to_sym] = Array.new
      end

      if params[:menu_id].present?
        @menu_static_modules = @menu.available_modules.all
        
        @menu_static_modules.each do |mod|
          add_module mod
        end
      end
      
      @always_displayed_modules = Mokio::AvailableModule.always_displayed
      @always_displayed_modules.each do |mod|
        add_module mod
      end
    end
    
    def add_module(mod)
      # TODO: for now we're ignoring display_from and display_to fields 
      return if mod.module_position.nil?
      position = mod.module_position.name.to_sym
      block = mod.static_module
      @modules[position].push block if (@modules[position].exclude?(block) && block.active && (block.lang_id == @lang.id || block.lang_id.nil?))
    end
  
end