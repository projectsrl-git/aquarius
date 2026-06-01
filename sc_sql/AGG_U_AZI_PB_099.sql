/* 
***************************************************************************************************
INSERIMENTO CAMPI PER GESTIONE SFONDO NEI FORM PER GESTIRE MEGLIO IL POSIZIONAMENTO DEL CURSORE
***************************************************************************************************
*/    

ALTER TABLE [dbo].[U_AZI_PB] ADD 
	AZI_FORMBCKCOL NUMERIC(10,2) NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_FORMBCKCOL] DEFAULT (0)
go


UPDATE U_AZI_PB SET AZI_FORMBCKCOL =  16644315.00
