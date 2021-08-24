module NavbarHideable
  extend ActiveSupport::Concern

  private

  def hide_navbar
    @hide_navbar = true
  end

  def hide_desktop_navbar
    @hide_desktop_navbar = true
  end

  def hide_all_navbars
    hide_navbar
    hide_desktop_navbar
  end
end
