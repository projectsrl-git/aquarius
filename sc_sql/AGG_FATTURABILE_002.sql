
/* TABELLA FATTURABILE_A  */

ALTER TABLE [dbo].[FATTURABILE_A] ADD 
		ORD_CONDET varchar (13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_A] WITH NOCHECK ADD 
		CONSTRAINT [DF_FATTURABILE_A_ORD_CONDET] DEFAULT ('') FOR [ORD_CONDET]
go

UPDATE FATTURABILE_A SET ORD_CONDET 	= ''

ALTER TABLE [dbo].[FATTURABILE_A] ADD 
	 ord_ccodet varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FATTURABILE_A] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_A_ord_ccodet] DEFAULT ('') FOR [ord_ccodet]
go

UPDATE FATTURABILE_A SET ord_ccodet = ''





/* TABELLA FATTURABILE_P  */

ALTER TABLE [dbo].[FATTURABILE_P] ADD 
		ORD_CONDET varchar (13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_P] WITH NOCHECK ADD 
		CONSTRAINT [DF_FATTURABILE_P_ORD_CONDET] DEFAULT ('') FOR [ORD_CONDET]
go

UPDATE FATTURABILE_P SET ORD_CONDET 	= ''

ALTER TABLE [dbo].[FATTURABILE_P] ADD 
	 ord_ccodet varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FATTURABILE_P] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_P_ord_ccodet] DEFAULT ('') FOR [ord_ccodet]
go

UPDATE FATTURABILE_P SET ord_ccodet = ''



/* TABELLA FATTURABILE_S  */

ALTER TABLE [dbo].[FATTURABILE_S] ADD 
		ORD_CONDET varchar (13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_S] WITH NOCHECK ADD 
		CONSTRAINT [DF_FATTURABILE_S_ORD_CONDET] DEFAULT ('') FOR [ORD_CONDET]
go

UPDATE FATTURABILE_S SET ORD_CONDET 	= ''

ALTER TABLE [dbo].[FATTURABILE_S] ADD 
	 ord_ccodet varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FATTURABILE_S] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_S_ord_ccodet] DEFAULT ('') FOR [ord_ccodet]
go

UPDATE FATTURABILE_S SET ord_ccodet = ''



/* TABELLA FATTURABILE_X  */

ALTER TABLE [dbo].[FATTURABILE_X] ADD 
		ORD_CONDET varchar (13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_X] WITH NOCHECK ADD 
		CONSTRAINT [DF_FATTURABILE_X_ORD_CONDET] DEFAULT ('') FOR [ORD_CONDET]
go

UPDATE FATTURABILE_X SET ORD_CONDET 	= ''

ALTER TABLE [dbo].[FATTURABILE_X] ADD 
	 ord_ccodet varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FATTURABILE_X] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_X_ord_ccodet] DEFAULT ('') FOR [ord_ccodet]
go

UPDATE FATTURABILE_X SET ord_ccodet = ''



/* TABELLA FATTURABILE_R  */

ALTER TABLE [dbo].[FATTURABILE_R] ADD 
		ORD_CONDET varchar (13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_R] WITH NOCHECK ADD 
		CONSTRAINT [DF_FATTURABILE_R_ORD_CONDET] DEFAULT ('') FOR [ORD_CONDET]
go

UPDATE FATTURABILE_R SET ORD_CONDET 	= ''

ALTER TABLE [dbo].[FATTURABILE_R] ADD 
	 ord_ccodet varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FATTURABILE_R] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_R_ord_ccodet] DEFAULT ('') FOR [ord_ccodet]
go

UPDATE FATTURABILE_R SET ord_ccodet = ''

