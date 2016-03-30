# WebCrawler for QChecker Framework
# can be used in many more applications
# @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
#   And PT Innovation
# @author Joel Carvalho
# @version 1.0.8 - 25/09/2015

module WebCrawler
  @urlChecked = Array.new

  module HTTP
    attr_accessor :urlChecked
    attr_accessor :threads

    include Capybara::DSL

    def self.included(base)
      warn "including WebCrawler::HTTP in the global scope is not recommended!" if base == Object
      super
    end

    def self.extended(base)
      warn "extending the main object with WebCrawler::HTTP is not recommended!" if base == TOPLEVEL_BINDING.eval("self")
      super
    end

    def getURLRedirectResponse url
      res = Net::HTTP.get_response url
      if (res.code=="301" || res.code=="302") && res!=nil
        if res.header['location'].include?'http'
          res = WebCrawler::getURLRedirectResponse(URI(res.header['location']))
        elsif res.header['location'].index('/')===0
          redirect=URI(url.scheme+'://'+url.hostname+res.header['location'])
          res = WebCrawler::getURLRedirectResponse(redirect)
        end
      end
      res
    end

    def checkHTTPStatus threads, node_url
      threads << Thread.new(node_url) { |url|
        begin
          res = WebCrawler::getURLRedirectResponse(URI(url))
          @urlChecked.push({
                              :url => url,
                              :status => res.code})
        rescue Errno::ECONNREFUSED
          @urlChecked.push({
                               :url => url,
                               :status => '203'})
          WebCrawler::logInfo 'checkHTTPStatus', url+' | Status: 203'
        rescue SocketError
          @urlChecked.push({
                               :url => url,
                               :status => '404'})
          WebCrawler::logInfo 'checkHTTPStatus', url+' | Status: 404'
        rescue Exception => e
          @urlChecked.push({
                              :url => url,
                              :status => '404'})
          WebCrawler::logError 'checkHTTPStatus', url+' | '+e.to_s
        end
        Thread.exit
      }
    end

    def checkHTTPStatusList jSonList
      threads=Array.new
      @joinThreadsCounter=WEBCRAWLER_MAXTHREADS
      Thread.abort_on_exception = true

      @urlChecked=@urlChecked.uniq
      jSonList=jSonList.uniq

      jSonList.each{|e|
        if  @urlChecked.select{|c| c[:url]==e['url']} == []
          WebCrawler::checkHTTPStatus threads, e['url']
        end
        @joinThreadsCounter-=1
        if @joinThreadsCounter<=0
          @joinThreadsCounter=WEBCRAWLER_MAXTHREADS
          threads.each{|thread| thread.join}
        end
      }

      #timer = WebCrawler::startTime
      #WebCrawler::executeScript '$jQ(function(){pageLoad();});'
      #WebCrawler::logTime timer, 'executeScript', 'pageLoad()'

      threads.each{|thread| thread.join}

      @urlChecked.select{|c|
        jSonList.find{|e| e['url']==c[:url]}!=nil
      }
    end

    def getURLjSonList
      list = Array.new
      status="wc_http-status"

      doc = Nokogiri::HTML @session.html
      doc.xpath('//*[@'+status+'="0"][@href]').each do |node|
        list << {:url => node[:href]}
      end
      doc.xpath('//*[@'+status+'="0"][@src]').each do |node|
        list << {:url => node[:src]}
      end
      jSonList=JSON.parse list.to_json.to_s
      jSonList.uniq
    end

    def urlCheckedExist url
      (@urlChecked.index url)!=nil
    end
  end

  extend(WebCrawler::HTTP)
end