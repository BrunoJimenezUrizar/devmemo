module AdvertisesHelper
	def show_in_android?(advertise)
		if (advertise.end_date>=DateTime.now and advertise.start_date<=DateTime.now and advertise.active)
	  		return true
		end
		return false
  	end
  	def causes_not_show_in_android(advertise)
  		problems=[]
  		if advertise.end_date<DateTime.now or advertise.start_date>DateTime.now
  			problems<<t('messages.general.p_isnt_in_date_time_range')
  		end
  		if not advertise.active
  			problems<<t('messages.general.p_isnt_active')
  		end
  		return problems
  	end
end
