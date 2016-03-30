/** WebCrawler for QChecker Framework
 * can be used in many more applications
 * @note Release (RELiablE And SEcure Computation Group) at University of Beira Interior
 *   And PT Innovation
 * @author Joel Carvalho
 * @version 1.0.8.1 - 21/10/2015
 **/

// user vars
var user ={
    loginPage:          'http://10.112.45.32:8080/Portal',  // Login Page for Authentication
    username:           'aoliveira',                        // Username for Authentication
    usernameInput:      '',                                 // Selector for Username Input
    password:           'aoliveira',                        // Password for Authentication
    passwordInput:      '',                                 // Selector for Password Input
    loginSubmit:        '',                                 // Selector for Login Submit
    captcha:            '',                                 // Captcha for Authentication
    captchaInput:       '',                                 // Selector for Captcha
    actionElements:     '',                             // Extra elements to check using default actions
    actionDrag:         '.fx-sortable,.fx-draggable',   // Selector for draggable elements
    draggingClass:      '.fx-tab-dragging',             // Class "used" when drag occurs
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
