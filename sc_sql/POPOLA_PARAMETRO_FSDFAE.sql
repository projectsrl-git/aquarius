/********************************************************************
 PARAMETRO FSD- FATTURAZIONE ELETTRONICA
*********************************************************************
********************************************************************/

delete from para where SUBSTRING(codice,1,6) = 'FSDFAE'
insert into para (codice,descri,libera) values ('FSDFAE','SOTTODIRECTORY PER FATTURAZIONE ELETTRONICA','FATTURE_ELETTRONICHE')

select * from para where codice like 'FSDFAE%'
