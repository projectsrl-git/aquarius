
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ADD 
		 ORD_QTACON numeric (12,2) NULL,
	 	 ORD_TIPCON varchar (1) COLLATE Latin1_General_CI_AS NULL,
	 	 ORD_SERBOL varchar (3) COLLATE Latin1_General_CI_AS NULL,
		 ORD_ANNOPR numeric (4,0) NULL,
	 	 ORD_SERNUM varchar (3) COLLATE Latin1_General_CI_AS NULL,
		 ORD_NUMEDA numeric (7,0) NULL,
		 ORD_NUMEAL numeric (7,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_QTACON] DEFAULT ('0')    FOR [ORD_QTACON],
	CONSTRAINT [DF_U_BFO_DD_ORD_TIPCON] DEFAULT ('    ') FOR [ORD_TIPCON],
	CONSTRAINT [DF_U_BFO_DD_ORD_SERBOL] DEFAULT ('    ') FOR [ORD_SERBOL],
	CONSTRAINT [DF_U_BFO_DD_ORD_ANNOPR] DEFAULT ('0')    FOR [ORD_ANNOPR],
	CONSTRAINT [DF_U_BFO_DD_ORD_SERNUM] DEFAULT ('    ') FOR [ORD_SERNUM],
	CONSTRAINT [DF_U_BFO_DD_ORD_NUMEDA] DEFAULT ('0')    FOR [ORD_NUMEDA],
	CONSTRAINT [DF_U_BFO_DD_ORD_NUMEAL] DEFAULT ('0')    FOR [ORD_NUMEAL]
go



UPDATE U_BFO_DD SET ORD_QTACON 	= 0 
UPDATE U_BFO_DD SET ORD_TIPCON 	= '   ' 
UPDATE U_BFO_DD SET ORD_SERBOL 	= '   '
UPDATE U_BFO_DD SET ORD_ANNOPR 	= 0 
UPDATE U_BFO_DD SET ORD_SERNUM 	= '   ' 
UPDATE U_BFO_DD SET ORD_NUMEDA	= 0 
UPDATE U_BFO_DD SET ORD_NUMEAL 	= 0 
