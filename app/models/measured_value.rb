class MeasuredValue < ActiveRecord::Base
  belongs_to :field
  belongs_to :task
  belongs_to :medical_template
  validate :number
  def number
    errors.add_to_base(I18n.t('task.messages.must_be_number')) unless (field.field_definition.input_type!=4 || numeric? || value=="")
  end

  def numeric?
    true if Float(value) rescue false
  end
end
