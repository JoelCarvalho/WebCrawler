/** WebCrawler for QChecker Framework
 * can be used in many more applications
 * @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
 *   And PT Innovation
 * @author Joel Carvalho
 * @version 1.0.8.1 - 26/10/2015
 **/

// user vars
var user ={
    loginPage:          'http://10.112.84.116',             // Login Page for Authentication
    username:           'netwin',                           // Username for Authentication
    usernameInput:      '#inputLogin',                      // Selector for Username Input
    password:           'netwin',                           // Password for Authentication
    passwordInput:      '#inputPassword',                   // Selector for Password Input
    loginSubmit:        '#login_button',                    // Selector for Login Submit
    captcha:            '',                                 // Captcha for Authentication
    captchaInput:       '',                                 // Selector for Captcha
    //captcha:            'pt',                               // Captcha for Authentication
    //captchaInput:       '#inputCaptcha',                    // Selector for Captcha
    sleepLogin:         '1000',                             // Sleep after Login (ms), Hack for IE
    actionElements:     '',                             // Extra elements to check using default actions
    actionDrag:         '',                             // Selector for draggable elements
    draggingClass:      '',                             // Class "used" when drag occurs
    actionPopup:        '[data-toggle="modal"]',        // Selector for buttons
    modalBox:           '.modal',                       // Selector for modal containers
    modalClose:         '.close',                       // Selector for close button
    modalEventShown:    'shown.bs.modal',               // Event fired after show complete
    hackAnimations:     'fade',                         // Class to be removed from elements
    colors:[
        '#0099AB',                                      // Primary Color Class, ID, Color Code, etc.
        '.fx-product-slogan'                            // Secondary Color Class, ID, Color Code, etc.
        // Add more if needed
    ]
};
