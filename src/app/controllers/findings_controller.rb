class FindingsController < ApplicationController
  def index
    return false unless authorize(permissions = ["access_finding"])

    @findings = Task.all :conditions => { :state => Task.state_closed, :case_file_id => get_case_for_view }
    @measured_values = MeasuredValue.all :conditions => { :task_id => @findings}

    @fieldhash = {}
    @units = []

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

        h = { entry.name => feid }

        if not @fieldhash.has_key?(entry.name)
          @fieldhash.merge! h
          if(field.ucum_entry)
            @units.push field.ucum_entry.description
          else
            @units.push ''
          end
        end
      end

    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @domains }
      format.json { render :json => @fieldhash }
    end
  end

  def chartdata
    @findings = Task.all :conditions => { :state => Task.state_closed, :case_file_id => get_case_for_view }
    @measured_values = MeasuredValue.all :conditions => { :task_id => @findings}

    @output = Array.new

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

      next if feid.to_s != params[:field_id]

      if ctype.application != "user_defined"
        @output.push({
          'date' =>  mv.created_at.strftime("%d. %b %Y - %H:%M"),
          'value' => mv.value
        })
     end
    end

    respond_to do |format|
      format.xml  { render :xml => @output }
      format.json { render :json => @output }
    end
    
  end
end
