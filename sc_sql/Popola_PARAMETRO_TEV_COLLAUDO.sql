/********************************************************************
PARAMETRO TEV - TIPOLOGIA EVENTI - MODIFICA DATA COLLAUDO IN DOCUMENTI
*********************************************************************
********************************************************************/

delete from para where codice = 'TEVCOLLAUDO'
insert into para (codice,descri,libera) values ('TEVCOLLAUDO','MODIFICA DATA COLLAUDO IN DOCUMENTI','DESTINATARI:ZAMBONI,GUERCI,FERRARESE;GRUPPO:ALLTRIM(M.ORD_CAUS)+" N° "+ALLTRIM(M.ORD_NUMORD)+" DEL "+IIF(SUBSTR(M.ORD_DATORD,3,1)=''/'',M.ORD_DATORD,RIBALTA2(M.ORD_DATORD))+" MODIFICATO";')

select * from para where codice like 'TEV%'
