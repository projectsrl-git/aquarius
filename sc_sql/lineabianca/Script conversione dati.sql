
SELECT commento,* FROM COGPrimeNoteTeste 
SELECT commento,CodConto,* FROM COGPrimeNoteRCont

SELECT commento,* FROM COGPrimeNoteTeste WHERE IdPrimaNota = 172150
SELECT commento,* FROM COGPrimeNoteRCont WHERE IdPrimaNota = 172150

SELECT commento,TipoCliFor,* FROM COGPrimeNoteRCont WHERE IdPrimaNota = 172151
SELECT commento,* FROM COGPrimeNoteTeste WHERE IdPrimaNota = 172151
SELECT          * FROM COGPrimeNoteRIva  WHERE IdPrimaNota = 172151

SELECT commento,TipoCliFor,* FROM COGPrimeNoteRCont WHERE IdPrimaNota = 172152
SELECT commento,* FROM COGPrimeNoteTeste WHERE IdPrimaNota = 172152
SELECT          * FROM COGPrimeNoteRIva  WHERE IdPrimaNota = 172152

SELECT partita,commento,TipoCliFor,IdCliFor,* FROM COGPrimeNoteRCont WHERE IdPrimaNota = 349510
SELECT partita,commento,TipoCliFor,* FROM COGPrimeNoteTeste WHERE IdPrimaNota = 349510
SELECT          * FROM COGPrimeNoteRIva  WHERE IdPrimaNota = 349510


SELECT commento,TipoCliFor,IdCliFor,* FROM COGPrimeNoteRCont WHERE TipoCliFor = 2


--SELECT commento,TipoCliFor,IdCliFor,* FROM COGPrimeNoteRCont WHERE substring(LEFT(CONVERT(VARCHAR, DataRegistrazione, 111), 10),1,4) = '2018'

--DELETE FROM COGPrimeNoteRCont WHERE substring(LEFT(CONVERT(VARCHAR, DataRegistrazione, 111), 10),1,4) <> '2018'
--SELECT substring(LEFT(CONVERT(VARCHAR, DataRegistrazione, 111), 10),1,4) FROM COGPrimeNoteRCont


SELECT * FROM COGCausaliContabili

SELECT * FROM STDAnagraficaClienti WHERE IdAnagrafica = 3499
SELECT cliente,* FROM STDAnagrafiche WHERE IdAnagrafica = 3499
SELECT cliente,* FROM STDAnagrafiche WHERE CLIENTE = 1
SELECT cliente,* FROM STDAnagrafiche WHERE FORNITORE = 1

SELECT partita,commento,TipoCliFor,IdCliFor,* FROM COGPrimeNoteRCont WHERE IdPrimaNota = 346072
SELECT partita,commento,TipoCliFor,* FROM COGPrimeNoteTeste WHERE IdPrimaNota = 346072

--link fattura
SELECT IdPrimaNota,partita,idscadenza,commento,TipoCliFor,IdCliFor,* FROM COGPrimeNoteRCont WHERE IdPrimaNota = 349510
SELECT iddoc,partita,idscadenza,annotazioni, * FROM COGScadenze WHERE idscadenza = 393687
SELECT idprimanota,idanagrafica,partita,commento,TipoCliFor,* FROM COGPrimeNoteTeste WHERE IdPrimaNota = 349510

--link incasso
SELECT IdPrimaNota,partita,idscadenza,commento,TipoCliFor,IdCliFor,* FROM COGPrimeNoteRCont WHERE IdPrimaNota = 346072
SELECT IdDoc,partita,idscadenza,annotazioni, * FROM COGScadenze WHERE iddoc = 346072
SELECT IdPrimaNota,idanagrafica,partita,commento,TipoCliFor,* FROM COGPrimeNoteTeste WHERE IdPrimaNota = 346072



SELECT idanagrafica,partita,idscadenza,annotazioni, * FROM COGScadenze WHERE IDDOC =      292698

SELECT partita,idscadenza,commento,TipoCliFor,IdCliFor,* FROM COGPrimeNoteRCont WHERE partita = '2018/0000030/18'

SELECT pareggiata as pareggiat,tipoanagrafica,partita,idscadenza,annotazioni, * FROM COGScadenze order by pareggiata
            
              
--DELETE FROM COGScadenze WHERE substring(LEFT(CONVERT(VARCHAR, DataDoc, 111), 10),1,4) < '2018'
SELECT * FROM COGScadenze WHERE substring(LEFT(CONVERT(VARCHAR, DataDoc, 111), 10),1,4) > '2017'


SELECT * FROM STDScalaSconti order by codlistino,codarticolo,qtada,qtaa

SELECT * FROM MAGAnagraficaArticoli

SELECT * FROM STDListiniArticolo ORDER BY CodArt

SELECT * FROM STDAnagrafiche WHERE Cliente = 1

SELECT * FROM STDScontiClientiArticolo

SELECT * FROM STDScontiPerCategorie

SELECT * FROM STDAnagraficaClienti



SELECT * FROM STDListini
SELECT USASCALASCONTI,* FROM STDListiniArticolo WHERE CODART = '15186'
SELECT * FROM STDScalaSconti WHERE CODARTICOLO = '78420'
SELECT * FROM STDAnagraficaClienti 
SELECT * FROM STDIva

