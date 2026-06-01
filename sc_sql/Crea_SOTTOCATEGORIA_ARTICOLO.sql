/********************************************************************
 PARAMETRO PER SOTTOCATEGORIA ARTICOLO
*********************************************************************
 PERMETTE DI DISCRIMINARE GLI ADESIVI
   - SE SOTTOCATEGORIA E' VUOTA, E' UN SEMPLICE ADESIVO
   - SE SOTTOCATEGORIA E' "RE", E' UN RETICOLANTE
   - SE SOTTOCATEGORIA E' "CT", E' UN CATALIZZATORE
 L'INTRODUZIONE DI QUESTO PARAMETRO E' NECESSARIA IN FASE DI ESTRAPOLAZIONE ARTICOLI ADESIVO
 DALLA DISTINTA BASE QUANDO SELEZIONE GLI ORDINI DA PRODURRE
********************************************************************/

delete from para where codice like 'STC%'

insert into para (codice,descri,LIBERA) values ('STCRE','SOTTOCATEGORIA ARTICOLO','RETICOLANTE')
insert into para (codice,descri,LIBERA) values ('STCCT','SOTTOCATEGORIA ARTICOLO','CATALIZZATORE')

select * from para where codice like 'STC%'

