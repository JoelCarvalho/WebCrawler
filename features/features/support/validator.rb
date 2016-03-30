class Validator
  attr_accessor :url
  attr_accessor :doc

  def initialize
    @server       = QCHECKER_SERVER+":"+QCHECKER_PORT.to_s
    @api          = '/api/check.php'
    @id           = '825bf3e5033d3ed1da82580dc5b701796364953d'
    @guidelines   = DEFAULT_GUIDELINE
    @checkpoints  = DEFAULT_CHECK
    @res          = DEFAULT_RES
    @config       = DEFAULT_CONFIG
    @reportPath   = 'features/reports/'+DATE+'/'
    @allContexts  = CONTEXT_LIST
    self.setContext DEFAULT_CONTEXT
  end

  def getServiceURL
    service = @api+'?uri='+@url+'&id='+@id
    log_info "[WEBCRAWLER] URL => "+@url
    if @checkpoints == nil && @guidelines == nil
      fail_with APP_NAME, 'Nothing to Evaluate'
    end
    if @checkpoints != nil
      log_info "[WEBCRAWLER] Checkpoints => "+@checkpoints
      service += '&check='+@checkpoints
    end
    if @guidelines != nil
      log_info "[WEBCRAWLER] Guidelines => "+@guidelines
      service += '&guide='+@guidelines
    end
    if @context != nil
      log_info "[WEBCRAWLER] Context => "+@contextName
      service += '&context='+@context
    end
    if @res != nil
      log_info "[WEBCRAWLER] Resolution => "+@res
      service += '&resolution='+@res
    end
    if @config != nil
      log_info "[WEBCRAWLER] Config => "+@config
      service += "&config="+@config
    end
    service
  end

  def evaluate
    service=getServiceURL
    url=URI.encode(@server+service)
    @report = Net::HTTP.get URI.parse(url)
    @doc = Nokogiri::HTML @report
    checkReviewCrash
    saveReport
  end

  def saveReport text=''
    if @context!=nil
      @contextName = '_'+@contextName
    else
      @contextName =''
    end
    fileName = text+@url+@contextName+'_'+Time.now.to_i.to_s+'.html'
    fileName.sub! /http(s)?:\/\//, ''
    fileName.gsub! /[\/\s]/, '_'
    fileName.gsub! /(_UTC)|:|-/, ''
    File.write(@reportPath+fileName,
               @report.force_encoding('iso-8859-1').encode('utf-8'))
    log_info "["+APP_NAME+"] Report Saved => "+@reportPath+fileName
  end

  def setResolution res
    if res!=nil
      if /\d+x\d+/ =~ res then @res = res
      else
        fail_with APP_NAME, 'Invalid Resolution'
      end
    end
  end

  def setGuidelines guides
    if @guidelines != nil
      @guidelines +=','+guides
    else
      @guidelines = guides
    end
  end

  def setCheckpoints checks
    if @checkpoints != nil
      @checkpoints +=','+checks
    else
      @checkpoints = checks
    end
  end

  def setConfig config
    @config = config
  end

  def setURL url
    url.sub! /#/, '%23'
    url.gsub! /\+/, "%2B"
    url.gsub! /&/, "%26"
    @url = url
  end

  def setContext contextName
    @contextName=contextName
    if contextName==nil then return 0 end
    @allContexts.each do |context|
      if context['combined_name']==contextName
        @context=context['context_id']
        return 1
      end
    end
    fail_with APP_NAME, 'Invalid Context => ' + contextName
  end

  def checkReviewCrash
    crash=false
    begin
      if (((@doc.xpath('//span[@id="problems_found"]').first.content).to_i+
        (@doc.xpath('//span[@id="check_ok"]').first.content).to_i)==0) &&
        (@doc.xpath('//body[@htm-file]'))
        crash=true
        saveReport 'skipped_'
        msg='Quality Review Skipped Exception'
      end
    rescue
      crash=true
      saveReport 'crash_'
      msg='Quality Review Undefined Exception'
    end
    if crash
      fail_with APP_NAME, msg
    end
  end

  def checkNot type
    n=self.doc.xpath('//span[@id="'+type.downcase+'_problems"]').first.content
    if n.to_i != 0
      fail_with 'ERROR', n+' '+type+' Problems Found'
    else
      log_info '[PASSED] No '+type+' Problems Found'
      log_info ""
    end
  end

  def checkLess errors, type
    n=self.doc.xpath('//span[@id="'+type.downcase+'_problems"]').first.content
    if n.to_i >= errors.to_i
      fail_with 'ERROR', n+' '+type+' Problems Found'
    else
      log_info '[PASSED] '+n+' '+type+' Problems Found'
      log_info ""
    end
  end
end

