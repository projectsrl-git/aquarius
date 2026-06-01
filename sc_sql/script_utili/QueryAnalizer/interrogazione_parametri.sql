select * from para where codice LIKE 'TIT%' ORDER BY CODICE
select * from para where codice LIKE 'CIV%' ORDER BY CODICE
select * from para where codice LIKE 'MIL%' ORDER BY CODICE
select * from para where codice LIKE 'SRS%' ORDER BY CODICE
select * from para where codice LIKE 'SAZ%' ORDER BY CODICE
select * from para where codice LIKE 'CTC%' ORDER BY CODICE
select * from para where codice LIKE 'FUN%' ORDER BY CODICE

select SOLOIVA,PERIMPO,SCAFISS,* from para where codice LIKE 'TOP%' ORDER BY CODICE
select DESIVA,* from para where codice LIKE 'CPA%' ORDER BY CODICE


delete from PARA where codice LIKE  'MIL%'