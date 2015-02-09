module Mokio
  class Content < ActiveRecord::Base
    include Mokio::Concerns::Models::Content
    include Mokio::Slugged
    
    def slug_prefix
      I18n.t("contents.slug_prefix")
    end
    
  end
end