/** WebCrawler for QChecker Framework
 * can be used in many more applications
 * @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
 *   And PT Innovation
 * @author Joel Carvalho
 * @version 1.0.8 - 26/09/2015
 **/

// Every reference to jQuery $() should be $jQ() to avoid any kind of conflict
$jQ=jQuery.noConflict();
var colorsList=[];                         // Hack for System Colors
var active='mousedown.webcrawler';         // Hack for active elements, DONT REMOVE!!!

/**
 * Add Unique Attribute ID to each element
 * @author Joel Carvalho
 * @version 1.0.8.1 04/11/2015
 */
function setWebcrawlerID(){
    $jQ('*').each(function(i){
        tag=$jQ(this).prop("tagName");
        if (tag!=="BR" && tag!=="STYLE")
            $jQ(this).attr(vars.id, i+1);
    });
}

/**
 * Get Page Loading time from the begin of the request to de end of page load
 * @return {number}
 * @author Joel Carvalho
 * @version 1.0.1 14/05/2015
 */
function getLoadingTime(){
    var t = performance.timing;
    return(t.loadEventEnd - t.requestStart);
}

/**
 * Get Request Time including redirect, app cache, dns and tcp
 * @return {number}
 * @author Joel Carvalho
 * @version 1.0.1 14/05/2015
 */
function getRequestTime(){
    var t = performance.timing;
    return(t.requestStart - t.navigationStart);
}

/**
 * Get HTTP Status of specified URL
 * @param {int} id Webcrawler ID
 * @param {string} url URL to check
 * @return {number} url http status
 * @author Joel Carvalho
 * @version 1.0.1 15/05/2015
 */
function getHTTPStatus(id, url){
    var http = new XMLHttpRequest();
    try{
        http.timeout = 50;
        http.open('HEAD', url, true); // true => async
        http.onreadystatechange= function() {
            setHTTPStatus(id, http.status);
        };
        http.send();
    }catch(error){}
}

/**
 * set HTTP status of specified Webcrawler id
 * @param {int} id Webcrawler ID
 * @param {string} status HTTP Status
 * @author Joel Carvalho
 * @version 1.0.1 18/05/2015
 */
function setHTTPStatus(id, status){
    $jQ('*['+vars.id+'="'+id+'"]').attr(vars.httpStatus, status);
}

/**
 * Update all http-status from json
 * @param {string} json
 * @author Joel Carvalho
 * @version 1.0.1 20/05/2015
 */
function updateHTTPStatusJSON(json){
    var obj=JSON.parse(json);
    for (i=0;i<obj.length;i++){
        var url=obj[i].url;
        var status=obj[i].status;
        $jQ('[href="'+url+'"]').attr(vars.httpStatus, status);
        $jQ('[src="'+url+'"]').attr(vars.httpStatus, status);
    }
}

/**
 * Add 0 to HTTP Status attribute of each valid href
 * and try to get the real status code
 * ignore anchors, mailto:... amd javascript:...
 * @author Joel Carvalho
 * @version 1.0.8.1 29/10/2015
 */
function startLinkStatus(){
    var a = document.createElement('a'); // Hack to extract absolute url
    $jQ('a[href]').each(function() {
        if ($jQ(this).attr('href').length > 0 &&
            $jQ(this).attr('href').search('javascript:')==-1 &&
            $jQ(this).attr('href').search('mailto:')==-1 &&
            $jQ(this).attr('href').search('#')!=0) {
                a.href = $jQ(this).attr('href');
                setLink($jQ(this),'href', a.href);
        }
    });
}

/**
 * Add 0 to HTTP Status attribute of each image
 * and try to get the real status code
 * @author Joel Carvalho
 * @version 1.0.1 15/05/2015
 */
function startImgStatus(){
    var img = document.createElement('img'); // Hack to extract absolute url
    $jQ('img').each(function(){
        img.src=$jQ(this).attr('src');
        setLink($jQ(this),'src', img.src);
    });
}

/**
 * Add 0 to HTTP Status attribute of each javascript file and css file
 * and try to get the real status code
 * @author Joel Carvalho
 * @version 1.0.1 18/05/2015
 */
function startFileStatus(){
    // Javascript Files
    var file = document.createElement('script'); // Hack to extract absolute url
    $jQ('script[src]').each(function(){
        file.src=$jQ(this).attr('src');
        setLink($jQ(this),'src', file.src);
    });
    // CSS Files
    file = document.createElement('link'); // Hack to extract absolute url
    $jQ('link[href]').each(function(){
        file.href=$jQ(this).attr('href');
        setLink($jQ(this),'href', file.href);
    });
}

/**
 * Set new src/href link
 * and try to get the real status code
 * @author Joel Carvalho
 * @version 1.0.1 01/07/2015
 */
function setLink(e, attr, nv){
    e.attr(vars.link, e.attr(attr));
    e.attr(attr, nv); // Absolute URL
    setHTTPStatus(e.attr(vars.id), '0');
    getHTTPStatus(e.attr(vars.id), nv);
}

/**
 * Set HTTP Status of every url (a href, img, script and link) to zero
 * @return {number}
 * @author Joel Carvalho
 * @version 1.0.1 14/05/2015
 */
function startHTTPStatus(){
    startLinkStatus();
    startImgStatus();
    startFileStatus();
}

/**
 * Set Loading Time and Request Time as Body Attributes
 * @author Joel Carvalho
 * @version 1.0.1 14/05/2015
 */
function setTimeStatus(){
    $jQ('body').attr(vars.loadingTime, getLoadingTime());
    $jQ('body').attr(vars.requestTime, getRequestTime());
}

/**
 * Set System Colors
 * @author Joel Carvalho
 * @version 1.0.3 01/06/2015
 */
function setSystemColors(){
    var str = colorsList.toString();
    $jQ('body').attr(vars.systemColors, str.replace(/;,+/g, ";"));
}

/**
 * Set the visibility of each element
 * @author Joel Carvalho
 * @version 1.0.2 21/05/2015
 */
function setVisibility(){
    $jQ(':visible').each(function(){
        $jQ(this).attr(vars.visible, "true");
    });
    $jQ(':hidden').each(function(){
        $jQ(this).attr(vars.visible, "false");
    });
}

/**
 * Add Inner Width and Inner Height in the specified element (this)
 * if it is different from the outer width and height of the element
 * @param {element} e html element
 * @param {int} width Outer Width
 * @param {int} height Outer Height
 * @author Joel Carvalho
 * @version 1.0.1 14/05/2015
 */
function setInnerSizes(e, width, height){
    w=e.outerWidth();
    h=e.outerHeight();
    if (w>0 && w!=width) e.attr(vars.outWidth, w);
    if (h>0 && h!=height) e.attr(vars.outHeight, h);
}

/**
 * Add Height, Width, and Inner Height and Width if needed
 * @author Joel Carvalho
 * @param {element} e html element
 * @version 1.0.3 01/06/2015
 */
function setSizes(e){
    w=e.width();
    h=e.height();
    e.attr(vars.width, w);
    e.attr(vars.height, h);
    setInnerSizes(e, w, h);
}

/**
 * Set the top and left position of each visible element
 * @author Joel Carvalho
 * @param {element} e html element
 * @version 1.0.3 01/06/2015
 */
function setPositions(e){
    offset= e.offset();
    position=e.position();
    e.attr(vars.posTop, offset.top.toFixed(0));
    e.attr(vars.posLeft, offset.left.toFixed(0));
    e.attr(vars.posTopRel, position.top.toFixed(0));
    e.attr(vars.posLeftRel, position.left.toFixed(0));
}

/**
 * Set hover handler
 * @author Joel Carvalho
 * @version 1.0.4 23/06/2015
 */
var setHoverAction = function(event){
    event.stopImmediatePropagation();
    $jQ(this).off('mouseover.webcrawler');
    if (DEBUG) console.log('['+$jQ(this).attr(vars.id)+'] mouseover.webcrawler');
    setColorInfo($jQ(this),':hover');
    //return false;
};

/**
 * Set active handler function (mousedown for chrome or mouseup for firefox)
 * @author Joel Carvalho
 * @version 1.0.4 23/06/2015
 */
var setActiveAction = function(event){
    event.stopImmediatePropagation();
    $jQ(this).off(active);
    if (DEBUG) console.log('['+$jQ(this).attr(vars.id)+'] '+active);
    setColorInfo($jQ(this),':active');
    return false;
};

/**
 * Set default click handler function
 * @author Joel Carvalho
 * @version 1.0.8.3 18/11/2015
 */
var setClickAction = function(event){
    event.stopImmediatePropagation();
    if (DEBUG) console.log('['+$jQ(this).attr(vars.id)+'] click.webcrawler');
    $jQ(this).attr(vars.actions,'checked');
    $jQ(this).trigger('mouseout.visited');
    return false;
};

/**
 * Set stop navigation click handler function
 * @author Joel Carvalho
 * @version 1.0.8.3 16/11/2015
 */
var setStopNavigation = function(event){
    event.stopImmediatePropagation();
    return false;
};

/**
 * Set user click handler function for popups
 * @author Joel Carvalho
 * @version 1.0.8 28/09/2015
 */
var setUserClickAction = function(event){
    var userAction=$jQ(this).attr(vars.userActions);
    if (!userAction || userAction=='checked') {
        event.stopImmediatePropagation();
        $jQ(this).off('click.user');
    }
    if (DEBUG) console.log('['+$jQ(this).attr(vars.id)+'] click.user');
    $jQ(this).attr(vars.userActions,'checked');
    $jQ(this).trigger('mouseout.visited');
    return true;
};

/**
 * Set user mousemove handler for drag and drop elements
 * @author Joel Carvalho
 * @version 1.0.8 30/09/2015
 */
var setUserDragAction = function(){
    if ($jQ(this).is(user.draggingClass)){
        setColorInfo($jQ(this),':drag');
        setColorInfo($jQ(this).find('a'),':drag');
        $jQ(this).attr(vars.userActions, 'dragged');
        $jQ(this).off("mousemove.user");
    }
    return true;
};

/**
 * Set mouseout handler function for visited action
 * @author Joel Carvalho
 * @version 1.0.4 23/06/2015
 */
var setVisitedAction = function(event){
    event.stopImmediatePropagation();
    $jQ(this).off('mouseout.visited');
    if (DEBUG) console.log('['+$jQ(this).attr(vars.id)+'] mouseout.visited');
    setVisitedColor($jQ(this));
    return false;
};

/**
 * Predict visited colors using CSSUtilities
 * Values can be erroneous
 * @author Joel Carvalho
 * @version 1.0.4 25/06/2015
 */
function setVisitedColor(e){
    var c = new Object();
    c.fg=e.attr(vars.fgColor+':visited');
    c.bg=e.attr(vars.bgColor+':visited');
    if (c.fg!=null && c.bg!=null)
        setConstrastInfo(e, c, ':visited');
    return false;
}

/**
 * Set constrast colors info for specified element, colors and info
 * @param {element} e html element
 * @param {object} c c.fg and c.bg
 * @param {string} info string
 * @author Joel Carvalho
 * @version 1.0.4 26/06/2015
 */
function setConstrastInfo(e, c, info){
    e.attr(vars.colorBDif+info, getColorBrightnessDif(c.bg, c.fg));
    e.attr(vars.colorContrast+info, getColorContrast(c.bg, c.fg));
    e.attr(vars.colorContrastRL+info, getColorContrastRelativeLuminance(c.bg, c.fg));
}

/**
 * Set color info for specified element and info
 * @param {element} e html element
 * @param {string} info string
 * @author Joel Carvalho
 * @version 1.0.4 24/06/2015
 */
function setColorInfo(e, info){
    var c = getColors(e);
    if (c.fg!=null && c.bg!=null){
        e.attr(vars.fgColor+info, c.fg);
        e.attr(vars.bgColor+info, c.bg);
        setConstrastInfo(e,c,info);
    }
}

/**
 * Get Background and Foreground Colors of specified element
 * @author Joel Carvalho
 * @param {element} e html element
 * @version 1.0.4 24/06/2015
 */
function getColors(e){
    return {
        fg: e.css("color"),
        bg: getBgColor(e)
    };
}

/**
 * Set Actions Events
 * @author Joel Carvalho
 * @param {element} e html element
 * @version 1.0.8.3 18/11/2015
 */
function setActions(e) {
    var tag = e.prop('tagName');
    if (e.attr(vars.actions)!='user' && e.attr(vars.actions)!='true') {
        if (tag == 'B' || tag == 'APPLET' || tag == 'AUDIO'
            || tag == 'VIDEO' || tag=='IFRAME' || tag=='P' ||
            tag=='BR' || tag=='OPTION' || tag=='SCRIPT' || tag=='FORM')
            return false;
    }
    if ((e.children().length==0 && e.attr(vars.actions)!='user') || e.attr(vars.actions)=='true')
        e.attr(vars.actions, (e.is(':visible'))?"true":"not_reachable");
    else if (e.attr(vars.actions)!='user')
        e.attr(vars.actions, "not_propagated");
    e.on('mouseover.webcrawler', setHoverAction);
    e.on(active, setActiveAction);
    if (e.attr(vars.actions)=='true'){
        e.off('click.stopnav');
        e.on('click.webcrawler', setClickAction);
    }
    if (tag=='A')
        e.on('mouseout.visited', setVisitedAction);
}

/**
 * Get RGB object from a string
 * @author Joel Carvalho
 * @param {string} value
 * @version 1.0.3 09/06/2015
 */
function getRGB(value){
    var res = new Object();
    var rgb=value.replace(/[^\d,.]/g, '').split(',');
    res.r=getNumber(rgb[0]);
    res.g=getNumber(rgb[1]);
    res.b=getNumber(rgb[2]);
    res.op=false;
    if (rgb.length>3){
        res.o=getNumber(rgb[3]);
        res.op=true;
    }
    else
        res.o=1;
    return res;
}

/**
 * Get Color Brightness (YIQ values)
 * @author Joel Carvalho
 * @param {string} value
 * @version 1.0.3 09/06/2015
 */
function getColorBrightness(value){
    var rgb = getRGB(value);
    return getNumber(((rgb.r*299)+(rgb.g*587)+(rgb.b*114))/1000);
}

/**
 * Get color Brightness Difference between two colors
 * @author Joel Carvalho
 * @param {string} color1 first color
 * @param {string} color2 second color
 * @version 1.0.3 09/06/2015
 */
function getColorBrightnessDif(color1, color2){
    return getNumber(Math.abs(getColorBrightness(color1)-getColorBrightness(color2)));
}

/**
 * Get color Contrast between two colors
 * @author Joel Carvalho
 * @param {string} color1 first color
 * @param {string} color2 second color
 * @version 1.0.3 09/06/2015
 */
function getColorContrast(color1, color2){
    rgb1=getRGB(color1);
    rgb2=getRGB(color2);
    return getNumber(Math.abs(rgb1.r-rgb2.r)+Math.abs(rgb1.g-rgb2.g)+Math.abs(rgb1.b-rgb2.b));
}

/**
 * Get color Contrast with Relative Luminance between two colors
 * @author Joel Carvalho
 * @param {string} color1 first color
 * @param {string} color2 second color
 * @version 1.0.3 09/06/2015
 */
function getColorContrastRelativeLuminance(color1, color2){
    var rgb=[],l=[];
    rgb[0] = getRGB(color1);
    rgb[1] = getRGB(color2);

    rgb.forEach(function(e,i){
        e.r=convertLC(e.r);
        e.g=convertLC(e.g);
        e.b=convertLC(e.b);
        l[i]=(0.2126*e.r)+(0.7152*e.g)+(0.0722*e.b);
    });
    if (l[0]>l[1])
        return getNumber((l[0]+0.05)/(l[1]+0.05));
    return getNumber((l[1]+0.05)/(l[0]+0.05));
}

/**
 * convert RGB value to be applied in Relative Luminance equation
 * @author Joel Carvalho
 * @param {string} color1 first color
 * @param {string} color2 second color
 * @version 1.0.3 11/06/2015
 */
function convertLC(value){
    value=value/255;
    if (value<=0.03928)
        return (getNumber(value/12.92));
    return (getNumber(Math.pow((value+0.055)/1.055,2.4)));
}

/**
 * Get decimal number or integer
 * @author Joel Carvalho
 * @param {float} value
 * @version 1.0.3 11/06/2015
 */
function getNumber(value){
    value=parseFloat(value).toFixed(2);
    if (value%1!=0)
        return value;
    return parseInt(value);
}


/**
 * Get Background Color
 * @author Joel Carvalho
 * @param {element} e html element
 * @version 1.0.8.1 28/10/2015
 */
function getBgColor(e){
    var bg = e.css('background-color');
    //use first opaque parent bg if element is transparent
    if(bg == 'transparent' || bg == 'rgba(0, 0, 0, 0)') {
        e.attr(vars.noBgColor, true);
        e.parents().each(function(){
            bg = $jQ(this).css('background-color');
            if(bg != 'transparent' && bg != 'rgba(0, 0, 0, 0)') return false;
        });
        if(bg == 'transparent' || bg == 'rgba(0, 0, 0, 0)'){
            bg = DEFAULT_BG;
        }
    }
    var rgb=getRGB(bg);
    if (!rgb.op) e.attr(vars.noOpacityBgColor, true);
    return "rgba("+rgb.r+", "+rgb.g+", "+rgb.b+", "+rgb.o+")";
}

/**
 * Set Font Size and Style
 * @author Joel Carvalho
 * @param {element} e html element
 * @version 1.0.3 01/06/2015
 */
function setFontInfos(e){
    var fs= e.css("font-size");
    fs=parseFloat(fs).toFixed(0);
    e.attr(vars.fontSize, fs);
    e.attr(vars.fontFamily, e.css("font-family").replace(/\"|\'/g,''));
}

/**
 * Set Border Style
 * @author Joel Carvalho
 * @param {element} e html element
 * @version 1.0.8.3 11/11/2015
 */
function setBorder(e){
    var br=e.css("border-radius");
    if (br=="") br=e.css("border-top-left-radius");
    if (br=="") br=e.css("-webkit-border-top-left-radius");
    if (br=="") br=e.css("-moz-border-radius-topleft");
    br=parseFloat(br).toFixed(0);
    if (!isNaN(br))
      e.attr(vars.borderRadius, br);
}

/**
 * Set text-transform
 * @author Joel Carvalho
 * @param {element} e html element
 * @version 1.0.8.1 29/10/2015
 */
function setTextTransform(e){
    var tt= e.css("text-transform");
    e.attr(vars.textTransform, e.css("text-transform"));
}

/**
 * Set z-index
 * @author Joel Carvalho
 * @param {element} e html element
 * @version 1.0.3 01/06/2015
 */
function setZIndex(e){
    if (e.css("z-index")!="auto")
        e.attr(vars.zIndex, e.css("z-index"));
}

/**
 * Set All Visible Elements Info, like colors, positions, and more
 * @author Joel Carvalho
 * @version 1.0.8.3 18/11/2015
 */
function setAllVisibleElementsInfo(){
    $jQ('body *:visible, ['+vars.actions+'="user"]').each(function() {
        var e = $jQ(this);
        var tag = e.prop("tagName");
        if(tag!="BR" && tag!="SCRIPT" && tag!="IFRAME"){
            setActions(e);
            setColorInfo(e,'');
            setFontInfos(e);
            setSizes(e);
            setPositions(e);
            setBorder(e);
            setTextTransform(e);
            setZIndex(e);
        }
    });
}

/**
 * Define when active elements can be trigered
 * mouseup for Firefox (I dont know why) and mousedown for Chrome and PhantomJS
 * @author Joel Carvalho
 * @version 1.0.2 19/06/2015
 */
function hackUserAgent(){
    if (navigator.userAgent.search('Firefox')!==-1)
        active='mouseup.webcrawler';
}

/**
 * Configure, start CSSUtilities and set visited colors info
 * @author Joel Carvalho
 * @version 1.0.4 26/06/2015
 */
function startCSSInfo(){
    if ($jQ('body').attr('vlink')!=null){
        var a = document.createElement('a');
        $jQ(a).css('color', $jQ('body').attr('vlink'));

        $jQ('a').each(function(){
            $jQ(this).attr(vars.fgColor+':visited', $jQ(a).css('color'));
            $jQ(this).attr(vars.bgColor+':visited', getBgColor($jQ(this)));
        });
    }
    else{
        CSSUtilities.define('async', true);
        CSSUtilities.init(function() {
            css_=CSSUtilities.getCSSStyleSheetRules('*', 'properties, selector');
            css_.forEach(function (el) {
                user.colors.forEach(function (sc,i){
                    if (el.selector.search(sc)>=0){
                        var text='SystemColor'+(i+1)+':'+el.properties['color']+';';
                        colorsList.push(text);
                        if (DEBUG) console.log('[SystemColor.css] '+el.selector+' => '+text);
                        user.colors[i]=null;
                    }
                });

                // This solution can produce erroneous information's
                // todo: Consider order/hierarchy in future
                if (el.selector.search(':visited')>=0){
                    var c=['color','background-color'];
                    var a=document.createElement('a');
                    $jQ(a).css('color', DEFAULT_VISITED);

                    if (el.properties!=null) {
                        c.forEach(function (attr) {
                            if (el.properties[attr] != null) {
                                found=true;
                                $jQ(a).css(attr, el.properties[attr]);
                            }
                        });
                    }

                    $jQ(el.selector.replace(':visited','')).each(function(){
                        var bg= $jQ(a).css('background-color');
                        if (bg==null || bg=='')
                            $jQ(a).css('background-color',getBgColor($jQ(this)));
                        $jQ(this).attr(vars.fgColor+':visited', $jQ(a).css('color'));
                        $jQ(this).attr(vars.bgColor+':visited', $jQ(a).css('background-color'));
                    });
                }
            });
            user.colors.forEach(function (sc,i){
                if (sc!=null){
                    var a=document.createElement('a');
                    $jQ(a).css('background-color', sc);
                    var text='SystemColor'+(i+1)+':'+getBgColor($jQ(a))+';';
                    colorsList.push(text);
                    if (DEBUG) console.log('[SystemColor] '+text);
                }
            });
        });
    }
}

/**
 * Set Childs and Parents List
 * @author Joel Carvalho
 * @version 1.0.6 07/07/2015
 */
function setChildsAndParents(){
    $jQ('*').each(function(){
        var ids = $jQ(this).parents().map(function(){return $jQ(this).attr(vars.id)}).get().join(",");
        $jQ(this).attr(vars.parents,ids);
        ids = $jQ(this).children().map(function(){return $jQ(this).attr(vars.id)}).get().join(",");
        $jQ(this).attr(vars.childs,ids);
        var qt=0;
        if (ids!="")
            qt = ids.split(',').length;
        $jQ(this).attr(vars.childsQt,qt);
    });
}

/**
 * Everything to be done before pageLoad() method
 * @author Joel Carvalho
 * @version 1.0.2 21/05/2015
 */
function pagePreload(){
    setWebcrawlerID();
    setChildsAndParents();
    startHTTPStatus();
    pageLoad();
}

/**
 * Set WebCrawler Extra infos
 * @author Joel Carvalho
 * @version 1.0.8 29/09/2015
 */
function setWebCrawlerExtraInfos(furl,session,exec){
    $jQ('body').attr(vars.htmlFile,furl+'.html');
    $jQ('body').attr(vars.imgFile,furl+'.png');
    $jQ('body').attr(vars.htmlFile+':original',furl+'_original.html');
    $jQ('body').attr(vars.imgFile+':original',furl+'_original.png');
    $jQ('body').attr(vars.session,session);
    $jQ('body').attr(vars.executionTime,exec);
}

/**
 * Set the quantity of css and script files
 * @author Joel Carvalho
 * @version 1.0.6 21/07/2015
 */
function setNumScripts(){
    $jQ('body').attr(vars.nscript,$jQ('script[src]').length);
    $jQ('body').attr(vars.ncss,$jQ('link[href]').length);
}

/**
 * Set more elements to be used with native actions
 * @author Joel Carvalho
 * @version 1.0.8.3 18/11/2015
 */
function setUserActions(){
    $jQ(user.actionElements).each(function(){
        $jQ(this).attr(vars.actions, 'true');
    });
    $jQ(user.actionClick).each(function(){
        var e = $jQ(this);
        e.attr(vars.actions, 'user');
        e.attr(vars.userActions, 'click');
        e.off('click.stopnav');
        e.parents().off('click.stopnav');
        e.on('click.user',setUserClickAction);
    });
    $jQ(user.actionPopup).each(function(){
        var e = $jQ(this);
        e.attr(vars.actions, 'user');
        e.attr(vars.userActions, 'popup');
        e.off('click.stopnav');
        e.parents().off('click.stopnav');
        e.on('click.user',setUserClickAction);
    });
    $jQ(user.modalBox).each(function(){
        $jQ(this).find(user.modalClose).each(function(){
            var e = $jQ(this);
            e.attr(vars.userActions, 'popup.close');
            e.off('click.stopnav');
            e.parents().off('click.stopnav');
        });
        $jQ(this).on(user.modalEventShown, function (){
            $jQ(this).find('*').each(function(){
                var e = $jQ(this);
                var tag = e.prop("tagName");
                if(tag!="BR" && tag!="SCRIPT" && tag!="IFRAME"){
                    setColorInfo(e,'');
                    setFontInfos(e);
                    setSizes(e);
                    setPositions(e);
                    setBorder(e);
                    setTextTransform(e);
                    setZIndex(e);
                    $jQ(this).attr(vars.visible + ':action', $jQ(this).is(':visible'));
                }
            });
        });
    });
    $jQ(user.actionDrag).each(function() {
        $jQ(this).attr(vars.actions, 'user');
        $jQ(this).attr(vars.userActions, 'drag');
        $jQ(this).attr(vars.userActions + ':counter', 0);
        $jQ(this).on('mousemove.user',setUserDragAction);
    });
}

/**
 * Hack for clearing animations from Bootstrap
 * To be improved and carefully used
 * @author Joel Carvalho
 * @version 1.0.8 26/09/2015
 */
function hackRemoveAnimations(){
    if (user.hackAnimations!='')
        $jQ('.'+user.hackAnimations).removeClass(user.hackAnimations);
}

/**
 * Hack for disabling submit buttons
 * To be improved and carefully used
 * @author Joel Carvalho
 * @version 1.0.8.1 21/10/2015
 */
function hackDisableSubmit(){
    $jQ('input[type="submit"]').each(function() {
        $jQ(this).attr(WC+'onclick',$jQ(this).attr('onclick'));
        $jQ(this).attr('onclick','return false;');
    });
}

/**
 * Prevent page to reload and navigation handlers to be executed
 * @author Joel Carvalho
 * @version 1.0.8.3 18/11/2015
 */
function hackActions(){
    // Hack disabling navigation for all elements (visible or not)
    $jQ('body *').each(function(){
        $jQ(this).on('click.stopnav',setStopNavigation);
    });
    // Hack disabling navigation for AngularJS
    $jQ(user.hackAngularJS).each(function() {
        if($jQ(this).parent().find(user.actionElements).length==0)
            $jQ(this).replaceWith($jQ(this).clone());
    });
}

/**
 * Add some code to the report to be used on QChecker report
 * @author Joel Carvalho
 * @version 1.0.8.3 20/11/2015
 */
function hackFrameScroll(){
    //document.head.appendChild("<style>html,body{height:auto;width: auto;}body{overflow-y:auto;}</style>");
    var s=document.createElement("script");
    s.type="text/javascript";
    s.src="/js/jquery-2.1.4.min.js";
    document.body.appendChild(s);
    var ss =document.createElement("script");
    ss.type="text/javascript";
    ss.src='/js/pym.min.js';
    document.body.appendChild(ss);
}

/**
 * Everything to be done after page load
 * @author Joel Carvalho
 * @version 1.0.8.3 13/11/2015
 */
function pageLoad(){
    $jQ('body').zIndex(); // jQuery UI Check
    window.onbeforeunload=function(){return '';}; // Hack to prevent any page.reload
    startCSSInfo();
    hackUserAgent();
    hackRemoveAnimations();
    hackDisableSubmit();
    hackActions();
    setNumScripts();
    setTimeStatus();
    setSystemColors();
    setVisibility();
    setUserActions();
    setAllVisibleElementsInfo();
    hackFrameScroll();
}
