/********************************************************************
 PARAMETRO PER SOTTOCATEGORIA ARTICOLO
*********************************************************************
 PERMETTE DI DISCRIMINARE GLI ADESIVI
   - SE SOTTOCATEGORIA E' VUOTA, E' UvN SEMPLICE ADESIVO
   - SE SOTTOCATEGORIA E' "RE", E' UN RETICOLANTE
   - SE SOTTOCATEGORIA E' "CT", E' UN CATALIZZATORE
 L'INTRODUZIONE DI QUESTO PARAMETRO E' NECESSARIA IN FASE DI ESTRAPOLAZIONE ARTICOLI ADESIVO
 DALLA DISTINTA BASE QUANDO SELEZIONE GLI ORDINI DA PRODURRE


*********************************************************************
 SCRIPT MODIFICATO IN QUANTO ESISTEVA GIA' UN CODICE PARAMETRO STC(STATO CV)
 INTRODOTTO IL NUOVO CODICE CAT(SOTTOCATEGORIA ARTICOLO)
*********************************************************************

********************************************************************/



delete from para where codice like 'STC%'



delete from para where codice like 'CAT%'

insert into para (codice,descri) values ('CATRE','RETICOLANTE')
insert into para (codice,descri) values ('CATCT','CATALIZZATORE')

select * from para where codice like 'CAT%'

