class MeasuredValue < ActiveRecord::Base
  belongs_to :field
  belongs_to :task
  belongs_to :medical_template
end
