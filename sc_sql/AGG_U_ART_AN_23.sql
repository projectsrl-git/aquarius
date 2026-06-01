/***************************************************************
NUOVI CAMPI:
	- "Nr. giorni per scadenza di default"
	- "Nr. giorni di avviso prima della scadenza"
***************************************************************/

ALTER TABLE [dbo].[U_ART_AN] ADD 
	ART_NGGSCA numeric(10,0) NOT NULL CONSTRAINT [DF_U_ART_AN_ART_NGGSCA] DEFAULT (0),
	ART_NGSAVV numeric(10,0) NOT NULL CONSTRAINT [DF_U_ART_AN_ART_NGSAVV] DEFAULT (0)
go
