/* 
**************************************************************
CAMPI PER LA GESTIONE DELLE DISTINTE RID
**************************************************************
*/

ALTER TABLE [dbo].[U_CCO_TT] ADD 
	ORD_ULPRGR NUMERIC(10,0) NOT NULL CONSTRAINT [DF_U_CCO_TT_ORD_ULPRGR] DEFAULT (0),
	ORD_SCHSDD varchar(8) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_CCO_TT_ORD_SCHSDD] DEFAULT (''),
	ORD_DIRRID varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_CCO_TT_ORD_DIRRID] DEFAULT ('')
go


