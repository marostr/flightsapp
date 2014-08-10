module ApplicationHelper
  def render_flash
    content_tag(:div, :id => :flashes) do
      flash.map do |k,v|
        type = k == 'notice' ? "success" : "danger"
        concat(content_tag(:div, :class => "alert alert-#{type}") do
          concat(content_tag(:p, v))
        end)
      end
    end unless flash.empty?
  end
end
