def start_env
  log = Logger.new(STDOUT)
  log.level = Logger::INFO
  begin
    context_list = Net::HTTP.get URI.parse(QCHECKER_SERVER+':'+QCHECKER_PORT.to_s+QCHECKER_CONTEXTS+'?all=true')
    context_list = JSON.parse context_list
  rescue
    fail_with APP_NAME, 'QChecker Server Not Available'
  end
  date = Time.now.to_datetime.to_s
  Dir.mkdir 'features/reports/'+date
  return log, date, context_list
end

def log_info text
  if DEBUG then LOG.info text end
end

def fail_with tag, text
  log_info '['+tag+'] '+text
  log_info ""
  fail text
end