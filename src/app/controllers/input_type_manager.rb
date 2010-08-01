# This class should produce the Input Tags for the Template System

class InputTypeManager

  #Performance issues
  def self.input_type_description number

    case number
      when 1
           description=I18n.t('field_definition.input_type.multiline')
      when 2
           description=I18n.t('field_definition.input_type.checkbox')
      when 3
           description=I18n.t('field_definition.input_type.dropdown')
      else
           description=I18n.t('field_definition.input_type.default')
    end
    description
  end

  def self.input_type_descriptions
      desc=Hash.new
      desc[I18n.t('field_definition.input_type.default')] = 0
      desc[I18n.t('field_definition.input_type.multiline')] = 1
      desc[I18n.t('field_definition.input_type.checkbox')] = 2
      desc[I18n.t('field_definition.input_type.dropdown')] = 3
      desc
  end
end
