select * from TestateGiornale where Esercizio = '2023'

select * from TestateGiornale where Esercizio = '2023' and DataRegistrazione > '2023-03-31 00:00:00.0000000' order by DataRegistrazione
select * from TestateGiornale where Esercizio = '2023' AND IDregistrazione = '73597'
select * from MovimentiGiornale where IDregistrazione = '2424      ' ORDER BY RigaRegistrazione
select * from MovimentiIVA where IDregistrazione = '2424      ' ORDER BY RigaRegistrazione


select * from TestateGiornale where Esercizio = '2022' AND IDregistrazione = '104'
select * from MovimentiGiornale where IDregistrazione = '104'
select * from MovimentiIVA where IDregistrazione = '104'


select * from TestateGiornale where Esercizio = '2023' and DataRegistrazione > '2023-03-31 00:00:00.0000000' AND Causale = '0001' order by DataRegistrazione
select * from TestateGiornale where Esercizio = '2023' AND IDregistrazione = '2375'
select * from MovimentiGiornale where IDregistrazione = '2375'
select * from MovimentiIVA where IDregistrazione = '2375'



