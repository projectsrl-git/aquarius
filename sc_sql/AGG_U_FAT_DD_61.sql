
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_DD] ADD 
		ORD_SYSMAG varchar (13) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAT_DD] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAT_DD_ORD_SYSMAG] DEFAULT ('') FOR [ORD_SYSMAG]
go



UPDATE U_FAT_DD SET ORD_SYSMAG 	= ''


