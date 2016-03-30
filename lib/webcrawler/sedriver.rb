# WebCrawler for QChecker Framework
# can be used in many more applications
# @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
#   And PT Innovation
# @author Joel Carvalho
# @version 1.0.8 - 25/09/2015

module WebCrawler
  module SeDriver
    require "net/http"
    require "json"
    require "selenium"
    require "selenium-webdriver"
    require "capybara/poltergeist"
    include Capybara::DSL

    def self.included(base)
      warn "including WebCrawler::SeDriver in the global scope is not recommended!" if base == Object
      super
    end

    def self.extended(base)
      warn "extending the main object with WebCrawler::SeDriver is not recommended!" if base == TOPLEVEL_BINDING.eval("self")
      super
    end

    def registerScreenshotDriver driverName
      Capybara::Screenshot.register_driver driverName do |driver, path|
        begin
          driver.browser.save_screenshot path
        rescue
          driver.render path #For Poltergeist
        end
      end
    end

    def setRemoteDriver driverType, driverName, seleniumURL
      caps = nil

      if driverType === :internet_explorer
        caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
        caps['ie.ensureCleanSession'] = true
      elsif driverType === :edge
        caps = Selenium::WebDriver::Remote::Capabilities.edge
      elsif driverType === :chrome
        caps = Selenium::WebDriver::Remote::Capabilities.chrome
      elsif driverType === :firefox
        caps = Selenium::WebDriver::Remote::Capabilities.firefox
      end

      if caps != nil
        caps['javascriptEnabled']       = true
        caps['nativeEvents']            = true
        caps['applicationCacheEnabled'] = false
        caps['singleWindow']            = false
        caps['ensureCleanSession']      = true
        caps['acceptSslCerts']          = true
        caps['locationContextEnabled']  = true
      end

      Capybara::register_driver driverName do |app|
        Capybara::Selenium::Driver.new(app,
          :browser => :remote,
          :url => seleniumURL,
          :desired_capabilities => caps)
      end

      WebCrawler::registerScreenshotDriver driverName
      puts "Remote Driver SET\t:#{driverName} - #{seleniumURL}"
    end

    def setLocalDriver driverType, driverName, driverPath=nil
      Capybara::register_driver driverName do |app|
        if driverType === :firefox and driverPath!=nil
          Selenium::WebDriver::Firefox::Binary.path = driverPath
        elsif driverType === :chrome and driverPath!=nil
          Selenium::WebDriver::Chrome.path = driverPath
        end

        if driverType === :poltergeist
          Capybara::Poltergeist::Driver.new(app, :js_errors => true, :debug => false,
            :phantomjs_options => ['--ignore-ssl-errors=yes', '--local-to-remote-url-access=yes'])
        else
          Capybara::Selenium::Driver.new(app, :browser => driverType)
        end
      end

      WebCrawler::registerScreenshotDriver driverName
      puts "Local Driver SET\t:#{driverName}"
    end

    def setDBDrivers server, port, api_url
      request = Net::HTTP.get_response(server, api_url, port)
      contexts = JSON.parse(request.body)

      contexts.each do |context|
        begin
          driverType=eval(context['driver_type'])
          driverName=eval(':'+context['driver_name'])

          if context['remote_host_id']!=nil
            WebCrawler.setRemoteDriver driverType, driverName, context['service_url']
          else
            if context['driver_path']!=nil
              WebCrawler.setLocalDriver driverType, driverName, context['driver_path']
            else
              WebCrawler.setLocalDriver driverType, driverName
            end
          end
        rescue
          WebCrawler::logError "webcrawler.sedriver","Driver ERROR\t\t:"+driverName
        end
      end
    end
  end

  extend(WebCrawler::SeDriver)
end