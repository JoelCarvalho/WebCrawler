# WebCrawler for QChecker Framework
# can be used in many more applications
# @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
#   And PT Innovation
# @author Joel Carvalho
# @version 1.0.8.1 - 21/10/2015

# 'qchecker' => CentOS qchecker.pt (PT/UBI)
# 'dev' => Ubuntu qchecker-dev.pt (Joel Carvalho)
# make some modifications on /config files if needed

VMCONFIG  = 'dev'   # Host Configuration

# QChecker Configurations
QCHECKER_SERVER       = 'www.qchecker-dev.pt' #without PROTOCOL!
QCHECKER_PORT         = '80'
QCHECKER_CONTEXTS     = '/api/contexts.php'

# WEBCRAWLER Server Configurations
WEBCRAWLER            = 'wc_'   # Webcrawler Prefix
WEBCRAWLER_VERSION    = 'v1.0.8.2 - 03/11/2015 '
WEBCRAWLER_DIR_JS     = 'public/js'
WEBCRAWLER_DIR_IMG    = 'public/img'
WEBCRAWLER_DIR_CONFIG = 'config'
WEBCRAWLER_DEBUG      = true
WEBCRAWLER_MAXTHREADS = 150

# Javascript Files
JS_JQUERY             = "jquery-2.1.4.min.js"
JS_JQUERYUI           = "jquery-ui-1.11.4.min.js"
JS_CSSUTILITIES       = "cssutilities-0.99.1b.js"
JS_SELECTOR           = "selector.js"
JS_CONFIG             = "config.js"
JS_WEBCRAWLER         = "webcrawler.js"


# /!\ DO NOT CHANGE /!\
if __FILE__==$0
  RUN = true
else
  RUN = false
end

require './server/server'
startWebcrawlerServer
