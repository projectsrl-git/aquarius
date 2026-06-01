
/*
*** Variabili gestite per variabile "Tipo docum. per creaz. autofatture XML" in gestione parametri - Top
*/
        
ALTER TABLE [DBO].[PARANEW] ADD
	TIPODOCAUTXML varchar(4) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_PARANEW_TIPODOCAUTXML] DEFAULT ('')
	
GO
