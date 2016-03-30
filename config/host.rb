# WebCrawler for QChecker Framework
# can be used in many more applications
# @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
#   And PT Innovation
# @author Joel Carvalho
# @version 1.0.8 - 25/09/2015

class Host
  attr_accessor :name, :server, :port

  def initialize
    eval(VMCONFIG)
  end

  def qchecker
    @server = 'webcrawler.qchecker.pt'
    @port   = '80'
  end

  def dev
    @server = 'webcrawler.qchecker-dev.pt'
    @port   = '80'
  end

end