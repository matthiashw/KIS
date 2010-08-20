class FindingsController < ApplicationController
  def index
    return false unless authorize(permissions = ["access_finding"])

    @findings = Task.all :conditions => { :state => Task.state_closed, :case_file_id => get_case_for_view }
    @measured_values = MeasuredValue.all :conditions => { :task_id => @findings}

    @fieldhash = {}

    @measured_values.each do |mv|
      fid = mv.field_id
      field = Field.find_by_id(fid)
      fdid = field.field_definition_id
      field_def = FieldDefinition.find_by_id(fdid)
      feid = field_def.field_entry_id
      entry = Entry.find_by_id(feid)

      cid = entry.catalog_id
      cat = Catalog.find_by_id(cid)
      ctid = cat.catalog_type_id
      ctype = CatalogType.find_by_id(ctid)

      if ctype.application != "user_defined"

        h = { entry.name => fid }

        if @fieldhash.has_key?(entry.name)
          value = @fieldhash.values_at(entry.name)
          ids = ""
          value.each do |v|
            ids += v.to_s + ","
          end
          h = { entry.name => ids + fid.to_s }
        end
        @fieldhash.merge!(h)
      end

    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @domains }
    end
  end

end
