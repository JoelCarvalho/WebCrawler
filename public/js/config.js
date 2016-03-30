/** WebCrawler for QChecker Framework
 * can be used in many more applications
 * @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
 *   And PT Innovation
 * @author Joel Carvalho
 * @version 1.0.8 - 28/09/2015
 **/

var DEBUG   = true;

// Default vars, use carefully
var DEFAULT_BG          = 'rgb(255, 255, 255)';     // White by Default
var DEFAULT_VISITED     = 'rgb(85, 26, 139)';       // Purple by Default

var vars = {
    id:                 WC+'id',                    // Element Identifier
    actions:            WC+'actions',               // FLAG Element for development
    userActions:        WC+'user',                  // FLAG Element for development
    executionTime:      WC+'execution-time',        // WebCrawler Execution Time
    loadingTime:        WC+'loading-time',          // Page Loading Time
    requestTime:        WC+'request-time',          // Page Request Time
    nscript:            WC+'nscript',               // Page Scripts Quantity
    ncss:               WC+'ncss',                  // Page CSS Quantity
    session:            WC+'session-id',            // Webcrawler Session ID
    htmlFile:           WC+'html-file',             // Html file saved after webcrawler execution
    imgFile:            WC+'img-file',              // Img file saved after webcrawler execution
    link:               WC+'link',                  // Element Original LINK (src/href value)
    childs:             WC+'childs',                // Element Childs ID List
    childsQt:           WC+'childs-qt',             // Element Childs Quantity
    parents:            WC+'parents',               // Element Parents ID List
    height:             WC+'height',                // Element Height
    outHeight:          WC+'outer-height',          // Element Outer Height
    width:              WC+'width',                 // Element Width
    outWidth:           WC+'outer-width',           // Element Outer Width
    httpStatus:         WC+'http-status',           // Element HTTP Status when available
    posTop:             WC+'top',                   // Element Absolute Top Position
    posTopRel:          WC+'top:relative',          // Element Relative Top Position
    posLeft:            WC+'left',                  // Element Left Position
    posLeftRel:         WC+'left:relative',         // Element Relative Left Position
    visible:            WC+'visible',               // Element visibility
    fgColor:            WC+'color',                 // Element Foreground Color
    bgColor:            WC+'background-color',      // Element Background Color
    tabOrder:           WC+'tab-order',             // Element Tab Order
    fontFamily:         WC+'font-family',           // Element font Style
    fontSize:           WC+'font-size',             // Element Font Size
    zIndex:             WC+'z-index',               // Element Z-Index
    systemColors:       WC+'system-colors',         // System Colors List
    colorBDif:          WC+'color-bdif',            // Color Brightness Difference
    colorContrast:      WC+'color-contrast',        // Color Contrast
    colorContrastRL:    WC+'color-contrast-rl',     // Color Contrast With Relative Luminance
    borderRadius:       WC+'border-radius',         // Element Border Radius
    textTransform:      WC+'text-transform',        // Element Text Transform
    noBgColor:          WC+'no-background',         // Set true when Element don't have background-color
    noOpacityBgColor:   WC+'no-opacity-background', // Set true when Element don't have opacity in background-color
    clickOriginal:      WC+'click-original'         // Element original click attribute
};
