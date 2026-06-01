/********************************************************************
 PARAMETRO ATTIVITA' PER STUDI PROFESSIONALI
*********************************************************************
********************************************************************/

delete from para where codice like 'AST%'

insert into para (codice,descri) values ('AST00001','Elaborazione libro unico-calcolo contributi e invio telematico UNIEMENS modello F24')
insert into para (codice,descri) values ('AST00002','Spese generali di studio /formazione fascicoli pratiche')
insert into para (codice,descri) values ('AST00003','Gestione libro unico')
insert into para (codice,descri) values ('AST00004','Custodia / archiviazione e lugo di ispezione amministrativa')

select * from para where codice like 'AST%'

