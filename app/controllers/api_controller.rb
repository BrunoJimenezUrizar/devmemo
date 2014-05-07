#!/bin/env ruby
# encoding: UTF-8
## =========================================================================================
## API
## -----------------------------------------------------------------------------------------
## Controlador para los request móviles.
## =========================================================================================
## IIC2154 - Grupo 1
## =========================================================================================
## Segundo Semestre 2013
## =========================================================================================

class ApiController < ApplicationController
	ActiveRecord::Base.include_root_in_json = false
	before_filter :restrict_access
	
	##==================================================
	# API retorna los pisos de un edificio
	#---------------------------------------------------
	# /api/get_building_floors/:building_id/:api_token
	##==================================================
	def get_building_floors
		building = Building.find(params[:building_id])
		if building.floors.count > 0
			render :json => building.floors.map{|f| f.as_json(:only => [:description, :number, :photo], :methods => :photo)}.to_json
		else
			render :json => [:message => "El edificio no tiene pisos disponibles"].to_json
		end
	end
	##==================================================
	# API que retorna informacion de puntaje, ranking
	#---------------------------------------------------
	# /api/load_game/:api_token/:access_token
	##==================================================
	def load_game

		# Información general a partir de lo enviado por android
		@mobile_user = MobileUser.find_by_api_token(params[:api_token])
		access_token = params[:access_token]
	
		# Interacción con Facebook
		graph = Koala::Facebook::GraphAPI.new(access_token)
      	friends = graph.get_connections("me", "friends")
		friends_ids = Array.new
		friends_ids << @mobile_user.id
		friends.each do |friend|
			fb_friend =  MobileUser.find_by_fb_id(friend["id"])
			if fb_friend
				friends_ids << fb_friend.id #guardamos los ids en un array
			end
		end
		
		#Ordenamos los usuarios móviles en forma descendiente
		mobile_users_ordered = MobileUser.order("score DESC")
		#Posición sobre el total de usuarios
		absolute_position = mobile_users_ordered.index(@mobile_user)
		#Seleccionamos solo los que son amigos de quién consulta su perfil
		mb_users_ranking = mobile_users_ordered.find(friends_ids)
		#Obtenemos el indice en el cual se encuentra el usuario
		mobile_user_index = mb_users_ranking.index(@mobile_user)
		#Establecemos los indices menor y mayor para tener usuarios sobre y bajo el usuario móvil
		end_index = mobile_user_index +10
		start_index = mobile_user_index -10
		#En caso de que el indice de partida se haga negativo lo dejamos en cero
		if start_index < 0
			start_index = 0
		end

		#Tomamos a todos los amigos del usuario y sacamos la parte del arreglo segun los indices establecidos
		ranking_array = mb_users_ranking[start_index,end_index]
		
		#Creamos el ranking
		ranking = Array.new
		relative_position = -1
		position = 1
		ranking_array.each do |user|
			ranking <<{:position=> position,:name => user.full_name,:score =>user.score, :level => user.level, :picture =>user.profile_picture_url,:fb_id => user.fb_id}
			if user == @mobile_user
				relative_position = position
			end
			position+=1
		end

		#Desplegamos la información
		render :json => [
			:ranking => ranking,
			:user => @mobile_user.full_name,
			:score => @mobile_user.score,
			:my_position => relative_position,
			:my_total_position => absolute_position,
			:total_users => MobileUser.all.count
			].to_json
	end

	##==================================================
	# API que retorna los niveles del juego
	#---------------------------------------------------
	# /api/get_game_levels/:api_token
	##==================================================
	def get_game_levels
		levels = Level.order("points DESC").all
		render :json => levels.map{|level| level.as_json(:only=>[:id,:name,:points],:methods => :image)}.to_json
	end

	##==================================================
	# API que retorna información personal del usuario
	#---------------------------------------------------
	# /api/show_profile/:api_token
	##==================================================
	def show_profile
		
		#============= INFORMACIÓN GENERAL ================================#
			@mobile_user = MobileUser.find_by_api_token(params[:api_token])#
			university = University.find(params[:university_id])		   #
		#==================================================================#


		#======================= INFO RECICLAJE ==========================#
			recycle_info = RecycleInfo.where("mobile_user_id = ? AND university_id = ?", @mobile_user.id, params[:university_id])
			types = Type.where("university_id = ?",params[:university_id])
		
			#--------------información-------------#
			total_recycles = recycle_info.count
			last_month_recycles = recycle_info.where("created_at >= ?", 1.month.ago).count
			last_week_recycles = recycle_info.where("created_at >= ?",1.week.ago).count
			points_of_recycle = recycle_info.count(:group=> "type_id")
			info_by_types = Hash.new
			info_by_months = Hash.new
		
			#-----Procesamiento de información-----#

				#Cálculo por mes
				number_of_months = 0..11
				number_of_months.to_a.reverse.each do |month_offset|
			  		start_date = month_offset.months.ago.beginning_of_month
			  		end_date = month_offset.months.ago.end_of_month
			  		info_by_months[start_date.month] = recycle_info.where(created_at: start_date..end_date).count
				end
				
				#Cálculo por tipo
				types.each do |t|
					info_by_types[t.name] = recycle_info.where("type_id = ?", t.id).count
				end

		#======================= INFO EVENTOS ==========================#
			events = @mobile_user.events
			total_events = events.count
			last_week_events = events.where("start_date >= ?",1.week.ago).count
			last_month_events = events.where("start_date >= ?",1.week.ago).count
			last_ten_events = events.last(10).map{|e| e.name}

		#======================= INFO DENUNCIAS ==========================#
			complaints = @mobile_user.complaints
			complaints = complaints.order("updated_at DESC").limit(10) #ultimas 10 que fueron actualizadas recientemente
			recieved_complaints = complaints.where("status = ?","Recibida")
			seen_complaints = complaints.where("status = ?","Vista")
			solved_complaints = complaints.where("status = ?","Solucionada")

		#======================= JSON ====================================#
			render :json => [
				:university => university.name,
				#reciclaje
				:recycle_info => [
					:total => total_recycles,
					:last_week => last_week_recycles,
					:last_month => last_month_recycles,
					:info_by_types => [info_by_types],
					:info_by_months => [info_by_months]
					],
				#eventos
				:events_info => [
					:total => total_events,
					:last_week => last_week_events,
					:last_month => last_month_events,
					:last_ten_events => last_ten_events
					],
				:complaints_info => [
					:recieved => recieved_complaints.map{ |c| c.as_json(:only => [:id,:description,:created_at,:updated_at],:methods => [:admin_comments])},
					:seen => seen_complaints.map{ |c| c.as_json(:only => [:id,:description,:created_at,:updated_at],:methods => [:admin_comments])},
					:solved => solved_complaints.map{ |c| c.as_json(:only => [:id,:description,:created_at,:updated_at],:methods => [:admin_comments])}
					]
			].to_json

		#==================================================================#

	end

	##==================================================
	# 	API que retorna los eventos
	#---------------------------------------------------
	#/api/load_week_events/:campus_id/:api_token
	##==================================================
	def load_week_events	
		campus = Campus.find(params[:campus_id])
		actual_date = Time.current
		limit_date = actual_date + 1.weeks - 1.days
		events = campus.events.where("start_date >= ? AND start_date <= ?", actual_date,limit_date)

		render :json =>[
			:campus => campus.name,
			:week_events => events.map{|e| e.as_json(:only=>[:name, :description, :latitude,:longitude],:methods => [:friendly_date])}
		].to_json
	end

	##==================================================
	# 	API que retorna los tipos de denuncias
	#---------------------------------------------------
	#/api/get_complaint_types/:university_id/:api_token
	##==================================================
	def get_complaint_types
		complaint_types = ComplaintType.where("university_id = ?",params[:university_id])
		render :json => [
			:complaint_types => complaint_types.map { |c| c.as_json(:only => [:id,:name])},
			:university_id => params[:university_id]
			].to_json
	end

	##==================================================
	# API que retorna el formulario de la encuesta
	#---------------------------------------------------
	# /api/get_survey/:campus_survey_id/:api_token
	##==================================================
	def get_survey
		campus_survey = CampusSurvey.find(params[:campus_survey_id])
		@university = campus_survey.campus.university
		@survey = campus_survey.question_group
		@questions = @survey.questions

		redirect_to "/universities/#{@university.id}/surveys/question_groups/#{@survey.id}/answer_groups/new"
	end
	
	##==================================================
	# API para realizar una denuncia desde Android
	#---------------------------------------------------
	# /api/make_complaint/:api_token
	##==================================================
	def make_complaint
		@campus = Campus.find(params[:campus_id])
    	@complaint = @campus.complaints.build(params[:complaint])
    	@mobile_user = MobileUser.find_by_api_token(params[:api_token])
		@complaint.mobile_user_id = @mobile_user.id
		@complaint.status = "Recibida"

		if @complaint.save
			campus_complaints = Complaint.where("campus_id = ?",@campus.id)
			complaint_status_info = Hash.new
			complaint_status_info["Recibida"] = Complaint.where("status = ?","Recibida").count
			complaint_status_info["Vista"] = Complaint.where("status = ?","Vista").count
			complaint_status_info["Solucionada"] = Complaint.where("status = ?","Solucionada").count
			
			render :json => [
				:message => "¡Tu denuncia fue recibida!",
				:complaint_status_info => [complaint_status_info]
			].to_json
		else
			render :json => [{:message => "Lo sentimos tu denuncia no pudo ser guardada"}]
		end
	end

	##==================================================
	# API que retorna el reciclaje de un usuario móvil
	#---------------------------------------------------
	# /api/my_recycle_info/:university_id/:api_token
	##==================================================
	def my_recycle_info
		@mobile_user = MobileUser.find_by_api_token(params[:api_token])
		recycle_info = RecycleInfo.where("mobile_user_id = ? AND university_id = ?", @mobile_user.id, params[:university_id])
		types = Type.where("university_id = ?",params[:university_id])
		
		#--------------información-------------#
			university = University.find(params[:university_id])
			total = recycle_info.count
			last_month = recycle_info.where("created_at >= ?", 1.month.ago).count
			last_week = recycle_info.where("created_at >= ?",1.week.ago).count
			points_of_recycle = recycle_info.count(:group=> "type_id")
			info_by_types = Hash.new
			info_by_months = Hash.new
		
		#-----Procesamiento de información-----#
		
			#Cálculo por mes
			number_of_months = 0..11
			number_of_months.to_a.reverse.each do |month_offset|
		  		start_date = month_offset.months.ago.beginning_of_month
		  		end_date = month_offset.months.ago.end_of_month
		  		info_by_months[start_date.month] = recycle_info.where(created_at: start_date..end_date).count
			end
			
			#Cálculo por tipo
			types.each do |t|
				info_by_types[t.name] = recycle_info.where("type_id = ?", t.id).count
			end
		
		#---------------------------------------#

		render :json => [
			:university => university.name,
			:total => total,
			:last_week => last_week,
			:last_month => last_month,
			:info_by_types => [info_by_types],
			:info_by_months => [info_by_months]
			].to_json

	end
	
	##==========================================================
	# API que retorna informacion de eventos de un usuario móvil
	#-----------------------------------------------------------
	# /api/my_events_info/:university_id/:api_token
	##==========================================================
	def my_events_info
		@mobile_user = MobileUser.find_by_api_token(params[:api_token])
		university = University.find(params[:university_id])
		events = @mobile_user.events
		total = events.count
		last_week = events.where("start_date >= ?",1.week.ago).count
		last_month = events.where("start_date >= ?",1.week.ago).count
		last_ten_events = events.last(10).map{|e| e.name}

		render :json => [
			:university => university.name,
			:total => total,
			:last_week => last_week,
			:last_month => last_month,
			:last_ten_events => last_ten_events
		].to_json
	end

	##==========================================================
	# API invocada por el QR para hacer un reciclaje
	#-----------------------------------------------------------
	#/api/recycle/:dump/:api_token
	##==========================================================
	def recycle
	    @dump= Dump.find(params[:dump_id])
	    @type = @dump.type.name
	    @mobile_user = MobileUser.find_by_api_token(params[:api_token])
	    @por = Por.find(@dump.por_id)
	    @campus = @por.campus
	    @university = @campus.university

	    #Tiempo en que no se podrá volver a reciclar en un mismo basurero
	    limit_date = Time.current - 10.minutes
	    #Numero de reciclajes en ese periodo para el basurero en cuestión.
	    recycle_outdated = RecycleInfo.where("dump_id = ? AND mobile_user_id = ? AND created_at >= ?",@dump.id,@mobile_user.id,limit_date).count

	    if recycle_outdated == 0

		    #Registramos el reciclaje
		    recycle_info = RecycleInfo.create(:mobile_user_id=> @mobile_user.id, :dump_id=> @dump.id, :university_id => @university.id, :campus_id => @campus.id, :type_id => @dump.type.id,:por_id => @por.id)

		    if recycle_info.save
			    #Asgnación de puntaje
			    @mobile_user.score+=50
			    @mobile_user.save

			    #Procesamos la informacion de reciclaje para feedback al usuario
			    por_recycles = RecycleInfo.where("por_id = ?",@por.id)
			    @total_recycles =por_recycles.count
			    last_month = por_recycles.where("created_at = ?",Time.now-1.month)
			    @info_last_month = Hash.new
			    last_week = por_recycles.where("created_at = ?", Time.now-1.week)
			    @info_last_week = Hash.new
			    types = @por.types

			    ## generamos la informacion por type ##
			     types.each do |t|
			     	@info_last_month[t.name]=last_month.where("type_id = ?", t.id).count
			     	@info_last_week[t.name] = last_week.where("type_id = ?", t.id).count
			     end
			    ##-----------------------------------##

			    render :json => [
			    	:message => "¡Gracias por reciclar! has ganado 200 puntos.",
			    	:university => @university.name,
			    	:campus => @campus.name,
			    	:por => @por.name,
			    	:dump_id => @dump.id,
			    	:type => @type,
			    	:total_recycles => @total_recycles,
			    	:info_last_week => [@info_last_week],
			    	:info_last_month => [@info_last_month]
			    ].to_json
			else
				render :json => [:message => "Lo sentimos hubo un problema al reciclar"].to_json
			end
		else
			render :json => [:message => "¡Hace unos minutos ya reciclaste en este basurero! Espera unos minutos o busca otro basurero."].to_json
		end
	
  	end

  	##==========================================================
	# API invocada por el QR para hacer check-in en un evento
	#-----------------------------------------------------------
  	#/check_in/:event_id/:api_token
  	##==========================================================
  	def check_in
	    @event= Event.find(params[:event_id])
	    @mobile_user = MobileUser.find_by_api_token(params[:api_token])

	    if Time.now >= @event.start_date and Time.now <= @event.end_date
		    #Hacemos la relacion entre mobile_user y event
		    @attendee = Attendee.create(:event_id => @event.id, :mobile_user_id => @mobile_user.id)
		    
		    if @attendee.save    
			    @campus = @event.campus
			    @university = @campus.university
			    @number_of_participants = Attendee.where("event_id = ?",@event.id).count
			    @event_image_url = @event.image.url
			    
			    #Asgnación de puntaje
	    		@mobile_user.score+= 150
	    		@mobile_user.save

			    render "api/events/check_in.json.erb"
			else
				render :json => [{:message => "Ya hiciste check_in en "+@event.name}].to_json
			end
		elsif Time.now <= @event.start_date
			render :json => [{:message => "Aun no es tiempo de hacer check-in"}].to_json
		elsif Time.now > @event.start_date
			render :json => [{:message => "No es posible hacer check-in ya que el evento finalizó"}].to_json
		else
			render :json => [{:message => "No es poisible hacer check-in"}].to_json
		end
	end

	##==========================================================
	# API que retorna las universidades
	#-----------------------------------------------------------
	#/api/get_universities/:api_token
	##==========================================================
	def get_universities
		@universities = University.all
		render :json => (@universities.map { |u| u.as_json(:only => [:id,:name, :acronym, :logo])}).to_json
	end
	
	##==========================================================
	# API que retorna los campuses
	#-----------------------------------------------------------
	#/api/get_campuses/:api_token
	##==========================================================
	def get_campuses
		campuses = Campus.all
		render :json => (campuses.map { |c| c.as_json(:only => [:id, :name, :university_id],:methods => [:encoded_polygon,:center_latitude,:center_longitude]) }).to_json
	end

	##==========================================================
	# API que retorna las universidades con sus campuses
	#-----------------------------------------------------------
	#/api/get_universities_and_campuses/:api_token
	##==========================================================
	def get_universities_and_campuses
		@universities = University.all
		render :json => (@universities.map { |u| u.as_json(:only => [:id,:name, :acronym], :methods => [:json_campuses,:logo])}).to_json
	end

	##==========================================================
	# API que retorna los puntos actuales del mapa
	#-----------------------------------------------------------
	#/api/load_campus_points/:campus_id/:api_token
	##==========================================================
	def load_campus_points
		campus = Campus.find(params[:campus_id])
		pois = campus.pois
		pors = campus.pors
		buildings = campus.buildings
		events = campus.events

		render :json =>[
		:pois => pois.map{ |poi| poi.as_json(:only => [:id,:description, :name],:methods => [:latitude, :longitude, :categories_s]) }, 
		:pors => pors.map{ |por| por.as_json(:only => [:id,:description], :methods => [:latitude, :longitude, :types_of_dumps]) },
		:buildings => buildings.map{ |building| building.as_json(:only => [:id,:name],:methods => [:encoded_polygon,:center_latitude,:center_longitude]) },
		:events => events.map{ |event| event.as_json(:only => [:id,:description, :end_date, :name,:start_date, :image], :methods => [:latitude, :longitude, :categories_s]) }
		].to_json
	end

	##==========================================================
	# API que retorna elementos para el banner
	#-----------------------------------------------------------
	#api/load_banner/:campus_id/:api_token
	##==========================================================
	def load_banner
		#obtenemos el campus
		campus = Campus.find(params[:campus_id])
		actual_date = Time.current
		
		#Escogemos la publicidad, noticias, encuestas y eventos que están activos y poseen imagen para ser desplegados.
		advertises = campus.advertises.where("active = ? AND start_date <= ? AND end_date >= ?", true ,actual_date,actual_date)
		reports = campus.reports.where("active = ? AND start_date <= ? AND end_date >= ?", true, actual_date,actual_date)
		surveys = campus.question_groups.where("active = ? AND photo_file_name != ?",true,"")
		events = campus.events.where("start_advertising <= ? AND end_advertising >= ? AND image_file_name != ?", actual_date,actual_date,"")

		# De todos los elementos disponibles sacamos una muestra de "n" por cada tipo.
		advertises = advertises.sample(2)
		reports = reports.sample(2)
		surveys = surveys.sample(2)
		events = events.sample(2)

		render :json => [
		:advertises => advertises.map{|adv| adv.as_json(:only => [:id,:active, :name,:link], :methods => :image_advertise)},
		:reports => reports.map{|rep| rep.as_json(:only => [:id,:active,:name, :link], :methods=>:image_report)},
		:surveys => surveys.map{|surv| surv.as_json(:only => [:id,:name,:active],:methods => :photo)},
		:events => events.map{|event| event.as_json(:only => [:id,:name],:methods => :image)}
		].to_json
	end
	
	##==========================================================
	# AUTENTIFICACIÓN DEL USUARIO MÓVIL VÍA API_TOKEN
	#-----------------------------------------------------------
		private
		def restrict_access
			@mobile_user = MobileUser.find_by_api_token(params[:api_token])
			head :unauthorized unless @mobile_user
		end
	##==========================================================

	#Setea el campus y universidad en el cual se encuentra el usuario móvil
	def get_campus_and_university
	    @university = University.find(params[:university_id])
	    @campus = @university.campuses.find(params[:campus_id])
  	end

  	def create_test_users    
	    quantity = params[:quantity]
	    
	    #Inicializamos la API para los usuarios de prueba
	    test_users = Koala::Facebook::TestUsers.new(:app_id => "1407365282825170", :secret => "96c0921dc1a9bba28b2b32f101de29bd")

	    for i in 0..quantity do
	      user = test_users.create(true,"email")  
	      graph = Koala::Facebook::API.new(user["access_token"])
	      profile = graph.get_object('me')
	      MobileUser.create(profile, graph)
	    end
	    
	    #Asignación de puntaje random
	    r = Random.new
	    MobileUser.all.each do |user|
	      user.score = r.rand(500...4000) 
	      user.save
	    end
	end
	
end
