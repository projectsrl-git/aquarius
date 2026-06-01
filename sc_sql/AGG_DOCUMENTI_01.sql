
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
		TIPRENDO varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAT_TT_TIPRENDO] DEFAULT ('') FOR [TIPRENDO]
go



UPDATE U_FAT_TT SET TIPRENDO 	= ''

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
		TIPRENDO varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ORD_TT_TIPRENDO] DEFAULT ('') FOR [TIPRENDO]
go



UPDATE U_ORD_TT SET TIPRENDO 	= ''


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BOL_TT] ADD 
		TIPRENDO varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_BOL_TT_TIPRENDO] DEFAULT ('') FOR [TIPRENDO]
go



UPDATE U_BOL_TT SET TIPRENDO 	= ''



/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAP_TT] ADD 
		TIPRENDO varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAP_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAP_TT_TIPRENDO] DEFAULT ('') FOR [TIPRENDO]
go



UPDATE U_FAP_TT SET TIPRENDO 	= ''
