/** WebCrawler for QChecker Framework
 * can be used in many more applications
 * @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
 *   And PT Innovation
 * @author Joel Carvalho
 * @version 1.0.8.1 - 21/10/2015
 **/

// user vars
var user ={
    loginPage:          'http://www.qchecker.pt/login.php', // Login Page for Authentication
    username:           'admin',                            // Username for Authentication
    usernameInput:      '#login',                           // Selector for Username Input
    password:           'PTUbi_2015',                       // Password for Authentication
    passwordInput:      '[id="pass"]',                      // Selector for Password Input
    loginSubmit:        'input[name="submit"]',             // Selector for Login Submit
    captcha:            '',                                 // Captcha for Authentication
    captchaInput:       '',                                 // Selector for Captcha
    actionElements:     '',                             // Extra elements to check using default actions
    actionDrag:         '',                             // Selector for draggable elements
    draggingClass:      '',                             // Class "used" when drag occurs
    actionPopup:        '',                             // Selector for buttons
    modalBox:           '',                             // Selector for modal containers
    modalClose:         '',                             // Selector for close button
    modalEventShown:    '',                             // Event fired after show complete
    hackAnimations:     '',                             // Class to be removed from elements
    colors:[]
};
