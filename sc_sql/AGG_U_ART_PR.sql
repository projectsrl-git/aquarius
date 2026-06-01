/*************************************************************/
/*    							     */
/*    Aggiunto il campo ART_BARCOD alla tabella U_ART_PR     */
/*    							     */
/*************************************************************/


ALTER TABLE [dbo].[U_ART_PR] ADD 
	 ART_BARCOD varchar(20) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_BARCOD] DEFAULT ('0') FOR [ART_BARCOD]
go

update u_art_pr set art_barcod = space(20)
