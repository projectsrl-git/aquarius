
/*
*** POPOLAMENTO DEI SEGUENTI PARAMETRI AZIENDALI X GESTIONE WOOCOMMERCE (KUBERTH)
***	WordPress REST API Authentication
***		- Nome sito
***		- Username
***		- Password
***		- Consumer key
***		- Consumer secret
*/

UPDATE U_AZI_PB SET
	AZI_WPSITO = 'https://www.kuberth.com',
	AZI_WPUSER = 'projectsrl',
	AZI_WPPASS = 'U7#gRXdzyqCbUH7S!m3B*x*o',
	AZI_WPCKEY = 'ck_df2c7bce1458bc8fbdf95a7a36cf98e277ec52cc',
	AZI_WPCSECRET = 'cs_13974d397c64fc3a8d6fc6ec8389d78ea97441fa'


SELECT 
	AZI_WPSITO,
	AZI_WPUSER,
	AZI_WPPASS,
	AZI_WPCKEY,
	AZI_WPCSECRET
FROM U_AZI_PB