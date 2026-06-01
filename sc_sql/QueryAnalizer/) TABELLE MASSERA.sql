
select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
left outer join sys.all_columns as col on col.object_id = tab.object_id
where tab.type = 'U' AND tab.name = 'DORig'
order by tab.name,col.column_id

  
 

select * from abicab
select * from Agente
select * from Aliquota
select * from ARCosto
select * from BancaSupporto
select * from CAP
select * from CGBil
select * from CGBilConto
select * from CGBilPeriodo
select * from CGBilSaldoConto
select * from CGCausale
select * from CGConto
select * from CGDatiFatturaT
select * from CGDatiFatturaR
select * from CGDatiFatturaE
select * from CGMastro1
select * from CGMovT             -- TESTATA PRIMA NOTA --
select * from CGMovR             -- DETTAGLI PRIMA NOTA --
select * from CGMovT_NumProt
select * from CGRegistro
select * from F24ContributoEnte
select * from Lingua
select * from LSarticolo

SELECT * FROM CSMov
select * from AR                 -- ANAGRAFICA ARTICOLI --
select * from ARARMisura
select * from ARClasse1
select * from ARClasse2
select * from ARClasse3
select * from ARCodCF
select * from ARCosto
select * from ARCostoDB
select * from ARCostoDBItem      -- COSTI --
select * from ARCostoItem        -- COSTI --
select * from ARGruppo1
select * from ARGruppo2
select * from ARGruppo3
select * from ARLingua  
select * from ARLotto            -- LOTTTI --
select * from ARMisura           -- UM --

select * from CF                 -- CLIENTI/FORNITORI/AGENTI --
select * from CFClasse1 
select * from CFClasse2 
select * from CFClasse3 
select * from CFContatto
select * from CFContattoTipo
select * from CFDest
select * from CFGruppo1
select * from CFGruppo2
select * from CFGruppo3
select * from CFSede              -- LOCALITA' DI CONSEGNA --
select * from CFSettore
select * from CFStato
select * from CFZona
select * from AE_Paese
select * from MG                  -- anagrafica magazzini --

select * from CFSede order by Cd_Cf

select ContoCorrente,TipoCF,* from CF   





select * from AR where Descrizione like 'BURRO%'
select * from AR where Descrizione like 'FARIN%'
select * from AR where Descrizione like 'FRUTTA%'
select * from AR where Descrizione like 'NOCCIO%'
select * from AR where Descrizione like 'CACAO%'
select * from AR where Descrizione like 'FRUTTA%'
select * from AR where Descrizione like 'MANDORL%'
select * from AR where Descrizione like 'NOCCIOL%'
select * from AR where Descrizione like 'GRANEL%'
select * from AR where Descrizione like 'AROM%'
select * from AR where Descrizione like 'COCC%'
select * from AR where Descrizione like 'CONFETTU%'
select * from AR where Descrizione like 'CREM%'
select * from AR where Descrizione like 'CANDIT%'
select * from AR where Descrizione like 'LATTE%'
select * from AR where Descrizione like 'VIN%'
select * from AR where Descrizione like 'LIQ%'
select * from AR where Descrizione like 'ZUCCHE%'
select * from AR where Descrizione like 'UOVA%'
select * from AR where Descrizione like 'MIELE%'
select * from AR where Descrizione like 'MIGLIOR%'
select * from AR where Descrizione like 'CARTON%'
select * from AR where Descrizione like 'SCATOL%'
select * from AR where Descrizione like 'SACCH%'
select * from AR where Descrizione like 'VASCHETT%'
select * from AR where Descrizione like 'BOBIN%'
select * from AR where Descrizione like 'SCOTC%'
select * from AR where Descrizione like 'SCOTC%'
select * from AR where Descrizione like 'METAL%'


select * from AR where Descrizione like 'SCOTC%'

select ScortaMinima,ScortaMassima,PesoNetto,PesoLordo,Sconto,MrpGiorniRiordino,MrpLottoRiordino,MrpLottoMinimo,MrpPuntoRiordino, * from AR


select * from CGDatiFatturaT
select * from CGDatiFatturaR
select * from CGDatiFatturaE
select * from DO
select * from DOIva
select * from DOPorto
select * from DOTrasporto
select * from DOVettore


select Cd_DOPorto,Cd_DOVettore,CD_Pg,Iban,Cd_Abicab,ContoCorrente,Cd_CFZona,Note_CF,Cd_CFClasse1,Cd_CFClasse2,Cd_CFClasse3,* from CF 

select * from PG     order by Cd_PG									-- CONDIZIONI PAGAMENTO --             
select * from PGRata order by Cd_PG

select * from PG     where Cd_Pg = '20' order by Cd_PG				-- CONDIZIONI PAGAMENTO --             
select * from PGRata where Cd_Pg = '20' order by Cd_PG
select * from PG     where Cd_Pg = '22' order by Cd_PG				-- CONDIZIONI PAGAMENTO --             
select * from PGRata where Cd_Pg = '22' order by Cd_PG
select * from PG     where Cd_Pg = '29' order by Cd_PG				-- CONDIZIONI PAGAMENTO --             
select * from PGRata where Cd_Pg = '29' order by Cd_PG


select * from PG     where Cd_Pg = '10' order by Cd_PG				-- CONDIZIONI PAGAMENTO --             
select * from PGRata where Cd_Pg = '10' order by Cd_PG

select * from PG     where Cd_Pg = '11' order by Cd_PG				 -- CONDIZIONI PAGAMENTO --             
select * from PGRata where Cd_Pg = '11' order by Cd_PG


select * from PG     where Cd_Pg = '2' order by Cd_PG				 -- CONDIZIONI PAGAMENTO --             
select * from PGRata where Cd_Pg = '2' order by Cd_PG


select * from CGConto                      -- PIANO DEI CONTI --
select * from CGMastro1
select * from CGMastro2
select * from CGMastro3
select * from CGMastro4
select * from CGConto
select * from ARLingua
select * from F24Comune
select * from F24CreditiDebiti


select * from CGBil
select * from CGBilConto
select * from CGBilSaldoConto
select * from CGCausale                     -- TOP --
select * from CGBilPeriodo
select * from CGBilSaldoConto
select * from CGBilTassonomia


select * from CGConto  where descrizione like 'iva%'
select * from CGConto  where descrizione like 'client%'
select * from CGConto  where descrizione like 'fornit%'
SELECT * FROM CGConto  where descrizione LIKE 'client%' OR descrizione LIKE 'fornit%' 

select * from CGConto order by Cd_CGConto
select * from CGMastro1
select * from CGMastro2

select * from AE_Paese
select * from nazione
select * from CF 

select * from CF where Cd_CF = 'F000825'


select * from CGBilConto order by Cd_CGBil1

select * from CGBil ORDER BY Ordine

select * from CGMovT	where Cd_CGEsercizio_R = '2022' order by DtReg			-- TESTATA PRIMA NOTA --
select * from CGMovR	where id_CGMovT = '56590'		order by Id_CGMovR		-- RIGHE PRIMA NOTA --


select * from DO                            -- CAUSALI DOCUMENTI --
select * from DOAspBene                     -- ASPETTO DEI BENI  --
select * from DOPorto                       -- PORTO ??????????? --
select * from DOTrasporto                   -- CAUSALI TRASPORTO ???????????? --
select * from DOVettore                     -- VETTORI --


SELECT * FROM INDICE
SELECT MOV_NUMPRO AS NUMPRO,MOV_SEQUEN AS SEQUEN,* FROM MOV_CONT ORDER BY MOV_NUMPRO,MOV_SEQUEN

SELECT MOV_NUMPRO AS NUMPRO,MOV_SEQUEN AS SEQUEN,* FROM MOV_CONT WHERE MOV_CONTO = '0506010100' ORDER BY MOV_NUMPRO,MOV_SEQUEN
SELECT MOV_CONTO,MOV_IMP,MOV_NUMPRO AS NUMPRO,MOV_SEQUEN AS SEQUEN,* FROM MOV_CONT where mov_anno = '2022' AND SUBSTRING(MOV_CONTO,1,4) = '0506'  ORDER BY MOV_NUMPRO,MOV_SEQUEN


SELECT con_imp_d,con_imp_a,* FROM CONTI where con_anno = '2022' AND SUBSTRING(con_CONTO,1,4) = '0506'  ORDER BY CON_CONTO

SELECT MOV_CONTO,MOV_IMP,MOV_NUMPRO AS NUMPRO,MOV_SEQUEN AS SEQUEN,* FROM MOV_CONT where mov_anno = '2022' AND SUBSTRING(MOV_CONTO,1,4) = '0506'  ORDER BY MOV_NUMPRO,MOV_SEQUEN


SELECT MOV_CONTO,MOV_IMP,* FROM MOV_CONT where mov_anno = '2022' AND mov_nregis = '50510'  ORDER BY MOV_NUMPRO,MOV_SEQUEN

--########################################################################################################################################

select * from DOTes  order by Id_DOTes                       -- TESTATE DOCUMENTI
select * from DORig	 order by Id_DOTes 						 -- RIGHE DOCUMENTI --

select NumeroDoc as Numdoc,DataDoc,* from DOTes WHERE Cd_Do = 'FT' AND EsAnno = '2022'   ORDER BY NumeroDoc                    
select NumeroDoc as Numdoc,DataDoc,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'C'  AND TipoDocumento = 'F' ORDER BY NumeroDoc                    

select NumeroDoc as Numdoc,DataDoc,* from DOTes WHERE CliFor = 'C'  AND TipoDocumento = 'F'  ORDER BY NumeroDoc                    

-- NOTA CREDITO
select * from DOTes WHERE EsAnno = '2022' AND CliFor = 'C'  AND TipoDocumento = 'N' AND Id_DoTes = '32289' ORDER BY NumeroDoc                    
select NumeroDoc,Omaggio,Cd_Aliquota,Cd_MG_P,Cd_MG_A,Cd_AR,Id_DORig AS Id_DORi,* from DORig  WHERE Id_DOTes = '32289' order by   Id_DORig                    




select TipoDocumento,Cd_CF_Fatt,Cd_DoAspBene,Cd_DoLuogoCarico,Cd_DoLuogoScarico,PesoLordo,PesoNetto,CD_Pg,DataConsegna,Cd_Agente_1,NumeroDocI,NumeroDocRif,Cd_MGCausale,NumeroDoc as Numdoc,DataDoc,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'C'  AND TipoDocumento = 'F' ORDER BY NumeroDoc                    

select TipoDocumento,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'C' ORDER BY NumeroDoc                    
select TipoDocumento,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'F' AND TipoDocumento = 'A' ORDER BY NumeroDoc                    
select TipoDocumento,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'C' AND TipoDocumento = 'B' ORDER BY NumeroDoc                    
select TipoDocumento,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'C' AND TipoDocumento = 'F' ORDER BY NumeroDoc                    
select TipoDocumento,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'F' AND TipoDocumento = 'F' ORDER BY NumeroDoc  
select TipoDocumento,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'C' AND TipoDocumento = 'G' ORDER BY NumeroDoc  
select TipoDocumento,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'C' AND TipoDocumento = 'N' ORDER BY NumeroDoc  
select TipoDocumento,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'F' AND TipoDocumento = 'N' ORDER BY NumeroDoc  

select TipoDocumento,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'F' AND TipoDocumento = 'O' ORDER BY NumeroDoc  
select TipoDocumento,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'F' AND TipoDocumento = 'B' ORDER BY NumeroDoc   


select TipoDocumento,* from DOTes WHERE EsAnno = '2022' AND  TipoDocumento = 'O' ORDER BY NumeroDoc  
select TipoDocumento,* from DOTes WHERE TipoDocumento = 'O' AND CliFor = 'C' ORDER BY NumeroDoc  
select TipoDocumento,* from DOTes WHERE TipoDocumento = 'O' AND CliFor = 'F' ORDER BY NumeroDoc  

select Cd_MGCausale,TipoDocumento,* from DOTes WHERE TipoDocumento = 'O' ORDER BY NumeroDoc  
select TipoDocumento,* from DOTes WHERE EsAnno = '2022' AND CliFor = 'F' AND TipoDocumento = 'B' ORDER BY NumeroDoc   


select * from CF  where SUBSTRING(CD_CF,2,6) = '003601'           -- CLIENTI/FORNITORI/AGENTI --



--TIPO DOCUMENTO
-- A ?????
-- B DDT
-- F FATTURE CLIENTI/FORNITORI
-- G FATTURE PROFORMA
-- N NOTE CREDITO CLIENTI/FORNITORI
-- O ORDINI CLIENTI


SELECT TipoDocumento 
FROM DOTes
GROUP BY TipoDocumento
ORDER BY TipoDocumento

SELECT * FROM DO
SELECT * FROM CGCausale ORDER BY Cd_CGCausale
SELECT * FROM CN

select CD_AR,DESCRIZIONE,* from DORig	 WHERE Id_DORig = '55523' order by Id_DOTes 					
select CD_AR,DESCRIZIONE,* from DORig	 WHERE CD_AR =null order by Id_DOTes 					



SELECT TipoDocumento AS TipoDocument,* FROM DOTes WHERE CliFor = 'C'  AND (TipoDocumento = 'F' OR TipoDocumento = 'N') ORDER BY TipoDocumento, NumeroDoc


SELECT * FROM DOTes WHERE CliFor = 'C'  AND TipoDocumento = 'B' ORDER BY NumeroDoc


     