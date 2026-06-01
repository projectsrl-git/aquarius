
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_DD] ADD 
		 ORD_FLGCEL [bit] NULL ,
	 	 ORD_SERBOL varchar (3) COLLATE Latin1_General_CI_AS NULL,
		 ORD_AAPROD numeric (4,0) NULL,
	 	 ORD_SERNUM varchar (3) COLLATE Latin1_General_CI_AS NULL,
		 ORD_NUMEDA numeric (7,0) NULL,
		 ORD_NUMEAL numeric (7,0) NULL,
	 	 ORD_CBFISC varchar (50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DD_ORD_FLGCEL] DEFAULT (0) FOR [ORD_FLGCEL],
	CONSTRAINT [DF_U_ORF_DD_ORD_SERBOL] DEFAULT ('    ') FOR [ORD_SERBOL],
	CONSTRAINT [DF_U_ORF_DD_ORD_AAPROD] DEFAULT ('0')    FOR [ORD_AAPROD],
	CONSTRAINT [DF_U_ORF_DD_ORD_SERNUM] DEFAULT ('    ') FOR [ORD_SERNUM],
	CONSTRAINT [DF_U_ORF_DD_ORD_NUMEDA] DEFAULT ('0')    FOR [ORD_NUMEDA],
	CONSTRAINT [DF_U_ORF_DD_ORD_NUMEAL] DEFAULT ('0')    FOR [ORD_NUMEAL],
	CONSTRAINT [DF_U_ORF_DD_ORD_CBFISC] DEFAULT ('    ') FOR [ORD_CBFISC]
go


UPDATE U_ORF_DD SET ORD_FLGCEL 	= 0 
UPDATE U_ORF_DD SET ORD_SERBOL 	= '   '
UPDATE U_ORF_DD SET ORD_AAPROD 	= 0 
UPDATE U_ORF_DD SET ORD_SERNUM 	= '   ' 
UPDATE U_ORF_DD SET ORD_NUMEDA	= 0 
UPDATE U_ORF_DD SET ORD_NUMEAL 	= 0 
UPDATE U_ORF_DD SET ORD_CBFISC 	= SPACE(50) 