# encoding: UTF-8
module CampusesHelper
	def get_links_clases(class_input,object,university,campus)
		if class_input=='0'
			html="<a href=\"\#collapse#{class_input}#{object.name}\" data-parent=\"\#myAccordion#{object.name}\" data-toggle=\"collapse\" class=\"accordion-toggle collapsed campus_component\">#{object.name}</a>".html_safe
			html+=link_to('<i class="icon-trash icon-white"></i>'.html_safe, [university,campus,object], :class => 'btn btn-mini delete_btn float_right form_btn ', :confirm => 'Are you sure?',:title => 'Eliminar', :method => :delete, remote: true)
			html+=link_to('<i class="icon-pencil icon-white"></i>'.html_safe, edit_university_campus_building_path(university,campus,object), :class => "btn btn-mini edit_btn float_right form_btn ",:title => "Editar", :data => {:toggle=>"modal", :target => '#modal-building'}, remote: true)
			html
		elsif class_input=='1'
			html="<a href=\"\#collapse#{class_input}#{object.name}\" data-parent=\"\#myAccordion#{object.name}\" data-toggle=\"collapse\" class=\"accordion-toggle collapsed campus_component\">#{object.name}</a>".html_safe
			html+=link_to('<i class="icon-trash icon-white"></i>'.html_safe, [university,campus,object], :class => 'btn btn-mini delete_btn float_right form_btn ', :confirm => 'Are you sure?',:title => 'Eliminar', :method => :delete, remote: true)
			html+=link_to('<i class="icon-pencil icon-white"></i>'.html_safe, edit_university_campus_poi_path(university,campus,object), :class => "btn btn-mini edit_btn float_right form_btn ",:title => "Editar", :data => {:toggle=>"modal", :target => '#modal-poi'}, remote: true)
			html
		elsif class_input=='2'
			html="<a href=\"\#collapse#{class_input}#{object.name}\" data-parent=\"\#myAccordion#{object.name}\" data-toggle=\"collapse\" class=\"accordion-toggle collapsed campus_component\">#{object.name}</a>".html_safe
			html+=link_to('<i class="icon-trash icon-white"></i>'.html_safe, [university,campus,object], :class => 'btn btn-mini delete_btn float_right form_btn ', :confirm => 'Are you sure?',:title => 'Eliminar', :method => :delete, remote: true)
			html+=link_to('<i class="icon-pencil icon-white"></i>'.html_safe, edit_university_campus_por_path(university,campus,object), :class => "btn btn-mini edit_btn float_right form_btn ",:title => "Editar", :data => {:toggle=>"modal", :target => '#modal-por'}, remote: true)
			html
		elsif class_input=='3'
			html="<a href=\"\#collapse#{class_input}#{object.name}\" data-parent=\"\#myAccordion#{object.name}\" data-toggle=\"collapse\" class=\"accordion-toggle collapsed campus_component\">#{object.name}</a>".html_safe
			html+=link_to('<i class="icon-trash icon-white"></i>'.html_safe, [university,campus,object], :class => 'btn btn-mini delete_btn float_right form_btn ', :confirm => 'Are you sure?',:title => 'Eliminar', :method => :delete, remote: true)
			html+=link_to('<i class="icon-pencil icon-white"></i>'.html_safe, edit_university_campus_event_path(university,campus,object), :class => "btn btn-mini edit_btn float_right form_btn ",:title => "Editar", :data => {:toggle=>"modal", :target => '#modal-event'}, remote: true)
			html+=link_to('<i class="icon-qrcode icon-white"></i>'.html_safe, [university,campus,object], :class => 'btn btn-mini edit_btn float_right form_btn', :data => {:toggle=>"modal", :target => '#modal-qr'},:title => "Codigo QR", remote: true)
			html
		end
	end
	def get_body_accordion(class_input,object,university,campus)
		html="<div class=\"accordion-inner\">".html_safe
		if class_input==='0'
			if object.floors.count>0
				object.floors.each do |floor|
					html+=get_floor_view(university,campus,object,floor)
		    	end
		    else
		    	html+="<div><p>No tiene pisos</p></div>".html_safe				
			end
			html+="<a href=\"/universities/#{university.id}/campuses/#{campus.id}/buildings/#{object.id}/floors/new\" class=\"btn btn-mini float_right form_btn edit_btn\" data-remote=\"true\" data-target=\"#modal-building\" data-toggle=\"modal\" title=\"\" data-original-title=\"Nuevo Piso\">Agregar Piso <i class=\"icon-cross\"></i></a>".html_safe
		elsif class_input==='1'
			if object.categories.count>0
				object.categories.each do |category|
					html+=get_category_view(category)
		    	end
		    else
		    	html+="<div><p>No tiene categorias</p></div>".html_safe				
			end
		elsif class_input==='2'
			if object.dumps.count>0
				object.dumps.each do |dump|
					html+=get_dump_view(dump)
		    	end
		    else
		    	html+="<div><p>No tiene basureros</p></div>".html_safe				
			end
		elsif class_input==='3'
			if object.categories.count>0
				object.categories.each do |category|
					html+=get_category_event_view(category)
		   	end
		    else
		    	html+="<div><p>No tiene categorias</p></div>".html_safe				
			end
		end
		html+="</div>".html_safe
	end
	def get_floor_view(university,campus,buiding,floor)
		html="<div>".html_safe
		html+="<i class=\"icon-flag\"></i> <a href=\"/universities/#{university.id}/campuses/#{campus.id}/buildings/#{buiding.id}/floors/#{floor.id}\" data-remote=\"true\" data-target=\"#modal-building\" data-toggle=\"modal\">#{floor.number}</a>".html_safe
		html+="<a href=\"/universities/#{university.id}/campuses/#{campus.id}/buildings/#{buiding.id}/floors/#{floor.id}/Edit\" data-remote=\"true\" data-target=\"#modal-building\" data-toggle=\"modal\"><i class=\"icon-pencil\"></i></a>".html_safe
		html+="<a href=\"/universities/#{university.id}/campuses/#{campus.id}/buildings/#{buiding.id}/floors/#{floor.id}\" data-confirm=\"¿ Estás seguro que deseas eliminar este piso ?\" data-method=\"delete\" data-remote=\"true\" rel=\"nofollow\"><i class=\"icon-remove\"></i></a>".html_safe
		html+="<br>".html_safe
		html+="</div>".html_safe
		return html
	end
	def get_category_view(category)
		html="<div>".html_safe
		html+="<i class=\"icon-flag\"></i> #{category.name}".html_safe
		html+=link_to('<i class="icon-remove"></i>'.html_safe, [category.university, category], :confirm => '¿Estás seguro que deseas eliminar esta categoría? Esta acción no se puede deshacer.', :method => :delete, remote: true)
		html+="</div>".html_safe
		return html
	end
	def get_dump_view(dump)
		html="<div>".html_safe
		html+="<i class=\"icon-trash\"></i> #{dump.type.name}(#{dump.visits})".html_safe 
		html+= link_to('<i class="icon-qrcode"></i>'.html_safe, dump_path(dump), :class => 'btn btn-mini float_right', :data => {:toggle=>"modal", :target => '#modal-qr'},:title => "Codigo QR", remote: true)
		html+="</div>".html_safe
		return html
	end
	def get_category_event_view(category)
		html="<div>".html_safe
		html+="<i class=\"icon-flag\"></i> #{category.name}".html_safe
		html+=link_to('<i class="icon-remove"></i>'.html_safe, [category.university, category], :confirm => '¿Estás seguro que deseas eliminar esta categoría? Esta acción no se puede deshacer.', :method => :delete, remote: true)
		html+="</div>".html_safe
		return html
	end
end
