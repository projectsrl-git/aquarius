/*
Missing Index Details from SQLQuery5.sql - DELLVS15.Xilopan (sviluppo (52))
The Query Processor estimates that implementing the following index could improve the query cost by 95.1432%.
*/

CREATE NONCLUSTERED INDEX [INDEX_05]
ON [dbo].[U_MAG_MO] ([MOV_TOP],[MOV_DTREGI])
INCLUDE ([MOV_CODART],[MOV_NUMDOC],[MOV_DTDOCU],[MOV_ORAMOV],[MOV_LEGAME],[MOV_CODOPE],[MOV_NOMOPE],[MOV_CODMAT],[MOV_SPESSO],[MOV_ALTEZZ],[MOV_LUNGHE],[MOV_ANAART])
GO
