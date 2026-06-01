/********************************************************************
 PARAMETRO ATTIVITA' PER INVIO TELEMATICO DATI IVA
*********************************************************************
********************************************************************/

delete from para where codice like 'FSDIVA%'

insert into para (codice,descri,libera) values ('FSDIVA','SOTTODIRECTORY PER INVIO TELEMATICO DATI IVA','COMUNICAZIONE_DATI_IVA\')


select * from para where codice like 'FSDIVA%'

