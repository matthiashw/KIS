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
      when 4
           description=I18n.t('field_definition.input_type.number')
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
      desc[I18n.t('field_definition.input_type.number')] = 4
      desc
  end

  #returns partial name string by number
  #if partial has to be filled with information value has to be true
  def self.input_type_partial (number, value)
    partial = "tasks/input_type/"
    case number
      when 1
           partial+="input_type_multi"
      when 2
           partial+="input_type_checkbox"
      when 3
           partial+="input_type_dropdown"
      when 4
           partial+="input_type_number"
      else
           partial+="input_type_default"
    end

    if value
      partial += "_value"
    end

    partial
    
  end

  #return the selected string, needs field def id and selected id in the dropdown
  #dropdown elements begin with 0 ...
  def self.dropdown_value_return (fielddef,dropid)
    fd = FieldDefinition.find(fielddef)

    unless fd.nil?
      return fd.additional_type_info.split(';')[dropid.to_i]
    end

    return ""
  end
end
