/** WebCrawler for QChecker Framework
 * can be used in many more applications
 * @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
 *   And PT Innovation
 * @author Joel Carvalho
 * @version 1.0.8.1 - 21/10/2015
 **/

// user vars
var user ={
    loginPage:          'http://10.112.150.10/Demos/Gmt/Account/Login',   // Login Page for Authentication
    username:           'admin',                            // Username for Authentication
    usernameInput:      '#UserName',                        // Selector for Username Input
    password:           'admin',                            // Password for Authentication
    passwordInput:      '#Password',                        // Selector for Password Input
    loginSubmit:        '.fx-login-submit .btn',            // Selector for Login Submit
    captcha:            '',                                 // Captcha for Authentication
    captchaInput:       '',                                 // Selector for Captcha
    sleepLogin:         '1000',                             // Sleep after Login (ms), Hack for IE
    actionElements:     '',                             // Extra elements to check using default actions
    actionDrag:         '',                             // Selector for draggable elements
    draggingClass:      '',                             // Class "used" when drag occurs
    actionPopup:        '',                             // Selector for buttons
    modalBox:           '',                             // Selector for modal containers
    modalClose:         '',                             // Selector for close button
    modalEventShown:    '',                             // Event fired after show complete
    hackAnimations:     '',                             // Class to be removed from elements
    colors:[
        '#004C59',                                      // Primary Color Class, ID, Color Code, etc.
        '.fx-product-slogan'                            // Secondary Color Class, ID, Color Code, etc.
        // Add more if needed
    ]
};
