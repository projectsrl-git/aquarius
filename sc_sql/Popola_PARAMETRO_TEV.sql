/********************************************************************
 PARAMETRO TEV- TIPOLOGIA EVENTI
*********************************************************************
********************************************************************/

delete from para where SUBSTRING(codice,1,3) = 'TEV'
insert into para (codice,descri,libera) values ('TEVORDINI','ORDINI CLIENTI','DESTINATARI:ERCOLI,FERRARESE;GRUPPO:"ORDINE "+ALLTRIM(M.ORD_NUMORD)+" DEL "+ALLTRIM(M.ORD_DATORD)+" MODIFICATO";')

select * from para where codice like 'TEV%'
