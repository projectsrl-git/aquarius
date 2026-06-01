
DELETE FROM U_DIS_TT WHERE DIT_GRUPPO LIKE 'DP%'
DELETE FROM U_DIS_DD WHERE DIS_GRUPPO LIKE 'DP%'

DECLARE @_NextAggancioDiBa VARCHAR(10)

-- ############################################################################################################################################
-- DP10014578
SET @_NextAggancioDiBa = (SELECT LTRIM(RTRIM(STR(CAST(LIBERA AS NUMERIC(10,0)) + 1))) FROM PARA WHERE CODICE = 'NUMDIS')

INSERT INTO U_DIS_TT (	DIT_CODSOC,	TAGGANCIO,			DIT_GRUPPO,		DIT_DESCRI,					DIT_UM,	DIT_MAGA,	DIT_LINEA,	DIT_CODIVA)
	VALUES (			'01',		@_NextAggancioDiBa,	'DP10014578',	'DADI PRESSATI 100X145X78',	'MC',	'SEDE',		'05',		'21')

INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','01.001.0003',0.3150000,'LEGNAM  ','MISTO PIOPPO                                      ','T     ',10        ,'MISTO PIOPPO                                      ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','01.001.0005',0.1260000,'LEGNAM  ','CIMALI                                            ','T     ',20        ,'CIMALI                                            ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','01.001.0006',0.1260000,'LEGNAM  ','CEPPE DI PIOPPO                                   ','T     ',30        ,'CEPPE DI PIOPPO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','01.001.0012',0.3150000,'LEGNAM  ','CIPPATO TIPO B                                    ','T     ',40        ,'CIPPATO TIPO B                                    ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','01.001.0021',0.7350000,'LEGNAM  ','RICICLATO                                         ','T     ',50        ,'RICICLATO                                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','01.002.0004',0.0860000,'SEDE    ','COLLA CON MELAMINA AL 10%                         ','T     ',60        ,'COLLA CON MELAMINA AL 10%                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','01.004.0005',10.000000,'SEDE    ','EMULSIONE DI PARAFINA                             ','KG    ',70        ,'EMULSIONE DI PARAFINA                             ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','01.004.0004',6.0000000,'SEDE    ','AMMONIO SOLFATO                                   ','KG    ',80        ,'AMMONIO SOLFATO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','02.005.0745',4.0933949,'SEDE    ','CARTONE 1200X890 TIPO MMM/222/E                   ','NR    ',90        ,'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','02.005.0748',0.0000000,'SEDE    ','FOGLIA POLITENE  H 130-  80 MY  U.V. 6 MESI NEUTRO','KG    ',100       ,'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','02.005.0747',0.2923853,'SEDE    ','FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA','KG    ',110       ,'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','02.005.0784',0.5847707,'SEDE    ','ETICHETTA  DADO 145 X 100 X 78                    ','NR    ',120       ,'ETICHETTA  DADO 145 X 100 X 78                    ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578','A       ','02.005.0744',0.5847707,'SEDE    ','PALLETS 120X80 EPAL                               ','NR    ',130       ,'BANCALI                                           ', 1)

UPDATE PARA SET LIBERA = @_NextAggancioDiBa WHERE CODICE = 'NUMDIS'
-- ############################################################################################################################################

-- ############################################################################################################################################
-- DP10014578-2
SET @_NextAggancioDiBa = (SELECT LTRIM(RTRIM(STR(CAST(LIBERA AS NUMERIC(10,0)) + 1))) FROM PARA WHERE CODICE = 'NUMDIS')

INSERT INTO U_DIS_TT (	DIT_CODSOC,	TAGGANCIO,			DIT_GRUPPO,		DIT_DESCRI,					DIT_UM,	DIT_MAGA,	DIT_LINEA,	DIT_CODIVA)
	VALUES (			'01',		@_NextAggancioDiBa,	'DP10014578-2',	'DADI PRESSATI 100X145X78 (SECONDA SCELTA)',	'MC',	'SEDE',		'05',		'21')

INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','01.001.0003',0.3150000,'LEGNAM  ','MISTO PIOPPO                                      ','T     ',10        ,'MISTO PIOPPO                                      ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','01.001.0005',0.1260000,'LEGNAM  ','CIMALI                                            ','T     ',20        ,'CIMALI                                            ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','01.001.0006',0.1260000,'LEGNAM  ','CEPPE DI PIOPPO                                   ','T     ',30        ,'CEPPE DI PIOPPO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','01.001.0012',0.3150000,'LEGNAM  ','CIPPATO TIPO B                                    ','T     ',40        ,'CIPPATO TIPO B                                    ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','01.001.0021',0.7350000,'LEGNAM  ','RICICLATO                                         ','T     ',50        ,'RICICLATO                                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','01.002.0004',0.0860000,'SEDE    ','COLLA CON MELAMINA AL 10%                         ','T     ',60        ,'COLLA CON MELAMINA AL 10%                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','01.004.0005',10.000000,'SEDE    ','EMULSIONE DI PARAFINA                             ','KG    ',70        ,'EMULSIONE DI PARAFINA                             ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','01.004.0004',6.0000000,'SEDE    ','AMMONIO SOLFATO                                   ','KG    ',80        ,'AMMONIO SOLFATO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','02.005.0745',4.0933949,'SEDE    ','CARTONE 1200X890 TIPO MMM/222/E                   ','NR    ',90        ,'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','02.005.0748',0.0000000,'SEDE    ','FOGLIA POLITENE  H 130-  80 MY  U.V. 6 MESI NEUTRO','KG    ',100       ,'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','02.005.0747',0.2923853,'SEDE    ','FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA','KG    ',110       ,'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','02.005.0784',0.5847707,'SEDE    ','ETICHETTA  DADO 145 X 100 X 78                    ','NR    ',120       ,'ETICHETTA  DADO 145 X 100 X 78                    ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-2','A       ','02.005.0744',0.5847707,'SEDE    ','PALLETS 120X80 EPAL                               ','NR    ',130       ,'BANCALI                                           ', 1)

UPDATE PARA SET LIBERA = @_NextAggancioDiBa WHERE CODICE = 'NUMDIS'
-- ############################################################################################################################################

-- ############################################################################################################################################
-- DP10014578-3
SET @_NextAggancioDiBa = (SELECT LTRIM(RTRIM(STR(CAST(LIBERA AS NUMERIC(10,0)) + 1))) FROM PARA WHERE CODICE = 'NUMDIS')

INSERT INTO U_DIS_TT (	DIT_CODSOC,	TAGGANCIO,			DIT_GRUPPO,		DIT_DESCRI,					DIT_UM,	DIT_MAGA,	DIT_LINEA,	DIT_CODIVA)
	VALUES (			'01',		@_NextAggancioDiBa,	'DP10014578-3',	'DADI PRESSATI 100X145X78 (TERZA SCELTA/SCARTO)',	'MC',	'SEDE',		'05',		'21')

INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','01.001.0003',0.3150000,'LEGNAM  ','MISTO PIOPPO                                      ','T     ',10        ,'MISTO PIOPPO                                      ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','01.001.0005',0.1260000,'LEGNAM  ','CIMALI                                            ','T     ',20        ,'CIMALI                                            ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','01.001.0006',0.1260000,'LEGNAM  ','CEPPE DI PIOPPO                                   ','T     ',30        ,'CEPPE DI PIOPPO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','01.001.0012',0.3150000,'LEGNAM  ','CIPPATO TIPO B                                    ','T     ',40        ,'CIPPATO TIPO B                                    ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','01.001.0021',0.7350000,'LEGNAM  ','RICICLATO                                         ','T     ',50        ,'RICICLATO                                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','01.002.0004',0.0860000,'SEDE    ','COLLA CON MELAMINA AL 10%                         ','T     ',60        ,'COLLA CON MELAMINA AL 10%                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','01.004.0005',10.000000,'SEDE    ','EMULSIONE DI PARAFINA                             ','KG    ',70        ,'EMULSIONE DI PARAFINA                             ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','01.004.0004',6.0000000,'SEDE    ','AMMONIO SOLFATO                                   ','KG    ',80        ,'AMMONIO SOLFATO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','02.005.0745',4.0933949,'SEDE    ','CARTONE 1200X890 TIPO MMM/222/E                   ','NR    ',90        ,'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','02.005.0748',0.0000000,'SEDE    ','FOGLIA POLITENE  H 130-  80 MY  U.V. 6 MESI NEUTRO','KG    ',100       ,'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','02.005.0747',0.2923853,'SEDE    ','FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA','KG    ',110       ,'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','02.005.0784',0.5847707,'SEDE    ','ETICHETTA  DADO 145 X 100 X 78                    ','NR    ',120       ,'ETICHETTA  DADO 145 X 100 X 78                    ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO         ,DIS_GRUPPO,  DIS_TIPO,  DIS_CODART,   DIS_QTA,  DIS_MAGA,  DIS_DESCRI,                                          DIS_UM,  DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014578-3','A       ','02.005.0744',0.5847707,'SEDE    ','PALLETS 120X80 EPAL                               ','NR    ',130       ,'BANCALI                                           ', 1)

UPDATE PARA SET LIBERA = @_NextAggancioDiBa WHERE CODICE = 'NUMDIS'
-- ############################################################################################################################################

-- ############################################################################################################################################
-- DP10014595
SET @_NextAggancioDiBa = (SELECT LTRIM(RTRIM(STR(CAST(LIBERA AS NUMERIC(10,0)) + 1))) FROM PARA WHERE CODICE = 'NUMDIS')

INSERT INTO U_DIS_TT (	DIT_CODSOC,	TAGGANCIO,			DIT_GRUPPO,		DIT_DESCRI,					DIT_UM,	DIT_MAGA,	DIT_LINEA,	DIT_CODIVA)
	VALUES (			'01',		@_NextAggancioDiBa,	'DP10014595',	'DADI PRESSATI 100X145X95',	'MC',	'SEDE',		'05',		'21')

INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '01.001.0003',0.3150000,'LEGNAM', 'MISTO PIOPPO                                      ','T ',   10 ,        'MISTO PIOPPO                                     ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '01.001.0005',0.1260000,'LEGNAM', 'CIMALI                                            ','T ',   20 ,        'CIMALI                                           ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '01.001.0006',0.1260000,'LEGNAM', 'CEPPE DI PIOPPO                                   ','T ',   30 ,        'CEPPE DI PIOPPO                                  ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '01.001.0012',0.3150000,'LEGNAM', 'CIPPATO TIPO B                                    ','T ',   40 ,        'CIPPATO TIPO B                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '01.001.0021',0.7350000,'LEGNAM', 'RICICLATO                                         ','T ',   50 ,        'RICICLATO                                        ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '01.002.0004',0.0860000,'SEDE  ', 'COLLA CON MELAMINA AL 10%                         ','T ',   60 ,        'COLLA CON MELAMINA AL 10%                        ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '01.004.0005',10.000000,'SEDE  ', 'EMULSIONE DI PARAFINA                             ','KG',   70 ,        'EMULSIONE DI PARAFINA                            ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '01.004.0004',6.0000000,'SEDE  ', 'AMMONIO SOLFATO                                   ','KG',   80 ,        'AMMONIO SOLFATO                                  ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '02.005.0745',3.7146708,'SEDE  ', 'CARTONE 1200X890 TIPO MMM/222/E                   ','NR',   90 ,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '02.005.0748',0.0000000,'SEDE  ', 'FOGLIA POLITENE  H 130-  80 MY  U.V. 6 MESI NEUTRO','KG',   100,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '02.005.0747',0.2653336,'SEDE  ', 'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA','KG',   110,        'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CON', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '02.005.0785',0.5306670,'SEDE  ', 'ETICHETTA DADO 145 X 100 X .....                  ','NR',   120,        'ETICHETTA DADO 145 X 100 X .....                 ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595','A',      '02.005.0744',0.5306670,'SEDE  ', 'PALLETS 120X80 EPAL                               ','NR',   130,        'BANCALI                                          ', 1)

UPDATE PARA SET LIBERA = @_NextAggancioDiBa WHERE CODICE = 'NUMDIS'
-- ############################################################################################################################################

-- ############################################################################################################################################
-- DP10014595-2
SET @_NextAggancioDiBa = (SELECT LTRIM(RTRIM(STR(CAST(LIBERA AS NUMERIC(10,0)) + 1))) FROM PARA WHERE CODICE = 'NUMDIS')

INSERT INTO U_DIS_TT (	DIT_CODSOC,	TAGGANCIO,			DIT_GRUPPO,		DIT_DESCRI,					DIT_UM,	DIT_MAGA,	DIT_LINEA,	DIT_CODIVA)
	VALUES (			'01',		@_NextAggancioDiBa,	'DP10014595-2',	'DADI PRESSATI 100X145X95 (SECONDA SCELTA)',	'MC',	'SEDE',		'05',		'21')

INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '01.001.0003',0.3150000,'LEGNAM', 'MISTO PIOPPO                                      ','T ',   10 ,        'MISTO PIOPPO                                     ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '01.001.0005',0.1260000,'LEGNAM', 'CIMALI                                            ','T ',   20 ,        'CIMALI                                           ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '01.001.0006',0.1260000,'LEGNAM', 'CEPPE DI PIOPPO                                   ','T ',   30 ,        'CEPPE DI PIOPPO                                  ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '01.001.0012',0.3150000,'LEGNAM', 'CIPPATO TIPO B                                    ','T ',   40 ,        'CIPPATO TIPO B                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '01.001.0021',0.7350000,'LEGNAM', 'RICICLATO                                         ','T ',   50 ,        'RICICLATO                                        ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '01.002.0004',0.0860000,'SEDE  ', 'COLLA CON MELAMINA AL 10%                         ','T ',   60 ,        'COLLA CON MELAMINA AL 10%                        ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '01.004.0005',10.000000,'SEDE  ', 'EMULSIONE DI PARAFINA                             ','KG',   70 ,        'EMULSIONE DI PARAFINA                            ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '01.004.0004',6.0000000,'SEDE  ', 'AMMONIO SOLFATO                                   ','KG',   80 ,        'AMMONIO SOLFATO                                  ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '02.005.0745',3.7146708,'SEDE  ', 'CARTONE 1200X890 TIPO MMM/222/E                   ','NR',   90 ,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '02.005.0748',0.0000000,'SEDE  ', 'FOGLIA POLITENE  H 130-  80 MY  U.V. 6 MESI NEUTRO','KG',   100,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '02.005.0747',0.2653336,'SEDE  ', 'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA','KG',   110,        'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CON', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '02.005.0785',0.5306670,'SEDE  ', 'ETICHETTA DADO 145 X 100 X .....                  ','NR',   120,        'ETICHETTA DADO 145 X 100 X .....                 ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-2','A',      '02.005.0744',0.5306670,'SEDE  ', 'PALLETS 120X80 EPAL                               ','NR',   130,        'BANCALI                                          ', 1)

UPDATE PARA SET LIBERA = @_NextAggancioDiBa WHERE CODICE = 'NUMDIS'
-- ############################################################################################################################################

-- ############################################################################################################################################
-- DP10014595-3
SET @_NextAggancioDiBa = (SELECT LTRIM(RTRIM(STR(CAST(LIBERA AS NUMERIC(10,0)) + 1))) FROM PARA WHERE CODICE = 'NUMDIS')

INSERT INTO U_DIS_TT (	DIT_CODSOC,	TAGGANCIO,			DIT_GRUPPO,		DIT_DESCRI,					DIT_UM,	DIT_MAGA,	DIT_LINEA,	DIT_CODIVA)
	VALUES (			'01',		@_NextAggancioDiBa,	'DP10014595-3',	'DADI PRESSATI 100X145X95 (TERZA SCELTA/SCARTO)',	'MC',	'SEDE',		'05',		'21')

INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '01.001.0003',0.3150000,'LEGNAM', 'MISTO PIOPPO                                      ','T ',   10 ,        'MISTO PIOPPO                                     ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '01.001.0005',0.1260000,'LEGNAM', 'CIMALI                                            ','T ',   20 ,        'CIMALI                                           ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '01.001.0006',0.1260000,'LEGNAM', 'CEPPE DI PIOPPO                                   ','T ',   30 ,        'CEPPE DI PIOPPO                                  ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '01.001.0012',0.3150000,'LEGNAM', 'CIPPATO TIPO B                                    ','T ',   40 ,        'CIPPATO TIPO B                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '01.001.0021',0.7350000,'LEGNAM', 'RICICLATO                                         ','T ',   50 ,        'RICICLATO                                        ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '01.002.0004',0.0860000,'SEDE  ', 'COLLA CON MELAMINA AL 10%                         ','T ',   60 ,        'COLLA CON MELAMINA AL 10%                        ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '01.004.0005',10.000000,'SEDE  ', 'EMULSIONE DI PARAFINA                             ','KG',   70 ,        'EMULSIONE DI PARAFINA                            ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '01.004.0004',6.0000000,'SEDE  ', 'AMMONIO SOLFATO                                   ','KG',   80 ,        'AMMONIO SOLFATO                                  ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '02.005.0745',3.7146708,'SEDE  ', 'CARTONE 1200X890 TIPO MMM/222/E                   ','NR',   90 ,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '02.005.0748',0.0000000,'SEDE  ', 'FOGLIA POLITENE  H 130-  80 MY  U.V. 6 MESI NEUTRO','KG',   100,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '02.005.0747',0.2653336,'SEDE  ', 'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA','KG',   110,        'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CON', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '02.005.0785',0.5306670,'SEDE  ', 'ETICHETTA DADO 145 X 100 X .....                  ','NR',   120,        'ETICHETTA DADO 145 X 100 X .....                 ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,  DIS_TIPO, DIS_CODART,   DIS_QTA,  DIS_MAGA, DIS_DESCRI,                                          DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP10014595-3','A',      '02.005.0744',0.5306670,'SEDE  ', 'PALLETS 120X80 EPAL                               ','NR',   130,        'BANCALI                                          ', 1)

UPDATE PARA SET LIBERA = @_NextAggancioDiBa WHERE CODICE = 'NUMDIS'
-- ############################################################################################################################################

-- ############################################################################################################################################
-- DP145145100
SET @_NextAggancioDiBa = (SELECT LTRIM(RTRIM(STR(CAST(LIBERA AS NUMERIC(10,0)) + 1))) FROM PARA WHERE CODICE = 'NUMDIS')

INSERT INTO U_DIS_TT (	DIT_CODSOC,	TAGGANCIO,			DIT_GRUPPO,		DIT_DESCRI,					DIT_UM,	DIT_MAGA,	DIT_LINEA,	DIT_CODIVA)
	VALUES (			'01',		@_NextAggancioDiBa,	'DP145145100',	'DADI PRESSATI 145X145X100',	'MC',	'SEDE',		'05',		'21')

INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '01.001.0003', 0.3150000, 'LEGNAM', 'MISTO PIOPPO                                      ', 'T ',   10 ,        'MISTO PIOPPO                                      ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '01.001.0005', 0.1260000, 'LEGNAM', 'CIMALI                                            ', 'T ',   20 ,        'CIMALI                                            ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '01.001.0006', 0.1260000, 'LEGNAM', 'CEPPE DI PIOPPO                                   ', 'T ',   30 ,        'CEPPE DI PIOPPO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '01.001.0012', 0.3150000, 'LEGNAM', 'CIPPATO TIPO B                                    ', 'T ',   40 ,        'CIPPATO TIPO B                                    ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '01.001.0021', 0.7350000, 'LEGNAM', 'RICICLATO                                         ', 'T ',   50 ,        'RICICLATO                                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '01.002.0004', 0.0860000, 'SEDE  ', 'COLLA CON MELAMINA AL 10%                         ', 'T ',   60 ,        'COLLA CON MELAMINA AL 10%                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '01.004.0005', 10.000000, 'SEDE  ', 'EMULSIONE DI PARAFINA                             ', 'KG',   70 ,        'EMULSIONE DI PARAFINA                             ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '01.004.0004', 6.0000000, 'SEDE  ', 'AMMONIO SOLFATO                                   ', 'KG',   80 ,        'AMMONIO SOLFATO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '02.005.0745', 4.0801100, 'SEDE  ', 'CARTONE 1200X890 TIPO MMM/222/E                   ', 'NR',   90 ,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '02.005.0748', 0.0000000, 'SEDE  ', 'FOGLIA POLITENE  H 130-  80 MY  U.V. 6 MESI NEUTRO', 'KG',   100,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '02.005.0747', 0.2914364, 'SEDE  ', 'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 'KG',   110,        'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '02.005.0787', 0.5828729, 'SEDE  ', 'ETICHETTA DADO 145 X 145 X .....                  ', 'NR',   120,        'ETICHETTA DADO 145 X 145 X .....                  ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100', 'A',      '02.005.0744', 0.5828729, 'SEDE  ', 'PALLETS 120X80 EPAL                               ', 'NR',   130,        'BANCALI                                           ', 1)

UPDATE PARA SET LIBERA = @_NextAggancioDiBa WHERE CODICE = 'NUMDIS'
-- ############################################################################################################################################

-- ############################################################################################################################################
-- DP145145100-2
SET @_NextAggancioDiBa = (SELECT LTRIM(RTRIM(STR(CAST(LIBERA AS NUMERIC(10,0)) + 1))) FROM PARA WHERE CODICE = 'NUMDIS')

INSERT INTO U_DIS_TT (	DIT_CODSOC,	TAGGANCIO,			DIT_GRUPPO,		DIT_DESCRI,					DIT_UM,	DIT_MAGA,	DIT_LINEA,	DIT_CODIVA)
	VALUES (			'01',		@_NextAggancioDiBa,	'DP145145100-2',	'DADI PRESSATI 145X145X100 (SECONDA SCELTA)',	'MC',	'SEDE',		'05',		'21')

INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '01.001.0003', 0.3150000, 'LEGNAM', 'MISTO PIOPPO                                      ', 'T ',   10 ,        'MISTO PIOPPO                                      ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '01.001.0005', 0.1260000, 'LEGNAM', 'CIMALI                                            ', 'T ',   20 ,        'CIMALI                                            ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '01.001.0006', 0.1260000, 'LEGNAM', 'CEPPE DI PIOPPO                                   ', 'T ',   30 ,        'CEPPE DI PIOPPO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '01.001.0012', 0.3150000, 'LEGNAM', 'CIPPATO TIPO B                                    ', 'T ',   40 ,        'CIPPATO TIPO B                                    ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '01.001.0021', 0.7350000, 'LEGNAM', 'RICICLATO                                         ', 'T ',   50 ,        'RICICLATO                                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '01.002.0004', 0.0860000, 'SEDE  ', 'COLLA CON MELAMINA AL 10%                         ', 'T ',   60 ,        'COLLA CON MELAMINA AL 10%                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '01.004.0005', 10.000000, 'SEDE  ', 'EMULSIONE DI PARAFINA                             ', 'KG',   70 ,        'EMULSIONE DI PARAFINA                             ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '01.004.0004', 6.0000000, 'SEDE  ', 'AMMONIO SOLFATO                                   ', 'KG',   80 ,        'AMMONIO SOLFATO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '02.005.0745', 4.0801100, 'SEDE  ', 'CARTONE 1200X890 TIPO MMM/222/E                   ', 'NR',   90 ,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '02.005.0748', 0.0000000, 'SEDE  ', 'FOGLIA POLITENE  H 130-  80 MY  U.V. 6 MESI NEUTRO', 'KG',   100,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '02.005.0747', 0.2914364, 'SEDE  ', 'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 'KG',   110,        'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '02.005.0787', 0.5828729, 'SEDE  ', 'ETICHETTA DADO 145 X 145 X .....                  ', 'NR',   120,        'ETICHETTA DADO 145 X 145 X .....                  ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-2', 'A',      '02.005.0744', 0.5828729, 'SEDE  ', 'PALLETS 120X80 EPAL                               ', 'NR',   130,        'BANCALI                                           ', 1)

UPDATE PARA SET LIBERA = @_NextAggancioDiBa WHERE CODICE = 'NUMDIS'
-- ############################################################################################################################################

-- ############################################################################################################################################
-- DP145145100-3
SET @_NextAggancioDiBa = (SELECT LTRIM(RTRIM(STR(CAST(LIBERA AS NUMERIC(10,0)) + 1))) FROM PARA WHERE CODICE = 'NUMDIS')

INSERT INTO U_DIS_TT (	DIT_CODSOC,	TAGGANCIO,			DIT_GRUPPO,		DIT_DESCRI,					DIT_UM,	DIT_MAGA,	DIT_LINEA,	DIT_CODIVA)
	VALUES (			'01',		@_NextAggancioDiBa,	'DP145145100-3',	'DADI PRESSATI 145X145X100 (TERZA SCELTA/SCARTO)',	'MC',	'SEDE',		'05',		'21')

INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '01.001.0003', 0.3150000, 'LEGNAM', 'MISTO PIOPPO                                      ', 'T ',   10 ,        'MISTO PIOPPO                                      ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '01.001.0005', 0.1260000, 'LEGNAM', 'CIMALI                                            ', 'T ',   20 ,        'CIMALI                                            ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '01.001.0006', 0.1260000, 'LEGNAM', 'CEPPE DI PIOPPO                                   ', 'T ',   30 ,        'CEPPE DI PIOPPO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '01.001.0012', 0.3150000, 'LEGNAM', 'CIPPATO TIPO B                                    ', 'T ',   40 ,        'CIPPATO TIPO B                                    ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '01.001.0021', 0.7350000, 'LEGNAM', 'RICICLATO                                         ', 'T ',   50 ,        'RICICLATO                                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '01.002.0004', 0.0860000, 'SEDE  ', 'COLLA CON MELAMINA AL 10%                         ', 'T ',   60 ,        'COLLA CON MELAMINA AL 10%                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '01.004.0005', 10.000000, 'SEDE  ', 'EMULSIONE DI PARAFINA                             ', 'KG',   70 ,        'EMULSIONE DI PARAFINA                             ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '01.004.0004', 6.0000000, 'SEDE  ', 'AMMONIO SOLFATO                                   ', 'KG',   80 ,        'AMMONIO SOLFATO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '02.005.0745', 4.0801100, 'SEDE  ', 'CARTONE 1200X890 TIPO MMM/222/E                   ', 'NR',   90 ,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '02.005.0748', 0.0000000, 'SEDE  ', 'FOGLIA POLITENE  H 130-  80 MY  U.V. 6 MESI NEUTRO', 'KG',   100,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '02.005.0747', 0.2914364, 'SEDE  ', 'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 'KG',   110,        'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '02.005.0787', 0.5828729, 'SEDE  ', 'ETICHETTA DADO 145 X 145 X .....                  ', 'NR',   120,        'ETICHETTA DADO 145 X 145 X .....                  ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,         DIS_GRUPPO,    DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa,'DP145145100-3', 'A',      '02.005.0744', 0.5828729, 'SEDE  ', 'PALLETS 120X80 EPAL                               ', 'NR',   130,        'BANCALI                                           ', 1)

UPDATE PARA SET LIBERA = @_NextAggancioDiBa WHERE CODICE = 'NUMDIS'
-- ############################################################################################################################################

-- ############################################################################################################################################
-- DP14514578
SET @_NextAggancioDiBa = (SELECT LTRIM(RTRIM(STR(CAST(LIBERA AS NUMERIC(10,0)) + 1))) FROM PARA WHERE CODICE = 'NUMDIS')

INSERT INTO U_DIS_TT (	DIT_CODSOC,	TAGGANCIO,			DIT_GRUPPO,		DIT_DESCRI,					DIT_UM,	DIT_MAGA,	DIT_LINEA,	DIT_CODIVA)
	VALUES (			'01',		@_NextAggancioDiBa,	'DP14514578',	'DADI PRESSATI 145X145X78',	'MC',	'SEDE',		'05',		'21')

INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '01.001.0003', 0.3150000, 'LEGNAM', 'MISTO PIOPPO                                      ', 'T ',   10 ,        'MISTO PIOPPO                                      ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '01.001.0005', 0.1260000, 'LEGNAM', 'CIMALI                                            ', 'T ',   20 ,        'CIMALI                                            ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '01.001.0006', 0.1260000, 'LEGNAM', 'CEPPE DI PIOPPO                                   ', 'T ',   30 ,        'CEPPE DI PIOPPO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '01.001.0012', 0.3150000, 'LEGNAM', 'CIPPATO TIPO B                                    ', 'T ',   40 ,        'CIPPATO TIPO B                                    ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '01.001.0021', 0.7350000, 'LEGNAM', 'RICICLATO                                         ', 'T ',   50 ,        'RICICLATO                                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '01.002.0004', 0.0860000, 'SEDE  ', 'COLLA CON MELAMINA AL 10%                         ', 'T ',   60 ,        'COLLA CON MELAMINA AL 10%                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '01.004.0005', 10.000000, 'SEDE  ', 'EMULSIONE DI PARAFINA                             ', 'KG',   70 ,        'EMULSIONE DI PARAFINA                             ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '01.004.0004', 6.0000000, 'SEDE  ', 'AMMONIO SOLFATO                                   ', 'KG',   80 ,        'AMMONIO SOLFATO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '02.005.0745', 4.2345464, 'SEDE  ', 'CARTONE 1200X890 TIPO MMM/222/E                   ', 'NR',   90 ,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '02.005.0748', 0.0000000, 'SEDE  ', 'FOGLIA POLITENE  H 130-  80 MY  U.V. 6 MESI NEUTRO', 'KG',   100,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '02.005.0747', 0.3024676, 'SEDE  ', 'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 'KG',   110,        'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '02.005.0786', 0.6049352, 'SEDE  ', 'ETICHETTA DADO 145 X 145 X 78                     ', 'NR',   120,        'ETICHETTA DADO 145 X 145 X 78                     ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578', 'A',      '02.005.0744', 0.6049352, 'SEDE  ', 'PALLETS 120X80 EPAL                               ', 'NR',   130,        'BANCALI                                           ', 1)

UPDATE PARA SET LIBERA = @_NextAggancioDiBa WHERE CODICE = 'NUMDIS'
-- ############################################################################################################################################

-- ############################################################################################################################################
-- DP14514578-2
SET @_NextAggancioDiBa = (SELECT LTRIM(RTRIM(STR(CAST(LIBERA AS NUMERIC(10,0)) + 1))) FROM PARA WHERE CODICE = 'NUMDIS')

INSERT INTO U_DIS_TT (	DIT_CODSOC,	TAGGANCIO,			DIT_GRUPPO,		DIT_DESCRI,					DIT_UM,	DIT_MAGA,	DIT_LINEA,	DIT_CODIVA)
	VALUES (			'01',		@_NextAggancioDiBa,	'DP14514578-2',	'DADI PRESSATI 145X145X78 (SECONDA SCELTA)',	'MC',	'SEDE',		'05',		'21')

INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '01.001.0003', 0.3150000, 'LEGNAM', 'MISTO PIOPPO                                      ', 'T ',   10 ,        'MISTO PIOPPO                                      ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '01.001.0005', 0.1260000, 'LEGNAM', 'CIMALI                                            ', 'T ',   20 ,        'CIMALI                                            ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '01.001.0006', 0.1260000, 'LEGNAM', 'CEPPE DI PIOPPO                                   ', 'T ',   30 ,        'CEPPE DI PIOPPO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '01.001.0012', 0.3150000, 'LEGNAM', 'CIPPATO TIPO B                                    ', 'T ',   40 ,        'CIPPATO TIPO B                                    ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '01.001.0021', 0.7350000, 'LEGNAM', 'RICICLATO                                         ', 'T ',   50 ,        'RICICLATO                                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '01.002.0004', 0.0860000, 'SEDE  ', 'COLLA CON MELAMINA AL 10%                         ', 'T ',   60 ,        'COLLA CON MELAMINA AL 10%                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '01.004.0005', 10.000000, 'SEDE  ', 'EMULSIONE DI PARAFINA                             ', 'KG',   70 ,        'EMULSIONE DI PARAFINA                             ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '01.004.0004', 6.0000000, 'SEDE  ', 'AMMONIO SOLFATO                                   ', 'KG',   80 ,        'AMMONIO SOLFATO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '02.005.0745', 4.2345464, 'SEDE  ', 'CARTONE 1200X890 TIPO MMM/222/E                   ', 'NR',   90 ,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '02.005.0748', 0.0000000, 'SEDE  ', 'FOGLIA POLITENE  H 130-  80 MY  U.V. 6 MESI NEUTRO', 'KG',   100,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '02.005.0747', 0.3024676, 'SEDE  ', 'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 'KG',   110,        'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '02.005.0786', 0.6049352, 'SEDE  ', 'ETICHETTA DADO 145 X 145 X 78                     ', 'NR',   120,        'ETICHETTA DADO 145 X 145 X 78                     ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-2', 'A',      '02.005.0744', 0.6049352, 'SEDE  ', 'PALLETS 120X80 EPAL                               ', 'NR',   130,        'BANCALI                                           ', 1)

UPDATE PARA SET LIBERA = @_NextAggancioDiBa WHERE CODICE = 'NUMDIS'
-- ############################################################################################################################################

-- ############################################################################################################################################
-- DP14514578-3
SET @_NextAggancioDiBa = (SELECT LTRIM(RTRIM(STR(CAST(LIBERA AS NUMERIC(10,0)) + 1))) FROM PARA WHERE CODICE = 'NUMDIS')

INSERT INTO U_DIS_TT (	DIT_CODSOC,	TAGGANCIO,			DIT_GRUPPO,		DIT_DESCRI,					DIT_UM,	DIT_MAGA,	DIT_LINEA,	DIT_CODIVA)
	VALUES (			'01',		@_NextAggancioDiBa,	'DP14514578-3',	'DADI PRESSATI 145X145X78 (TERZA SCELTA/SCARTO)',	'MC',	'SEDE',		'05',		'21')

INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '01.001.0003', 0.3150000, 'LEGNAM', 'MISTO PIOPPO                                      ', 'T ',   10 ,        'MISTO PIOPPO                                      ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '01.001.0005', 0.1260000, 'LEGNAM', 'CIMALI                                            ', 'T ',   20 ,        'CIMALI                                            ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '01.001.0006', 0.1260000, 'LEGNAM', 'CEPPE DI PIOPPO                                   ', 'T ',   30 ,        'CEPPE DI PIOPPO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '01.001.0012', 0.3150000, 'LEGNAM', 'CIPPATO TIPO B                                    ', 'T ',   40 ,        'CIPPATO TIPO B                                    ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '01.001.0021', 0.7350000, 'LEGNAM', 'RICICLATO                                         ', 'T ',   50 ,        'RICICLATO                                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '01.002.0004', 0.0860000, 'SEDE  ', 'COLLA CON MELAMINA AL 10%                         ', 'T ',   60 ,        'COLLA CON MELAMINA AL 10%                         ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '01.004.0005', 10.000000, 'SEDE  ', 'EMULSIONE DI PARAFINA                             ', 'KG',   70 ,        'EMULSIONE DI PARAFINA                             ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '01.004.0004', 6.0000000, 'SEDE  ', 'AMMONIO SOLFATO                                   ', 'KG',   80 ,        'AMMONIO SOLFATO                                   ', 0)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '02.005.0745', 4.2345464, 'SEDE  ', 'CARTONE 1200X890 TIPO MMM/222/E                   ', 'NR',   90 ,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '02.005.0748', 0.0000000, 'SEDE  ', 'FOGLIA POLITENE  H 130-  80 MY  U.V. 6 MESI NEUTRO', 'KG',   100,        'CARTONE INTERNO 80X1200 PER IMBALLAGGIO PALLET DI ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '02.005.0747', 0.3024676, 'SEDE  ', 'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 'KG',   110,        'FILM ESTENSIBILE MACCHINABILE  25 MY(COMPRESO CONA', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '02.005.0786', 0.6049352, 'SEDE  ', 'ETICHETTA DADO 145 X 145 X 78                     ', 'NR',   120,        'ETICHETTA DADO 145 X 145 X 78                     ', 1)
INSERT INTO U_DIS_DD (	DAGGANCIO,          DIS_GRUPPO,   DIS_TIPO, DIS_CODART,    DIS_QTA,   DIS_MAGA, DIS_DESCRI,                                           DIS_UM, DIS_SEQUEN, DIS_DSNOCQ,                                         DIS_CMPIMB)
	VALUES (			@_NextAggancioDiBa, 'DP14514578-3', 'A',      '02.005.0744', 0.6049352, 'SEDE  ', 'PALLETS 120X80 EPAL                               ', 'NR',   130,        'BANCALI                                           ', 1)

UPDATE PARA SET LIBERA = @_NextAggancioDiBa WHERE CODICE = 'NUMDIS'
-- ############################################################################################################################################

SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = 'DP10014578'
SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = 'DP10014578' ORDER BY DIS_SEQUEN

SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = 'DP10014578-2'
SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = 'DP10014578-2' ORDER BY DIS_SEQUEN

SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = 'DP10014578-3'
SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = 'DP10014578-3' ORDER BY DIS_SEQUEN

SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = 'DP10014595'
SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = 'DP10014595' ORDER BY DIS_SEQUEN

SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = 'DP10014595-2'
SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = 'DP10014595-2' ORDER BY DIS_SEQUEN

SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = 'DP10014595-3'
SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = 'DP10014595-3' ORDER BY DIS_SEQUEN

SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = 'DP145145100'
SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = 'DP145145100' ORDER BY DIS_SEQUEN

SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = 'DP145145100-2'
SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = 'DP145145100-2' ORDER BY DIS_SEQUEN

SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = 'DP145145100-3'
SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = 'DP145145100-3' ORDER BY DIS_SEQUEN

SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = 'DP14514578'
SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = 'DP14514578' ORDER BY DIS_SEQUEN

SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = 'DP14514578-2'
SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = 'DP14514578-2' ORDER BY DIS_SEQUEN

SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = 'DP14514578-3'
SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = 'DP14514578-3' ORDER BY DIS_SEQUEN



