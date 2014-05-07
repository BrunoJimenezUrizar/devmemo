module ReportsHelper
	def show_in_android?(report)
		if (report.end_date>=DateTime.now and report.start_date<=DateTime.now and report.active)
	  		return true
		end
		return false
  	end
  	def causes_not_show_in_android(report)
  		problems=[]
  		if report.end_date<DateTime.now or report.start_date>DateTime.now
  			problems<<t('messages.general.p_isnt_in_date_time_range')
  		end
  		if not report.active
  			problems<<t('messages.general.p_isnt_active')
  		end
  		return problems
  	end
end
