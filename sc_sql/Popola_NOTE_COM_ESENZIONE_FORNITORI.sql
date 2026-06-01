/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from NOTE_COM where not_codice = 'INESE_FOR'

insert into NOTE_COM (not_codsoc,not_codice,not_testo) values ('01','INESE_FOR','Operazione senza applicazione dell''iva ai sensi 
del''articolo 8/c1 del dpr 633/72  dichiarazione
d''Intento N. .NDESCLI.  del  .DTESCLI.  da voi  
registrata con il N.  .NDESSOC.  del  .DTESSOC.')

select * from NOTE_COM where not_codice = 'INESE_FOR'

