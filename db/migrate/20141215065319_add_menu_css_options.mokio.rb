# This migration comes from mokio (originally 20141209101853)
class AddMenuCssOptions < ActiveRecord::Migration
  def change
    add_column :mokio_menus, :css_class, :string
    add_column :mokio_menus, :css_body_class, :string
  end
end
