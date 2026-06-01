/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Magazzino", sottoscheda "Magazzini per produz.  macchine industriali" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Magazzino di destinazione per il materiale versato (semilavorato), e di origine per prodotto finito
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_MAGPMIVERSSL varchar (6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_MAGPMIVERSSL] DEFAULT ('')
GO
