# encoding: UTF-8
class StatisticsController < ApplicationController
handles_sortable_columns
before_filter :get_university

  def show
  @universities=University.all 
	@university = University.find(params[:university_id])
  authorize! :read, @university, :message => 'Acceso denegado.'
  @campuses = @university.campuses
  @from_date= 1.month.ago
  @to_date= Time.now

# crea la tabla de datos para el gráfico
  data_table = GoogleVisualr::DataTable.new

#crea las columnas de la tabla
  data_table.new_column('string', 'Basurero' )
	data_table.new_column('number', 'Reciclajes')
	
	# query para obtener la informacion de reciclaje de la universidad
  data = RecycleInfo.where(university_id:params[:university_id])
  has_data=0
# por cada tipo de basurero de una universidad, cuenta el numero de reciclajes y agrega una fila en la tabla
	Type.all.each do |type|
		
    if request.get?
		  recycles= data.where({type_id:type.id,  created_at: 1.month.ago.beginning_of_day..Date.today.end_of_day}).count
    else
      @from_date= Date.parse(params[:from])
      @to_date = Date.parse(params[:to])
      recycles= data.where({type_id:type.id,  created_at: @from_date.beginning_of_day..@to_date.end_of_day}).count
    end
    data_table.add_row([type.name, recycles])
    has_data+=recycles
  end

  # opciones del gráfico
  if has_data > 0
	option = { height: 440, title: 'Reciclaje por tipo de basurero', is3D: true}
  else
  option = { height: 440, title: 'No hay datos entre las fechas seleccionadas', is3D: true} 
  end
  #variable q contiene el grafico de torta
	@chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)

  end

  def campus
  @universities=University.all 
  @university = University.find(params[:university_id])
  authorize! :read, @university, :message => 'Acceso denegado.'
  data_table = GoogleVisualr::DataTable.new

  data_table.new_column('string', 'Basurero' )
	data_table.new_column('number', 'Reciclajes')


  data = RecycleInfo.where({campus_id:params[:campus]})
  @pors= Por.where({campus_id:params[:campus]})
  @campus= Campus.find(params[:campus])
  has_data=0
  
  Type.where(university_id:params[:university_id]).each do |type|
    
    @from_date= Date.parse( params[:from])
    @to_date = Date.parse( params[:to])
    recycles= data.where({type_id:type.id,  created_at: @from_date.beginning_of_day..@to_date.end_of_day}).count
    data_table.add_row([type.name, recycles])
    has_data+=recycles
    end


	if has_data > 0
  option = { height: 440, title: 'Reciclaje por tipo de basurero', is3D: true}
  else
  option = { height: 440, title: 'No hay datos entre las fechas seleccionadas', is3D: true} 
  end
	@chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)
  
  end

  def pors


  data_table = GoogleVisualr::DataTable.new

  data_table.new_column('string', 'Basurero' )
  data_table.new_column('number', 'Reciclajes')
 
  dump= Dump.where({por_id:params[:por]}).pluck(:id)
  data = RecycleInfo.where({dump_id:dump})
  has_data=0
  
  @campus= Campus.find(params[:campus])
  authorize! :read, @campus, :message => 'Acceso denegado.'
  @pors= Por.where({campus_id:params[:campus]})
  
 
  Type.all.each do |type|
    
    @from_date= Date.parse( params[:from])
    @to_date = Date.parse( params[:to])
    recycles= data.where({type_id:type.id,  created_at: @from_date.beginning_of_day..@to_date.end_of_day}).count
    data_table.add_row([type.name, recycles])
    has_data+=recycles
    end


  if has_data > 0
  option = { height: 440, title: 'Reciclaje por tipo de basurero', is3D: true}
  else
  option = { height: 440, title: 'No hay estadísticas para los datos seleccionados', is3D: true} 
  end
  @chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)
 
  end
  
  def events
    @universities= University.all
    @university = University.find(params[:university_id])
    authorize! :read, @university, :message => 'Acceso denegado.'
    @campuses= @university.campuses
    @events=Hash.new
    
    Event.all.each do |event|
      if event.end_date < Time.now
        @events[event]= [event.campus_id, Attendee.where(event_id:event.id).count]
      else
        @events[event]= [event.campus_id, "No ha finalizado"]
      end
    end


  end

  def get_university
    @university = University.find(params[:university_id])
  end

end
