
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BOL_DD] ADD 
		 ORD_FLGCEL [bit] NULL ,
		 ORD_AAPROD numeric (4,0) NULL,
	 	 ORD_CBFISC varchar (50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_DD_ORD_FLGCEL] DEFAULT (0) FOR [ORD_FLGCEL],
	CONSTRAINT [DF_U_BOL_DD_ORD_AAPROD] DEFAULT ('0')    FOR [ORD_AAPROD],
	CONSTRAINT [DF_U_BOL_DD_ORD_CBFISC] DEFAULT ('    ') FOR [ORD_CBFISC]
go


UPDATE U_BOL_DD SET ORD_FLGCEL 	= 0 
UPDATE U_BOL_DD SET ORD_AAPROD 	= 0 
UPDATE U_BOL_DD SET ORD_CBFISC 	= SPACE(50) 