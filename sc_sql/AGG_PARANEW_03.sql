
/*
*** Variabili gestite per ottenere le formule di calcolo relative alle manutenzioni impianti dai listini
*/
        
ALTER TABLE [DBO].[PARANEW] ADD 
	PAR_A2 bit NOT NULL CONSTRAINT [DF_PARANEW_PAR_A2] DEFAULT (0),
	PAR_A3 bit NOT NULL CONSTRAINT [DF_PARANEW_PAR_A3] DEFAULT (0),
	PAR_C2 bit NOT NULL CONSTRAINT [DF_PARANEW_PAR_C2] DEFAULT (0)
GO
