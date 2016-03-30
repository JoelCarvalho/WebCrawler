# WebCrawler for QChecker Framework
# can be used in many more applications
# @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
#   And PT Innovation
# @author Joel Carvalho
# @version 1.0.8 - 25/09/2015
require 'sinatra'
require 'webcrawler'
require 'webcrawler/sedriver'
require './server/api'
require './'+WEBCRAWLER_DIR_CONFIG+'/drivers'  # Check and change this file content if needed
require './'+WEBCRAWLER_DIR_CONFIG+'/host'     # Check and change this file content if needed

def startHostConfig
  # WebCrawler Server (Host Configurations)
  host = Host.new
  @WEBCRAWLER_SERVER     = host.server
  @WEBCRAWLER_PORT       = host.port
end

def startMSG
  puts '**************************************'
  puts '** WebCrawler Server Starting...    **'
  puts '** '+WEBCRAWLER_VERSION+'           **'
  puts '**************************************',''
end

def manualDriverConfig
  drivers = Drivers.new
  drivers.localDrivers.each{ |driver|
    WebCrawler.setLocalDriver(driver[:driverType], driver[:driverName], driver[:driverPath])}
  drivers.remoteDrivers.each{ |driver|
    WebCrawler.setRemoteDriver(driver[:driverType], driver[:driverName], driver[:remoteSeleniumHub])}
end

def startDrivers
  begin
    # Auto Configurations from QChecker Server
    WebCrawler.setDBDrivers(QCHECKER_SERVER, QCHECKER_PORT, "#{QCHECKER_CONTEXTS}?host_name=#{VMCONFIG}")
  rescue
    # Manual Configurations, if QChecker Server is not reachable
    manualDriverConfig
  end
end

def startWebcrawlerServer
  # Disable Sinatra's default Webrick instance
  set :run, false
  Capybara.run_server = true
  Capybara.automatic_reload = true

  startMSG
  startHostConfig
  startDrivers

  begin
    Capybara.default_max_wait_time = 0
  rescue
    #skip
  end

  if RUN
    # When config.ru is executed from the command line (> ruby config.ru)
    set :port, @WEBCRAWLER_PORT+'80'
    set :bind, @WEBCRAWLER_SERVER
    enable  :sessions, :logging
    WebCrawlerApi.run!
  else
    # Only for OS with headless compatibility
    if RUBY_PLATFORM =~ /linux/ || RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /freebsd/
      require 'headless'
      headless = Headless.new(display: 100, reuse: true, destroy_at_exit: false)
      headless.start
    end
    run WebCrawlerApi
  end

  puts '','WebCrawler Server Started and Running'
end
