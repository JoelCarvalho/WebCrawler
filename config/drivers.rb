# WebCrawler for QChecker Framework
# can be used in many more applications
# @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
#   And PT Innovation
# @author Joel Carvalho
# @version 1.0.8 - 25/09/2015

class Drivers
  attr_accessor :localDrivers, :remoteDrivers

  def initialize
    @localDrivers = Array.new
    @remoteDrivers = Array.new

    eval(VMCONFIG)
  end

  def qchecker
  remoteSeleniumHub = 'http://selenium.nibiru.di.ubi.pt/wd/hub'
  
  @localDrivers.push({
       :driverType => :firefox,
       :driverName => :Firefox,
       :driverPath => '/usr/lib64/firefox/firefox'})
  @localDrivers.push({
       :driverType => :chrome,
       :driverName => :Chrome,
       :driverPath => '/opt/google/chrome/google-chrome'})
  @localDrivers.push({
       :driverType => :poltergeist,
       :driverName => :PhantomJS,
       :driverPath => nil})
  end

  def dev
    remoteSeleniumHub = 'http://www.qchecker-dev.pt:4444/wd/hub'

    @localDrivers.push({
        :driverType => :firefox,
        :driverName => :Firefox17,
        :driverPath => '/opt/firefox/firefox17/firefox-bin'})
    @localDrivers.push({
        :driverType => :firefox,
        :driverName => :Firefox,
        :driverPath => '/usr/lib/firefox/firefox'})
    @localDrivers.push({
        :driverType => :chrome,
        :driverName => :Chrome,
        :driverPath => '/opt/google/chrome/google-chrome'})
    @localDrivers.push({
        :driverType => :poltergeist,
        :driverName => :PhantomJS,
        :driverPath => ''})

    @remoteDrivers.push({
        :driverType => :internet_explorer,
        :driverName => :RemoteIE,
        :remoteSeleniumHub => remoteSeleniumHub})
    @remoteDrivers.push({
        :driverType => :chrome,
        :driverName => :RemoteChrome,
        :remoteSeleniumHub => remoteSeleniumHub})
    @remoteDrivers.push({
        :driverType => :firefox,
        :driverName => :RemoteFirefox,
        :remoteSeleniumHub => remoteSeleniumHub})
  end

end
