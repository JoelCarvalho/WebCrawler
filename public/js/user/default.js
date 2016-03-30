/** WebCrawler for QChecker Framework
 * can be used in many more applications
 * @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
 *   And PT Innovation
 * @author Joel Carvalho
 * @version 1.0.8.1 - 21/10/2015
 **/

// user vars
var user ={
    // Login Info
    loginPage:          '',             // Login Page for Authentication
    username:           '',             // Username for Authentication
    usernameInput:      '',             // Selector for Username Input
    password:           '',             // Password for Authentication
    passwordInput:      '',             // Selector for Password Input
    loginSubmit:        '',             // Selector for Login Submit
    captcha:            '',             // Captcha for Authentication
    captchaInput:       '',             // Selector for Captcha
    sleepLogin:         '',             // Sleep after Login (ms), Hack for IE

    // Popup Info
    actionPopup:        '',             // Selector for buttons
    modalBox:           '',             // Selector for modal containers
    modalClose:         '',             // Selector for close button
    modalEventShown:    '',             // Event fired after show complete

    // Drag Info
    actionDrag:         '',             // Selector for draggable elements
    draggingClass:      '',             // Class "used" when drag occurs

    // Click Info
    actionClick:        '',             // Selector for extra click elements (without sequence)

    // Special Hacks
    sleepLoading:       '1000',         // Hack for AngujarJS and slow pages loading
    actionElements:     '',             // Extra elements to check using default actions
    hackAnimations:     '',             // Class to be removed from elements
    hackAngularJS:      '[ng-click]',   // Selector for interrupting click events on AngularJS
    // System Colors, Global vars from JS to Functions
    colors:[
        '#000',                           // Primary Color Class, ID, Color Code, etc.
        '#FFF'                            // Secondary Color Class, ID, Color Code, etc.
        // Add more if needed
    ]
};
