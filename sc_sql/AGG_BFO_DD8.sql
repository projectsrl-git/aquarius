
ALTER TABLE [dbo].[U_BFO_DD] ADD 
	 ORD_NRLINT numeric(8) NULL,
	 ORD_CODFIS varchar(16) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_NRLINT] DEFAULT (0) FOR [ORD_NRLINT],
	CONSTRAINT [DF_U_BFO_DD_ORD_CODFIS] DEFAULT ('') FOR [ORD_CODFIS]
go

UPDATE U_BFO_DD SET ORD_NRLINT = 0
UPDATE U_BFO_DD SET ORD_CODFIS = SPACE(16)
