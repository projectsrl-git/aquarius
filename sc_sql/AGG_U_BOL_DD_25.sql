/*    
*********************************************************************************************
AGGIORNAMENTO LARGHEZZA CAMPO ARTICOLO GRUPPO IN DETTAGLI DDT DI CONTO LAVORO A FORNITORE
*********************************************************************************************
*/

ALTER TABLE [dbo].[U_BOL_DD] ALTER COLUMN 
	 ORD_ARTCTL varchar (30) COLLATE Latin1_General_CI_AS NULL
go

