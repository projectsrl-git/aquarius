
/*
*** Variabile gestita nella scheda "Altro", sottoscheda "Settaggi tecnici" del "form\menu_azi000.scx":
***		- Abilita la gestione della tabella LOGSQL per il MONITORAGGIO dei tempi di esecuzione delle QUERY SQL maggiori di <AZI_NSECMIN_LOGSQL> secondi
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_NSECMIN_LOGSQL NUMERIC(4,0) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_NSECMIN_LOGSQL] DEFAULT (0)
GO

UPDATE U_AZI_PC SET AZI_NSECMIN_LOGSQL = 2 WHERE (SELECT AZI_LOGSQL FROM U_AZI_PA) = 1