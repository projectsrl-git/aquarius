/********************************************************************
 PARAMETRO ATTIVITA' PER NUMERAZIONE PROGRESSIVA TRASMISSIONI INTRASTAT
*********************************************************************
********************************************************************/

delete from para where codice like 'NUMNPI01%'

insert into para (codice,descri,libera) values ('NUMNPI01','NUMERAZIONE PROGRESSIVA TRASMISSIONI INTRASTAT','      0                                                                                                                                                                                                                                                       ')


select * from para where codice like 'NUMNPI01%'

