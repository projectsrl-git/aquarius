/********************************************************************
 PARAMETRO TEV- TIPOLOGIA EVENTI
*********************************************************************
********************************************************************/

delete from para where codice = 'TEVORDFOR'
insert into para (codice,descri,libera) values ('TEVORDFOR','ORDINI FORNITORI','DESTINATARI:PANITTI,KELLER;GRUPPO:"ORDINE FORNITORE "+ALLTRIM(M.ORD_NUMORD)+" DEL "+ALLTRIM(M.ORD_DATORD)+" MODIFICATO";')

select * from para where codice like 'TEV%' ORDER BY CODICE
