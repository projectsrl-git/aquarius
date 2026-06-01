
select *,SUBSTRING(CAST(DATAREGISTRAZIONE AS nvarchar(30)),1,4) AS ANNO_DT from TestateGiornale WHERE SUBSTRING(CAST(DATAREGISTRAZIONE AS nvarchar(30)),1,4) <> Esercizio
select top 10 * from MovimentiGiornale