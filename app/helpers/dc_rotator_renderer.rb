#--
# Copyright (c) 2018+ Damjan Rems
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

########################################################################
# Renderer for rotator web element
########################################################################
class DcRotatorRenderer
  
########################################################################
#
########################################################################
def initialize( parent, opts={} )
  @parent    = parent
  @opts      = opts
  @opts[:element] ||= 'rotator'  
  @parts_css = ''
  self
end

########################################################################
# Fetch documents displayed by rorator
########################################################################
def rotator_documents()
  kats  = @opts.dig(:settings, @opts[:element], 'kats')
  query = if kats
    DcRotator.where(:kats.in => kats, active: true)
  else
    DcRotator.where(active: true)
  end
  query = query.and({"$or" => [{:valid_from => nil}, {:valid_from.lt => Time.now}]}, 
                    {"$or" => [{:valid_until => nil}, {:valid_until.gt => Time.now}]}) 
                  
  query.order_by(order: 1).limit(10)
end

########################################################################
# Prepares code for displaying single element
########################################################################
def one_element(doc)
  html = if doc.picture.empty?
%Q[<div class="orbit-text">#{doc.text.html_safe}</div>]
    else  
%Q[<div class="orbit-pic-with-text" style="position: relative;"><img class="orbit-image" src="#{doc.picture}" alt="#{doc.description}">] +
   (doc.text_over ? "<div style=\"#{doc.css_over}\">#{doc.text}</div>" : '') + '</div>'
  end.html_safe
  html = @parent.link_to(html, doc.link, target: doc.target) unless doc.link.empty?
  html
end

########################################################################
# Render rotator for display.
########################################################################
def rotator_4display
  delay = @opts.dig(:settings, @opts[:element], 'delay') || 2000
  html = %Q[
<div class="orbit" role="region" aria-label="" data-orbit data-timer-delay="#{delay}">
  <div class="orbit-wrapper">
    <ul class="orbit-container">
]
  nav = '<nav class="orbit-bullets">' 
# each document
  n, is_active = 0, 'is-active'
  rotator_documents.each do |doc|
    html << %Q[<li class="#{is_active} orbit-slide"> <figure class="orbit-figure">]
    html << one_element(doc)
    html << '</figure> </li>'
    nav  << %Q[<button class="#{is_active}" data-slide="#{n}"><span class="show-for-sr">Slide #{n+1} details.</span></button>]
#    
    is_active = ''
    n+=1
  end
  "#{html}</ul>#{nav}</nav></div></div>"
end

########################################################################
# Create code for rotator settings link
########################################################################
def link_for_rotator_settings
  table = @opts[:table] || @parent.page.class.to_s
  id = (table == 'dc_site') ? @parent.site.id : @parent.page.id
%Q[  
  #{@parent.dc_link_for_edit(table: 'dc_memory', title: 'helpers.dc_rotator.settings', 
                             form_name: 'dc_rotator_settings', icon: 'cog lg',
                             id: id, location: table, action: 'new',
                             element: @opts[:element] )}
  #{@parent.dc_link_for_create(table: 'dc_rotator', title: 'helpers.dc_rotator.create')}
]
end

########################################################################
# Render rotator for edit.
########################################################################
def rotator_4edit
  html = %Q[<div class="orbit">#{link_for_rotator_settings}]
# each document
  rotator_documents.each do |doc|
    html << %Q[<div class="orbit-slide">#{@parent.dc_link_for_edit(table: 'dc_rotator', id: doc.id, title: 'helpers.dc_rotator.edit')}</div>]
    html << one_element(doc)
  end
  "#{html}</div>"
end

########################################################################
# Default rorator renderer method.
########################################################################
def default
  clas = @opts.dig(:settings, @opts[:element], 'class')
  clas = "#{clas} #{@opts[:div_class]}" if @opts[:div_class]
  html = clas.blank? ? '' : "<div class=\"#{clas}\">"
  html << if @opts[:edit_mode] > 1
    rotator_4edit
  else
    rotator_4display
  end
  html << (clas.blank? ? '' : '</div>')
end

########################################################################
#
########################################################################
def render_html
  method = @opts[:method] || 'default'
  respond_to?(method) ? send(method) : "Error rotator: Method #{method} doesn't exist!"
end

########################################################################
#
########################################################################
def render_css
  @parts_css
end

end
