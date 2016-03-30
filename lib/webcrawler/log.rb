# WebCrawler for QChecker Framework
# can be used in many more applications
# @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
#   And PT Innovation
# @author Joel Carvalho
# @version 1.0.8 - 25/09/2015

module WebCrawler
  @log = Logger.new(STDOUT)

  if WEBCRAWLER_DEBUG
    @log.level = Logger::DEBUG
  else
    @log.level = Logger::WARN
  end

  @log.formatter = proc do |severity, datetime, progname, msg|
    date_format = datetime.strftime("%H:%M:%S")
    if severity=="INFO"
      "[#{date_format}] #{msg}\n"
    else
      "[#{date_format}] #{severity} #{msg}\n"
    end
  end

  module Log
    attr_accessor :log

    def self.included(base)
      warn "including WebCrawler::Log in the global scope is not recommended!" if base == Object
      super
    end

    def self.extended(base)
      warn "extending the main object with WebCrawler::Log is not recommended!" if base == TOPLEVEL_BINDING.eval("self")
      super
    end

    def startTime
      time=Array.new
      time<<Time.now
      time
    end

    def logTime t, name, infoText=nil
      t<<Time.now
      dif=(t[-1]-t[-2]).to_f*1000
      msg = ' %.2fms' % [dif.to_s]
      msg = infoText+' | '+msg if infoText!=nil
      WebCrawler::logInfo name, msg
      dif
    end

    def logInfo name, infoText=nil
      msg = '['+@session.__id__.to_s+']['+name+'] '
      msg += infoText if infoText!=nil
      @log.info msg
    end

    def logError name, infoText=nil
      msg = '['+@session.__id__.to_s+']['+name+'] '
      msg += infoText if infoText!=nil
      @log.error msg
    end
  end

  extend(WebCrawler::Log)
end