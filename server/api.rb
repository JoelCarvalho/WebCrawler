# WebCrawler for QChecker Framework
# can be used in many more applications
# @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
#   And PT Innovation
# @author Joel Carvalho
# @version 1.0.8 - 29/09/2015
require 'sinatra'
require 'webcrawler'

class WebCrawlerApi < Sinatra::Application
  def setOptions context, options
    begin
      (driver, resolution) = context.split('+',2)

      url=request.fullpath.split(/\/https?\:\//)[1]
      (config, protocol) = options.split('/',2)
      exist=protocol.split(/https?\:\//)[1]
      if exist==nil
        url=config+'//'+url
        config = 'default'
      else
        url=(protocol.split(':/'))[0]+'://'+url
      end
      url.gsub! '{sharp}', '#'

      WebCrawler::startSession driver, config, resolution
    rescue Exception => e
      WebCrawler::logError 'webcrawler.error', e.message
      nil
    end
    url
  end

  def closeSession
    Thread.new 'closeSession' do
      timer = WebCrawler::startTime
      begin
          if (WebCrawler::session.driver.browser.browser != :internet_explorer)
            WebCrawler::session.reset_session!
          end
          WebCrawler::session.driver.quit
      rescue
        begin
          # for poltergeist error <undefined method 'browser'>
          WebCrawler::session.reset_session!
          WebCrawler::session.driver.quit
        rescue Exception => e
          WebCrawler::logError 'webcrawler.error', e.message
        end
      end
      WebCrawler::logTime timer, 'closeSession'
      Thread.exit
    end
  end

  def simpleCrawler context, options, n=3
    if n==0 then return nil end
    begin
      WebCrawler::execTime = WebCrawler::startTime
      url=self.setOptions context, options
      WebCrawler::getSimpleHTML url
      return WebCrawler::session.html
    rescue Errno::ECONNREFUSED
      sleep 50/1000
      self.simpleCrawler context, options, n-1
    end
  end

  #[{"url":"http://joelcarvalho.pt"},{"url":"http://www.ubi.pt"}]
  post '/api/http-status' do
    jSonList = JSON.parse request.body.read

    thread = WebCrawler::checkHTTPStatusList jSonList
    res = thread.join

    res.to_json
  end

  get '/api/version' do
    'WebCrawler Server '+WEBCRAWLER_VERSION
  end

  get '/api/original/*/*' do |context, url|
    t = Thread.new 'mainSession' do
      url=self.setOptions context,url
      WebCrawler::getOriginalHTML url
      @res = WebCrawler::session.html
      Thread.exit
    end
    t.join

    self.closeSession
    @res
  end

  get '/api/*/*' do |context, options|
    t = Thread.new 'mainSession' do
      begin
        @res = self.simpleCrawler context, options
      rescue => e
        WebCrawler::logError 'webcrawler.error', e.message
        status 500
      end
      Thread.exit
    end
    t.join

    self.closeSession
    @res
  end

end