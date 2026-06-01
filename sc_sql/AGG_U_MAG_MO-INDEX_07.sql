/*
Missing Index Details from SQLQuery2.sql - DELLVS15.Cardioline_TEST (sviluppo (55))
The Query Processor estimates that implementing the following index could improve the query cost by 25.2539%.
*/


CREATE NONCLUSTERED INDEX [INDEX_07] ON [dbo].[U_MAG_MO] 
	([MOV_SEGNO], [MOV_ANAART], [MOV_DOCMOD], [MOV_PREACQ])
INCLUDE ([MOV_DTREGI],[MOV_ORAMOV],[MOV_FORNIT])
GO

