
/*!
 Notification envoyée lorsque l'authentification de l'utilisateur s'est correctement déroulée.
 */
extern NSString *const PEGLoginSucceedNotification;
/*!
 Notification envoyée lorsque l'authentification a échouée.
 */
extern NSString *const PEGLoginFailedNotification;
/*!
 Notification envoyée lorsque l'utilisateur se déconnecte de l'application.
 */
extern NSString *const PEGLogoutNotification;
/*!
 Notification envoyée lorsque la déconnexion de l'utilisateur a été forcée suite à un rejet par le serveur.
 */
extern NSString *const PEGLogoutForcedNotification;


typedef enum
{
	ADXStatusUpdate = 0,
	ADXStatusCreate = 1
} ADXStatus;