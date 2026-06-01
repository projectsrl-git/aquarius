
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PCK_DD] ADD 
		 ORD_FLGCEL [bit] NULL ,
		 ORD_AAPROD numeric (4,0) NULL,
	 	 ORD_CBFISC varchar (50) COLLATE Latin1_General_CI_AS NULL,
	 	 ORD_COORDL varchar (100) COLLATE Latin1_General_CI_AS NULL,
		 ORD_QTAGIAC numeric (17,3) NULL,
		 ORD_SCORMIN numeric (17,3) NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_PCK_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PCK_DD_ORD_FLGCEL] DEFAULT (0) FOR [ORD_FLGCEL],
	CONSTRAINT [DF_U_PCK_DD_ORD_AAPROD] DEFAULT ('0')    FOR [ORD_AAPROD],
	CONSTRAINT [DF_U_PCK_DD_ORD_CBFISC] DEFAULT ('    ') FOR [ORD_CBFISC],
	CONSTRAINT [DF_U_PCK_DD_ORD_COORDL] DEFAULT ('    ') FOR [ORD_COORDL],
	CONSTRAINT [DF_U_PCK_DD_ORD_QTAGIAC] DEFAULT ('0')    FOR [ORD_QTAGIAC],
	CONSTRAINT [DF_U_PCK_DD_ORD_SCORMIN] DEFAULT ('0')    FOR [ORD_SCORMIN]
go


UPDATE U_PCK_DD SET ORD_FLGCEL 	= 0 
UPDATE U_PCK_DD SET ORD_AAPROD 	= 0 
UPDATE U_PCK_DD SET ORD_CBFISC 	= SPACE(50) 
UPDATE U_PCK_DD SET ORD_COORDL 	= SPACE(100) 
UPDATE U_PCK_DD SET ORD_QTAGIAC	= 0 
UPDATE U_PCK_DD SET ORD_SCORMIN	= 0 