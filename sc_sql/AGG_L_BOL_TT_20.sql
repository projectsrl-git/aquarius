/* 
******************************************
INSERIMENTO CAMPI PER MAGGIORAZIONI PREZZO
******************************************
*/
ALTER TABLE [dbo].[L_BOL_TT] ADD 
	ORD_RIFCTL numeric (7,0) NULL,
	ORD_PAGCTL numeric (7,0) NULL
go

ALTER TABLE [dbo].[L_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_L_BOL_TT_ORD_RIFCTL] DEFAULT (0) FOR [ORD_RIFCTL],
	CONSTRAINT [DF_L_BOL_TT_ORD_PAGCTL] DEFAULT (0) FOR [ORD_PAGCTL]
go

UPDATE L_BOL_TT SET ORD_RIFCTL = 0 
UPDATE L_BOL_TT SET ORD_PAGCTL = 0 


/* 
******************************************
INSERIMENTO CAMPI PER MAGGIORAZIONI PREZZO
******************************************
*/
ALTER TABLE [dbo].[L_BOL_TT] ADD 
	ORD_PERPAG numeric (7,3) NULL
go

ALTER TABLE [dbo].[L_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_L_BOL_TT_ORD_PERPAG] DEFAULT (0) FOR [ORD_PERPAG]
go

UPDATE L_BOL_TT SET ORD_PERPAG = 0 
