/* 
********************************************************************
INSERIMENTO NUOVI CAMPI PER PROGRAMMA DI PRODUZIONE:
	- Causale di carico prodotto finito
	- Causale di scarico materie prime
********************************************************************
*/
ALTER TABLE [dbo].[PRODUZIONE] ADD 
	[TOPCAP] [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
	[TOPSCP] [varchar] (3) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[PRODUZIONE] WITH NOCHECK ADD 
	CONSTRAINT [DF_PRODUZIONE_TOPCAP] DEFAULT ('') FOR [TOPCAP],
	CONSTRAINT [DF_PRODUZIONE_TOPSCP] DEFAULT ('') FOR [TOPSCP]
go

UPDATE PRODUZIONE SET TOPCAP = ''
UPDATE PRODUZIONE SET TOPSCP = ''
