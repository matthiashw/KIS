# copy this file to your project!!!

module SwapselectHelper
	
	def swapselect( object_name, object, method, choices, params = {:size => 8 } ) 

		param_name = "#{method.to_s.singularize}_ids"
		size = params[:size] 
		selected = object.send param_name
		
		buff = "<script type='text/javascript'>"
		buff += "new SwapSelect('#{object_name.to_s}[#{param_name}][]', new Array("

		choices.each do |elem| 
			is_selected = selected.any? { |item| item == elem.last }
			
			buff += "new Array( '#{elem.last}', '#{elem.first}', #{is_selected} ),"
		end
		
		buff.slice!( buff.length - 1 )
		
		buff += "), #{size} );"
		buff += "</script>"
		
		return buff
	end

  def swapselectmanual( object_name, items, name, id, choices, params = {:size => 8 } )
		size = params[:size]

		buff = "<script type='text/javascript'>"
		buff += "new SwapSelect('#{'special'}[#{items[0].class.to_s}][]', new Array("

		items.each do |elem|
      elem_id = elem.send id
      elem_name = elem.send name

      is_selected = choices.any? { |item| item.to_s == elem_id.to_s }

			buff += "new Array( '#{elem_id}', '#{elem_name}', #{is_selected} ),"
		end

		buff.slice!( buff.length - 1 )

		buff += "), #{size} );"
		buff += "</script>"

		return buff
	end
end
