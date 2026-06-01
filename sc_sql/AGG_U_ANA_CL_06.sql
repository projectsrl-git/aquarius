/*    
**************************************************************************************************************
INSERIMENTO CAMPO "Avvisa in inserimento ordine se cliente con etichette personalizzate" IN ANAGRAFICA CLIENTI
**************************************************************************************************************
*/

ALTER TABLE [dbo].[U_ANA_CL] ADD 
	CLI_ETICUSTOM BIT NOT NULL CONSTRAINT [DF_U_ANA_CL_CLI_ETICUSTOM] DEFAULT (0)
go
