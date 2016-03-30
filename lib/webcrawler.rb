# WebCrawler for QChecker Framework
# can be used in many more applications
# @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
#   And PT Innovation
# @author Joel Carvalho
# @version 1.0.8 - 26/09/2015

module WebCrawler
  require "rubygems"
  require 'capybara'
  require 'capybara-screenshot'
  require 'nokogiri'
  require 'logger'
  include Capybara::DSL

  class << self
    attr_accessor :session, :files, :vars, :execTime

    # Start new Session using specified driver and resolution
    # @param driver [string] driver name
    # @param resolution [string] resolution widthxheight
    # @author Joel Carvalho
    # @version 1.0.8 26/09/2015
    def startSession driver, config, resolution
      self::setVars config

      width, height = '-1', '-1'
      if resolution!=nil then width, height = resolution.split('x',2) end
      begin
        if width.to_i<=50 || height.to_i<=50 then raise "Exception" end
        width = width.to_i
        height = height.to_i
      rescue
        width, height = nil,nil
      end

      Capybara::current_driver = eval(":#{driver}")
      @session = Capybara::Session.new(Capybara::current_driver, Capybara::app)

      if width!=nil && height!=nil
        begin
          @session.driver.browser.manage.window.resize_to(width, height)
        rescue NoMethodError
          @session.driver.resize(width, height)
        end
      end
    end

    # Execute javascript code using webcrawler.js and jQuery if needed
    # @param script [String] javascript to execute
    # @author Joel Carvalho
    # @version 1.0.8 26/09/2015
    def executeScript script, webc=true
      if webc
        begin
          @session.execute_script @files[:cssutilities]+@files[:webcrawler_js]+script
        rescue
          @session.execute_script @files[:jquery]+@files[:jqueryui]+
              @files[:cssutilities]+@files[:webcrawler_js]+script
        end
      else
          @session.execute_script script
      end
    end

    # Set vars from specified config file and from constants
    # @param script [String]
    # @author Joel Carvalho
    # @version 1.0.8.3 11/11/2015
    def setVars config, n=3
      if n==0 then return nil end
      begin
        begin
          user_js=(File::read "#{WEBCRAWLER_DIR_JS}/user/#{config}.js")
        rescue
          user_js=(File::read "#{WEBCRAWLER_DIR_JS}/user/default.js")
        end
        wc_js=(File::read "#{WEBCRAWLER_DIR_JS}/#{JS_CONFIG}")+user_js+
            (File::read "#{WEBCRAWLER_DIR_JS}/#{JS_WEBCRAWLER}")

        @files={
            :config_js      => user_js,
            :webcrawler_js  => ';var WC="'+WEBCRAWLER+'";'+wc_js,
            :jquery         => (File::read "#{WEBCRAWLER_DIR_JS}/#{JS_JQUERY}"),
            :jqueryui       => (File::read "#{WEBCRAWLER_DIR_JS}/#{JS_JQUERYUI}"),
            :cssutilities   => ((File::read "#{WEBCRAWLER_DIR_JS}/#{JS_CSSUTILITIES}")+
            (File::read "#{WEBCRAWLER_DIR_JS}/#{JS_SELECTOR}"))
        }

        # Some of the Javascript vars
        @vars={
            :id             => WEBCRAWLER+'id',
            :actions        => WEBCRAWLER+'actions',
            :user           => WEBCRAWLER+'user',
            :visible        => WEBCRAWLER+'visible',
            :loginPage      => self::getJSValue('loginPage'),
            :username       => self::getJSValue('username'),
            :usernameInput  => self::getJSValue('usernameInput'),
            :password       => self::getJSValue('password'),
            :passwordInput  => self::getJSValue('passwordInput'),
            :loginSubmit    => self::getJSValue('loginSubmit'),
            :captcha        => self::getJSValue('captcha'),
            :captchaInput   => self::getJSValue('captchaInput'),
            :sleepLogin     => self::getJSValue('sleepLogin'),
            :sleepLoading   => self::getJSValue('sleepLoading')
        }
      rescue
        WebCrawler::setVars config, n-1
      end
    end

    def getJSValue var
      begin
        value = (@files[:config_js])[/#{var}:.*\'([^']*)\',/,1]
      rescue
        value = ''
      end
      return value
    end
  end
  require 'webcrawler/log'
  require 'webcrawler/dom'
  require 'webcrawler/version'
  require 'webcrawler/sedriver'
  require 'webcrawler/http'
end