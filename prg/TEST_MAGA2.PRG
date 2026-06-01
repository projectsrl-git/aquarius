   
   
   
   
   DO SETLIB



   RELEASE XYZ_FORNIT,XYZ_RAGSOC,XYZ_PRZUCA,XYZ_RAGFOR
   PUBLIC  XYZ_FORNIT,XYZ_RAGSOC,XYZ_PRZUCA,XYZ_RAGFOR
   
   
   
   
   M.ORD_MAGA 	= "SEDE"
   M.ORD_MAGD	= ""
   M.ORD_CAUS 	= "001"
*!*	   M.ORD_FORNIT	= "000000148 "
*!*	   M.ORD_RAGFOR = "ACEA ELECTRABEL S.P.A."
   M.ORD_FORNIT	= ""	&& STO FACENDO NO SCARICO PER VENDIA LA ROUTINE
   M.ORD_RAGFOR = ""	&& MOVIMAGA MI DEVE RICERCARE AUTOMATICAMENTE IL PRIMO LOTTO CONSEGNATOMI DAL FORNITORE SU CUI SCARICRE 

   M.ORD_PRZULC = 31
   M.ORD_CODART = "TEST_DB         "
   M.ORD_QTAORD = 200
   M.ORD_NUMORD = "000017"
   M.ORD_DATORD = "2007/07/24"
   M.ORD_CODCLI = "000000015 "
   M.ORD_PRZNET = 15
   M.ORD_PRZCON = 4
   M.ORD_IVA    = "20 "
   M.ORD_SC1    = 0
   M.ORD_VALUTA = "EUR"
   M.ORD_LEGSYS = SYS(2015) 
   M.ORD_CODACQ = "001" 
   
   XYZ_FORNIT = M.ORD_FORNIT
   XYZ_RAGSOC = M.ORD_RAGFOR 
   XYZ_PRZUCA = M.ORD_PRZULC
   XYZ_RAGFOR = M.ORD_RAGFOR

   
   
   
   _TOPSCA = M.ORD_CAUS   

   v_seek   = 'TOP'+M.ORD_CAUS
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      _TOPCAR = SUBSTR(CODICE,4,3)   
      IMPE    = SUBSTR(LIBERA,26,1)
      CSC     = SUBSTR(LIBERA,25,1)
   ELSE
      _TOPCAR = '100 '  
      IMPE    = ' '
      CSC     = ' '
   ENDIF
   IF EMPTY(_TOPCAR) .OR. _TOPCAR = SPACE(03)
      _TOPCAR = '100 '  
   ENDIF
    

*****#################################################  OBSOLETA  
*!*	   H_DADOVE = 'BOLSCMAG'
*!*	   H_GENMOV = 'SI' 
*!*	   H_TIPO   = 'GIA'
*!*	   H_IMPE   = IMPE
*!*	   H_MAGSCA = M.ORD_MAGA
*!*	   H_MAGCAR = M.ORD_MAGD
*!*	   H_CODART = M.ORD_CODART
*!*	   H_TOPSCA = _TOPSCA
*!*	   H_TOPCAR = _TOPCAR
*!*	   H_QUANTI = M.ORD_QTAORD
*!*	   H_NUMDOC = M.ORD_NUMORD
*!*	   H_DATDOC = M.ORD_DATORD
*!*	   H_DATREG = RIBALTA2(DTOC(DATE()))
*!*	   H_ORAMOV = TIME()
*!*	   H_CLIFOR = M.ORD_CODCLI
*!*	   H_PRZACQ = 0   && ""
*!*	   H_PRZVEN = M.ORD_PRZNET
*!*	   H_CODIVA = M.ORD_IVA
*!*	   H_SCONTO = M.ORD_SC1
*!*	   H_VALUTA = M.ORD_VALUTA
*!*	   H_NOTE   = ""
*!*	   H_CSC    = CSC
*!*	   H_SAC    = ""   &&&  ????
*!*	   H_GGG    = "SI"
*!*	   H_FORNIT = M.ORD_FORNIT
*!*	   H_FLGTRA = .F.
*!*	   
*!*	 
*!*	   =MOVIMAGA(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_SAC,H_GGG,H_FORNIT,H_FLGTRA)


****###########################################  PROCEDURA DI SCARICO MAGAZZINO DA DDT


*!*	  H_DADOVE = 'PRODPEDANA'
*!*	  H_GENMOV = 'SI' 
*!*	  H_TIPO   = 'GIA'
*!*	  H_IMPE   = IMPE
*!*	  H_MAGSCA = M.ORD_MAGA
*!*	  H_MAGCAR = M.ORD_MAGD
*!*	  H_CODART = M.ORD_CODART
*!*	  H_TOPSCA = M.ORD_CAUS  
*!*	  H_TOPCAR = ""
*!*	  H_QUANTI = M.ORD_QTAORD
*!*	  H_NUMDOC = M.ORD_NUMORD
*!*	  H_DATDOC = M.ORD_DATORD
*!*	  H_DATREG = DTOC(DATE())	&& RIBALTA2(DTOC(DATE())
*!*	  H_ORAMOV = TIME()
*!*	  H_CLIFOR = ""    
*!*	  H_PRZACQ = ""
*!*	  H_PRZVEN = M.ORD_PRZNET
*!*	  H_CODIVA = ""    			&& M.ORD_IVA
*!*	  H_SCONTO = 0     			&& M.ORD_SC1
*!*	  H_VALUTA = ""    			&& M.ORD_VALUTA
*!*	  H_NOTE   = ""
*!*	  H_CSC    = M.ORD_CODCLI
*!*	  H_GGG    = "SI"
*!*	  H_FORNIT = ""				&& M.ORD_FORNIT
*!*	  H_FLGTRA = .F.
*!*	  H_LEGSYS = M.ORD_LEGSYS
*!*	  H_LEGAME = ""
*!*	  =MOVIMAGAZ(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_GGG,H_FORNIT,H_FLGTRA,H_LEGSYS,H_LEGAME)





******#################### GESTIONE MAGAZZINO STANDARD

*!*	con questa gestione è possibile :

*!*	scaricare / caricare il magazzino di un articolo SL/PF
*!*	scaricare / caricare il magazzino di un articolo MP

*!*	ESISTE UN PROBLEMA
*!*	è necessario sicronizzare gli scarichi in quanto il programma se scarico più della qta in giacenza mette la qta in giacenza A ZERO su U_MAG_GG 
*!*	e scrive comunque in forma corretta il movimento su U_MAG_MO (IN PRATICA NON VA MAI IN NEGATIVO , QUESTA PUO' ESSERE UNA SCELTA MA O SI 
*!*	FANNO DEI CONTROLLI FERREI O SI VA IN NEGATIVO ANCHE SU U_MAG_GG)

*!*	mi pongo un problema PER VRIFICARE SE TUTTO GIRA :
*!*	devo scricare di TEST_DB 10 pezzi dal reparto produzione e caricarli sul MAGAZZINO EVASIONE
*!*	MAGA.   ARTICOLO   SEGNO  QTA
*!*	PROD     TEST_DB     -     10     QUANDO SCARICO QUESTI 10 DO PER SCONTATO CHE 
*!*	PROD     TEST_MAG    -     20     20 PEZZI DI TEST_MAG E 0 PEZZI DI TET_MAG2 SONO EFFETTIVAMENTE
*!*	PROD     TEST_MAG2   -     30     STATI USATI (ALTRIMENTI NON POTEVO VARE 10 PZZI DI TEST_DB)


*!*	SEDE     TEST_MAG2   +     30     OVVIAMENTE FACCIO SOLO IL CARICO NEL MAGAZZIO EVASIONE 
*!*										  (SE PERO' DEVO FARE DEGLI SPOSTAMENTI TRA' UN MAGAZZINO E L'ALTRO
*!*										   DEVO GENERARE ANCHE I MOVIMENTI DI CARICO
*!*												SEDE    TEST_DB     +     10
*!*												SEDE	TEST_MAG    +     20

*!*	PER ORA SEMBRA FUNZIONARE !!!!!

 H_DADOVE = 'BOLSCMAG'
 H_GENMOV = 'SI' 
 H_TIPO   = 'GIA'
 H_IMPE   = IMPE
 H_MAGSCA = M.ORD_MAGA
 H_MAGCAR = M.ORD_MAGD
 H_CODART = M.ORD_CODART
 H_TOPSCA = _TOPSCA
 H_TOPCAR = _TOPCAR
 H_QUANTI = M.ORD_QTAORD
 H_NUMDOC = M.ORD_NUMORD
 H_DATDOC = M.ORD_DATORD
 H_DATREG = RIBALTA2(DTOC(DATE()))
 H_ORAMOV = TIME()
 H_CLIFOR = M.ORD_CODCLI
 H_PRZACQ = M.ORD_PRZCON
 H_PRZVEN = M.ORD_PRZNET
 H_CODIVA = M.ORD_IVA
 H_SCONTO = M.ORD_SC1
 H_VALUTA = M.ORD_VALUTA
 H_NOTE   = ""
 H_CSC    = M.ORD_CODCLI
 H_GGG    = "SI"
 H_FORNIT = M.ORD_FORNIT
 H_FLGTRA = .F.
 H_LEGSYS = M.ORD_LEGSYS
 H_LEGAME = M.ORD_CODACQ
 =MOVIMAGAZ(H_DADOVE,H_GENMOV,H_TIPO,H_IMPE,H_MAGSCA,H_MAGCAR,H_CODART,H_TOPSCA,H_TOPCAR,H_QUANTI,H_NUMDOC,H_DATDOC,H_DATREG,H_ORAMOV,H_CLIFOR,H_PRZACQ,H_PRZVEN,H_CODIVA,H_SCONTO,H_VALUTA,H_NOTE,H_CSC,H_GGG,H_FORNIT,H_FLGTRA,H_LEGSYS,H_LEGAME)




   **  Lancio procedura di carico/scarico componenti in automatico se TOP lo prevede

   IF CSC = 'X'
      SSSS=SELECT()
      x_soci = "dit_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "dit_gruppo = '" + ALLTRIM(M.ORD_CODART) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_dis_tt where " + x_cond + " order by dit_codsoc,dit_gruppo"
      IF !ExecCommand(cSql,"cur_diba")
         return(.f.)
      ENDIF
      SELECT cur_diba
      GO TOP
      IF EOF()
      ELSE
         TP = 'S'
         RELEASE W_MAGAZ,W_QUANTI
         PUBLIC  W_MAGAZ,W_QUANTI
         W_MAGAZ  = M.ORD_MAGA
         W_QUANTI = M.ORD_QTAORD
         DO ALBERELLO WITH .F.,M.ORD_CODART
         DO CARI_COMP WITH "BOL"
      ENDIF
      SELECT(SSSS)
   ENDIF






