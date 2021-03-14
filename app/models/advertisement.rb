class Advertisement < Sequel::Model
  def validate
    super
    validates_presence :city, message: I18n.t(:blank, scope: 'model.errors.advertisement.city')
    validates_presence :title, message: I18n.t(:blank, scope: 'model.errors.advertisement.title')
    validates_presence :description, message: I18n.t(:blank, scope: 'model.errors.advertisement.description')

    # validates :presence, %i[title city]
  end
end

# class ApplicationRecord < Sequel::Model
#   def validates(type, attrs)
#     attrs.each do |attr|
#       send("validates_#{type}", attr, message: I18n.t())
#     end
#   end
# end
