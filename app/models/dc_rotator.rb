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

##########################################################################
# DcRotator model definition.
##########################################################################
class DcRotator
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :description, type: String
  field :link,        type: String
  field :target,      type: String,  default: ''
  field :picture,     type: String
  field :text,        type: String
  field :css_over,    type: String
  field :text_over,   type: Boolean, default: false
  
  field :valid_from,  type: DateTime
  field :valid_until, type: DateTime
  field :order,       type: Integer, default: 10
  field :kats,        type: Array        
  
  field :active,      type: Boolean, default: true 
  field :created_by,  type: BSON::ObjectId
  field :updated_by,  type: BSON::ObjectId
  
  index( { kats: 1 } )
  
  validates :description,  presence: true  

  validate :additional_controls
  
  before_save :do_before_save  
  
private
  
##########################################################################
# 
##########################################################################
def do_before_save
#
end  

######################################################################
# Additional controls if required. Will see.
######################################################################
def additional_controls # 
  if kats.nil? or kats.size == 0
#    errors.add('kats', 'At least one category should be selected!')
  end
  if text_over
    errors.add('css_over', 'helpers.help.rotator.css_over_error') if css_over.blank?
    errors.add('picture', 'helpers.help.rotator.picture_error') if picture.blank?
  end
end

######################################################################
# Returns values for categories
######################################################################
def self.choices4_kats
  DcSite.where(active: true).inject([]) {|r, site| r << [site.name, site.name] }
end

end
