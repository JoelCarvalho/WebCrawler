# WebCrawler for QChecker Framework
# can be used in many more applications
# @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
#   And PT Innovation
# @author Joel Carvalho
# @version 1.0.8 - 25/09/2015

module WebCrawler
  module DOM
    include Capybara::DSL

    def self.included(base)
      warn "including WebCrawler::DOM in the global scope is not recommended!" if base == Object
      super
    end

    def self.extended(base)
      warn "extending the main object with WebCrawler::DOM is not recommended!" if base == TOPLEVEL_BINDING.eval("self")
      super
    end

    # Get page html with some modifications from the specified url
    # @param url [String] url to check
    # @return [String] HTML of url
    # @see webcrawler.js and config.js
    # @author Joel Carvalho
    # @version 1.0.8 18/09/2015
    def getSimpleHTML url
      if execLogin===false
        raise "Login Failed"
      end
      WebCrawler::getOriginalHTML url
      file  = "#{WEBCRAWLER_DIR_IMG}/#{Capybara::current_driver.to_s}/#{Time.now.to_i.to_s}_#{@session.__id__.to_s}"
      WebCrawler::saveFilesReport "#{file}_original"

      timer = WebCrawler::startTime
      WebCrawler::executeScript 'pagePreload();'
      jSonList = WebCrawler::getURLjSonList
      res   = WebCrawler::checkHTTPStatusList jSonList
      WebCrawler::logTime timer, 'executeScript', 'pagePreload()'

      if ((@vars[:sleepLoading]).to_i)>0
        sleep(((@vars[:sleepLoading]).to_i.to_f)/1000)
      end

      WebCrawler::defaultActions
      WebCrawler::executeScript 'window.onbeforeunload=null;', false
      WebCrawler::userActions
      WebCrawler::userActionsDrag

      timer = WebCrawler::startTime
      furl  = file.sub 'public/', QCHECKER_SERVER+'/'
      furl  = furl.sub 'www.', 'http://webcrawler.'
      execTime = WebCrawler::logTime @execTime, 'executionTime'
      extra = "setWebCrawlerExtraInfos('#{furl}','#{@session.__id__.to_s}','#{execTime.to_i.to_s}')"
      lastScript ="updateHTTPStatusJSON('#{res.to_json.to_s}');#{extra};"
      WebCrawler::executeScript lastScript
      WebCrawler::logTime timer, 'executeScript', 'updateHTTPStatusJSON() & setWebCrawlerExtraInfos()'
      WebCrawler::saveFilesReport file
    end

    # Save html and printscreen of session
    # @author Joel Carvalho
    # @version 1.0.8.3 11/11/2015
    def saveFilesReport fileName, n=5
      if n==0 then return nil end
      begin
        @session.save_page "#{fileName}.html"
        @session.save_screenshot "#{fileName}.png"
      rescue
        sleep 50/1000
        WebCrawler::saveFilesReport fileName, n-1
      end
    end

    # Login into the system to visit
    # @author Joel Carvalho
    # @version 1.0.8.1 21/10/2015
    def execLogin
      timer = WebCrawler::startTime
      login=true
      begin
        if @vars[:loginPage]=='' then return nil end
        @session.visit @vars[:loginPage]
        @session.driver.find_css(@vars[:usernameInput]).first.set @vars[:username]
        @session.driver.find_css(@vars[:passwordInput]).first.set @vars[:password]
        if @vars[:captcha]!=''
          @session.driver.find_css(@vars[:captchaInput]).first.set @vars[:captcha]
        end
        @session.driver.find_css(@vars[:loginSubmit]).first.click
      rescue Selenium::WebDriver::Error::WebDriverError ,
          Selenium::WebDriver::Error::UnknownError => e
        WebCrawler::logError 'webcrawler.driver', e.message
        login=false
      rescue => e
        WebCrawler::logError 'webcrawler.login', e.message
        login=false
      end
      WebCrawler::logTime timer, 'login.visit', @vars[:loginPage]
      if ((@vars[:sleepLogin]).to_i)>0
        sleep(((@vars[:sleepLogin]).to_i.to_f)/1000)
      end
      return login
    end

    # Get page html from the specified url
    # @param url [String] url to check
    # @return [String] HTML of url
    # @author Joel Carvalho
    # @version 1.0.8 18/09/2015
    def getOriginalHTML url
      timer = WebCrawler::startTime
      res = WebCrawler::getURLRedirectResponse(URI(url))
      if res.code=="403" || res.code =="404"
        puts '[HTTP STATUS] '+res.code
        raise "Page Not Found"
      end

      begin
        @session.visit url
      rescue Selenium::WebDriver::Error::WebDriverError ,
          Selenium::WebDriver::Error::UnknownError => e
        WebCrawler::logError 'webcrawler.driver', e.message
      rescue Capybara::Poltergeist::JavascriptError => e
        WebCrawler::logError 'webcrawler.javascript', e.message
      end
      WebCrawler::logTime timer, 'page.visit', url
    end

    # Execute default actions over the session
    # Events triggered by this actions: MouseEnter, MouseDown, MouseUp, MouseOut
    # @author Joel Carvalho
    # @version 1.0.8.3 09/11/2015
    def defaultActions
      timer = WebCrawler::startTime
      @session.driver.find_css("[#{@vars[:actions]}='true']").each do |el|
        begin
          if el.native[@vars[:actions]]!='checked'
            WebCrawler::logInfo 'default.action', 'id => '+el.native[@vars[:id]]+', tag => '+el.native.tag_name
            begin
              el.native.send_keys :mouseover
            rescue Capybara::Poltergeist::MouseEventFailed,
                Capybara::Poltergeist::JavascriptError => e
              WebCrawler::logError 'default.action.error', e.message
            rescue
              begin
                action = @session.driver.browser.action
                action.click el.native
                action.perform
              rescue
                begin
                  el.click    #Slow Alternative if everything fail
                rescue => e
                  WebCrawler::logError 'default.action.error', e.message
                end
              end
            end
          end
        rescue Selenium::WebDriver::Error::UnhandledAlertError
          begin
            @session.driver.browser.switch_to.alert.dismiss
            WebCrawler::logError 'default.action', 'Javascript Alert Closed'
          rescue
            #skip
          end
        rescue => e
          WebCrawler::logError 'default.action.error', e.message
        end
      end
      WebCrawler::logTime timer, 'defaultActions'
    end

    # Execute user popup actions (open and close) over the session
    # @author Joel Carvalho
    # @version 1.0.8.3 18/11/2015
    def userActions
      timer = WebCrawler::startTime
      @session.all("[#{@vars[:user]}='popup'], [#{@vars[:user]}='click']", :visible=>true).each do |el|
        begin
          event = el.native[@vars[:user]].to_s
          if event!='checked'
              WebCrawler::logInfo 'user.'+event, 'id => '+el.native[@vars[:id]]+', tag => '+el.native.tag_name
              el.click          # Click (and Open Modal)
              if event=='popup'
                close=@session.first("[#{@vars[:user]}='popup.close']",
                  :visible =>true)
                if close!=nil
                  WebCrawler::logInfo 'user.popup.close'+event, 'id => '+close.native[@vars[:id]]+', tag => '+close.native.tag_name
                  close.click   # Close Modal
                end
              end
          end
        rescue Selenium::WebDriver::Error::UnhandledAlertError
          begin
            @session.driver.browser.switch_to.alert.dismiss
            WebCrawler::logError 'user.click', 'Javascript Alert Closed'
          rescue
            #skip
          end
        rescue Capybara::Poltergeist::JavascriptError
          begin
          @session.find('body').native.send_keys :escape
          rescue
            #skip
          end
        rescue => e
          WebCrawler::logError 'user.error', e.message
        end
      end
      WebCrawler::logTime timer, 'userActions'
    end

    # Execute drag actions over the session
    # @author Joel Carvalho
    # @version 1.0.8 30/09/2015
    def userActionsDrag
      timer = WebCrawler::startTime
      @session.driver.find_css("[#{@vars[:user]}='drag']").each do |el|
        begin
          if el.native[@vars[:user]]!='checked'
            WebCrawler::logInfo 'user.drag', 'id => '+el.native[@vars[:id]]
            action = @session.driver.browser.action
            count=0
            while el.native[@vars[:user]]!='dragged' && (++count)<5
              action.click_and_hold(el.native).perform
              action.move_by(10, 10).perform
              action.release.perform
            end
          end
        rescue => e
          WebCrawler::logError 'user.drag.error', e.message
        end
      end
      WebCrawler::logTime timer, 'userActions.dragObjects'
    end
  end

  extend(WebCrawler::DOM)
end