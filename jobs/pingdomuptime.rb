require 'rest-client'
require 'cgi'
require 'json'

api_key = ENV['PINGDOM_API_KEY'] || ''
user = ENV['PINGDOM_USER'] || ''
password = ENV['PINGDOM_PASSWORD'] || ''

# Add filter on check name
checkName = "dispo"

uptimeAvg = 0

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '10s', :first_in => 0 do |job|

  # Get the unix timestamps
  timeInSecond = 86400
  lastTime = (Time.now.to_i - timeInSecond )
  periodInHour = timeInSecond / 3600
  oldTimeInSecond = timeInSecond * 2
  lastOldTime = (Time.now.to_i - oldTimeInSecond )
  oldPeriodInHour = oldTimeInSecond / 3600
  nowTime = (Time.now.to_i)

  #Get Pingdom Id
  urlCheck = "https://#{CGI::escape user}:#{CGI::escape password}@api.pingdom.com/api/2.0/checks"
  responseCheck = RestClient.get(urlCheck, {"App-Key" => api_key})
  responseCheck = JSON.parse(responseCheck.body, :symbolize_names => true)

  uptime = 0
  oldUptime = 0
  count = 0

  responseCheck[:checks].map do |id|
    if (id[:name] =~ /#{checkName}/i )
      idCheck = "#{id[:id]}"

    count += 1

    # Calculation of Uptime for periodInHour
    urlUptime = "https://#{CGI::escape user}:#{CGI::escape password}@api.pingdom.com/api/2.0/summary.average/#{idCheck}?from=#{lastTime}&to=#{nowTime}&includeuptime=true"
    responseUptime = RestClient.get(urlUptime, {"App-Key" => api_key})
    responseUptime = JSON.parse(responseUptime.body, :symbolize_names => true)

    totalUp = responseUptime[:summary][:status][:totalup]
    totalUnknown = responseUptime[:summary][:status][:totalunknown]
    totalDown = responseUptime[:summary][:status][:totaldown]

    # Calculation of Uptime for oldPeriodInHour
    urlOldUptime = "https://#{CGI::escape user}:#{CGI::escape password}@api.pingdom.com/api/2.0/summary.average/#{idCheck}?from=#{lastOldTime}&to=#{lastTime}&includeuptime=true"
    responseOldUptime = RestClient.get(urlOldUptime, {"App-Key" => api_key})
    responseOldUptime = JSON.parse(responseOldUptime.body, :symbolize_names => true)

    totalOldUp = responseOldUptime[:summary][:status][:totalup]
    totalOldUnknown = responseOldUptime[:summary][:status][:totalunknown]
    totalOldDown = responseOldUptime[:summary][:status][:totaldown]

    # Test if it's work
    # uptime += (totalUp.to_f - (totalUnknown.to_f + rand(100)) ) * 100 / totalUp.to_f
    uptime += (totalUp.to_f - (totalUnknown.to_f + totalDown.to_f) ) * 100 / totalUp.to_f
    oldUptime += (totalOldUp.to_f - (totalOldUnknown.to_f + totalOldDown.to_f) ) * 100 / totalOldUp.to_f

    end
  end

  uptimeAvg = (uptime / count).round(2)
  oldUptimeAvg = (oldUptime / count).round(2)

  send_event('pingdomuptime', { current: uptimeAvg, last: oldUptimeAvg, moreinfo: "Last #{periodInHour} h and #{oldPeriodInHour} h" })
end
