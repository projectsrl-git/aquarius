/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
	 	 RES_FATDAL varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_FATAL  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_FATDTR varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_RICDAL varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_RICAL  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_RICDTR varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_dtprvda  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_dtprva  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_dtelab varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_bildal varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_bilal varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_bolldal  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_bollal  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_bolldtr varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_riadal  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_riaal  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_riadtr varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_incdal  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_incal  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_incdtr varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_ammdal  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_ammal  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_ammdtr varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_orddal  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_ordal  varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_prodal   varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 RES_proal  varchar(10) COLLATE Latin1_General_CI_AS NULL


go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RES_OPER] WITH NOCHECK ADD 
	CONSTRAINT [DF_RES_OPER_RES_FATDAL] DEFAULT (' ') FOR [RES_FATDAL],
	CONSTRAINT [DF_RES_OPER_RES_FATAL]  DEFAULT (' ') FOR [RES_FATAL],
	CONSTRAINT [DF_RES_OPER_RES_FATDTR] DEFAULT (' ') FOR [RES_FATDTR],

	CONSTRAINT [DF_RES_OPER_RES_RICDAL] DEFAULT (' ') FOR [RES_RICDAL],
	CONSTRAINT [DF_RES_OPER_RES_RICAL]  DEFAULT (' ') FOR [RES_RICAL],
	CONSTRAINT [DF_RES_OPER_RES_RICDTR] DEFAULT (' ') FOR [RES_RICDTR],
	CONSTRAINT [DF_RES_OPER_RES_dtprvda] DEFAULT (' ') FOR [RES_dtprvda],
	CONSTRAINT [DF_RES_OPER_RES_dtprva]  DEFAULT (' ') FOR [RES_dtprva],
	CONSTRAINT [DF_RES_OPER_RES_dtelab] DEFAULT (' ') FOR [RES_dtelab],
	CONSTRAINT [DF_RES_OPER_RES_bildal] DEFAULT (' ') FOR [RES_bildal],
	CONSTRAINT [DF_RES_OPER_RES_bilal]  DEFAULT (' ') FOR [RES_bilal],
	CONSTRAINT [DF_RES_OPER_RES_bolldal] DEFAULT (' ') FOR [RES_bolldal],
	CONSTRAINT [DF_RES_OPER_RES_bollal]  DEFAULT (' ') FOR [RES_bollal],
	CONSTRAINT [DF_RES_OPER_RES_bolldtr] DEFAULT (' ') FOR [RES_bolldtr],
	CONSTRAINT [DF_RES_OPER_RES_riadal] DEFAULT (' ') FOR [RES_riadal],
	CONSTRAINT [DF_RES_OPER_RES_riaal]  DEFAULT (' ') FOR [RES_riaal],
	CONSTRAINT [DF_RES_OPER_RES_riadtr] DEFAULT (' ') FOR [RES_riadtr],
	CONSTRAINT [DF_RES_OPER_RES_incdal] DEFAULT (' ') FOR [RES_incdal],
	CONSTRAINT [DF_RES_OPER_RES_incal]  DEFAULT (' ') FOR [RES_incal],
	CONSTRAINT [DF_RES_OPER_RES_incdtr] DEFAULT (' ') FOR [RES_incdtr],
	CONSTRAINT [DF_RES_OPER_RES_ammdal] DEFAULT (' ') FOR [RES_ammdal],
	CONSTRAINT [DF_RES_OPER_RES_ammal]  DEFAULT (' ') FOR [RES_ammal],
	CONSTRAINT [DF_RES_OPER_RES_ammdtr] DEFAULT (' ') FOR [RES_ammdtr],
	CONSTRAINT [DF_RES_OPER_RES_orddal] DEFAULT (' ') FOR [RES_orddal],
	CONSTRAINT [DF_RES_OPER_RES_ordal]  DEFAULT (' ') FOR [RES_ordal],
	CONSTRAINT [DF_RES_OPER_RES_prodal] DEFAULT (' ') FOR [RES_prodal],
	CONSTRAINT [DF_RES_OPER_RES_proal] DEFAULT (' ') FOR [RES_proal]


go

UPDATE RES_OPER SET RES_FATDAL 	= SPACE(10)
UPDATE RES_OPER SET RES_FATAL 	= SPACE(10)
UPDATE RES_OPER SET RES_FATDTR 	= SPACE(10)
UPDATE RES_OPER SET RES_RICDAL 	= SPACE(10)
UPDATE RES_OPER SET RES_RICAL 	= SPACE(10)
UPDATE RES_OPER SET RES_RICDTR 	= SPACE(10)
UPDATE RES_OPER SET RES_dtprvda	= SPACE(10)
UPDATE RES_OPER SET RES_dtprva	= SPACE(10)
UPDATE RES_OPER SET RES_dtelab 	= SPACE(10)
UPDATE RES_OPER SET RES_bildal 	= SPACE(10)
UPDATE RES_OPER SET RES_bilal 	= SPACE(10)
UPDATE RES_OPER SET RES_bolldal	= SPACE(10)
UPDATE RES_OPER SET RES_bollal	= SPACE(10)
UPDATE RES_OPER SET RES_bolldtr	= SPACE(10)
UPDATE RES_OPER SET RES_riadal 	= SPACE(10)
UPDATE RES_OPER SET RES_riaal 	= SPACE(10)
UPDATE RES_OPER SET RES_riadtr 	= SPACE(10)
UPDATE RES_OPER SET RES_incdal 	= SPACE(10)
UPDATE RES_OPER SET RES_incal 	= SPACE(10)
UPDATE RES_OPER SET RES_incdtr 	= SPACE(10)
UPDATE RES_OPER SET RES_ammdal 	= SPACE(10)
UPDATE RES_OPER SET RES_ammal 	= SPACE(10)
UPDATE RES_OPER SET RES_ammdtr 	= SPACE(10)
UPDATE RES_OPER SET RES_orddal 	= SPACE(10)
UPDATE RES_OPER SET RES_ordal 	= SPACE(10)
UPDATE RES_OPER SET RES_prodal 	= SPACE(10)
UPDATE RES_OPER SET RES_proal 	= SPACE(10)
