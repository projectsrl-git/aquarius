**********************************************************************************************
* 			 SBLOCCO DELLE REGISTRAZIONI PER LA SICCESSIVA RIELABORAZIONE					 *
*			 RELATIVE ALLE COMPENSAZIONI IVA CEE / REVERSE CHANGE			 				 *
**********************************************************************************************
PUBLIC PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG,XDESF,V_PESO,XNPRO,XNUMPRO,NOTAC,DATA_SCAD,CT,XXCONTO
RELEASE NPROT,__CEE
PUBLIC  NPROT,__CEE


XDESF     = "REGISTRAZIONE AUTOMATICA"
COMPENSO  = 0
TIVA      = 0
CIVA      = 0
TOP_TOP   = SPACE(03)
DATREG    = XDATA      && FORZA LA DATA DI REGISTRAZIONE CON LA DATA DIGITATA
NOTAC     = " "
DATA_SCAD = ""

RELEASE ct_FAT_IVACEE,ct_NOT_IVACEE,ct_FAT_RC,ct_NOT_RC,CTRAGG 
PUBLIC ct_FAT_IVACEE,ct_NOT_IVACEE,ct_FAT_RC,ct_NOT_RC,CTRAGG 

ct_FAT_IVACEE			= 0
ct_NOT_IVACEE			= 0
ct_FAT_RC				= 0
ct_NOT_RC				= 0

CTRAGG = 0

IF !ExecCommand("select * from mov_cont where 1=0","mov_cont")
   return(.f.)
ENDIF
SELECT MOV_CONT
HH=AFIELDS(TRANSITO)
CREATE CURSOR CMOV_CONT FROM ARRAY TRANSITO

PUBLIC M.TAGGANCIO
M.TAGGANCIO = ""

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT


ANNODAL  = SUBSTR(DATADAL,7,4)
V_TOTALE = 0
CT       = 0
CTRELAB  = 0
PERDAL   = RIBALTA2(DATADAL)
PERAL    = RIBALTA2(DATAAL)
CT       = 0
CTRELAB  = 0
V_IVACEE = SPACE(20)


IF !EMPTY(NREGDAL)
	x_soci = "mov_soc = '" + PUB_CODSOC + "'"
	x_anno = "mov_anno = '" + ANNODAL + "'"
	x_data = "mov_dtreg >= '" + PERDAL + "'"
	x_nregdal = "mov_nregis between '" + nregdal + "'" + " and '" + nregal + "'"
		
	cSql="SELECT * FROM mov_cont WHERE " + x_soci + " and " + x_anno + " and " + x_data + " and " + x_nregdal +;
	                                   " order by mov_soc,mov_anno,mov_dtreg,mov_numpro"
	IF !ExecCommand(cSql,"CU_MOVCONT")
	   return(.f.)
	ENDIF	                                   

ELSE

	x_soci = "mov_soc = '" + PUB_CODSOC + "'"
	x_anno = "mov_anno = '" + ANNODAL + "'"
	x_data = "mov_dtreg >= '" + PERDAL + "'"
	cSql="SELECT * FROM mov_cont WHERE " + x_soci + " and " + x_anno + " and " + x_data + ;
	                                   " order by mov_soc,mov_anno,mov_dtreg,mov_numpro"
	IF !ExecCommand(cSql,"CU_MOVCONT")
	   return(.f.)
	ENDIF	                                   
ENDIF                                   


SELECT CU_MOVCONT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF MOV_DTREG > PERAL
      EXIT
   ENDIF
 

   SELECT CU_MOVCONT
   _TOP=MOV_TOP

   v_seek	= 'TOP' + _TOP
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
	  CEE = SUBSTR(LIBERA,23,1)
      _NOTAC  	=SUBSTR(LIBERA,11,1)			&& NOTA CREDITO = S
   ELSE
	  CEE = " "
	  _NOTAC= " "
   ENDIF

   SELECT CU_MOVCONT


   IF CEE = "E"  OR CEE = "R"
   ELSE
      SELECT CU_MOVCONT
	  SKIP +1
	  LOOP
   ENDIF
 
   SELECT CU_MOVCONT

  
   SCATTER MEMVAR MEMO	    && Salva i vecchi valori

   _AGGIORNA = .F.

   IF SBLOCCA_FAT_IVACEE
     IF M.MOV_FATCE = 'S'
		ct_FAT_IVACEE			= ct_FAT_IVACEE +1
		_AGGIORNA = .T.
     ENDIF
   ENDIF

   IF SBLOCCA_NOT_IVACEE			
     IF M.MOV_NOTCE = 'S'
		ct_NOT_IVACEE			= ct_NOT_IVACEE +1
	    _AGGIORNA = .T.
     ENDIF
   ENDIF

   IF SBLOCCA_FAT_REVERSE_CHANGE	
     IF M.MOV_FATRC = 'S'
		ct_FAT_RC	= ct_FAT_RC +1
	    _AGGIORNA = .T.
     ENDIF
   ENDIF

   IF SBLOCCA_NOT_REVERSE_CHANGE	
     IF M.MOV_NOTRC = 'S'
		ct_NOT_RC	= ct_NOT_RC +1
	    _AGGIORNA = .T.
     ENDIF
   ENDIF


   CTRELAB=CTRELAB+1 
   WAIT WINDOWS "Fatture Fornitori elaborate : "+STR(CTRELAB,6,0) NOWAIT

   IF  _AGGIORNA 
	   =CEI_AGGIORNA_MOV_CONT()
   ENDIF
   		
   SELECT CU_MOVCONT
   SKIP +1

ENDDO 

IF CTRAGG <> 0
   =MESSAGEBOX("Sblocco registrazioni contabili compensazioni iva cee / reverse change"+CHR(13)+"terminata correttamente",16,"*** ATTENZIONE ***") 
   WAIT WINDOWS "N.fat.iva cee sbloccate :"+STR(ct_FAT_IVACEE,4,0)+CHR(13)+"N.not.iva cee sbloccate :"+STR(ct_NOT_IVACEE,4,0)+CHR(13)+"N.fat.revese ch. sbloccate :"+STR(ct_FAT_RC,4,0)+CHR(13)+"N.not.revese ch. sbloccate :"+STR(ct_NOT_RC,4,0)
ELSE
   =MESSAGEBOX("Nessun movimento sbloccato"+CHR(13)+"",16,"*** ATTENZIONE ***") 
ENDIF

RETURN

  

********************************  
FUNCTION CEI_AGGIORNA_MOV_CONT			&& AGGIORNA FLAG DI COMPENSAZIONE CREATA
********************************
AABBSS    = SELECT()

SELECT CU_MOVCONT

__id_unique = id_unique

x_id_unique = "id_unique= '" + __id_unique+ "'"

cSql="SELECT * FROM mov_cont WHERE " + x_id_unique + ;
                                   " order by mov_soc,mov_anno,mov_dtreg,mov_numpro"
IF !ExecCommand(cSql,"A_MOV_CONT")
   return(.f.)
ENDIF

SELECT A_MOV_CONT




   IF SBLOCCA_FAT_IVACEE
     IF M.MOV_FATCE = 'S'
		REPLACE MOV_FATCE WITH " "	
		CTRAGG  = CTRAGG  + 1	
     ENDIF
   ENDIF

   IF SBLOCCA_NOT_IVACEE			
     IF M.MOV_NOTCE = 'S'
		REPLACE MOV_NOTCE WITH " "		
		CTRAGG  = CTRAGG  + 1
     ENDIF
   ENDIF

   IF SBLOCCA_FAT_REVERSE_CHANGE	
     IF M.MOV_FATRC = 'S'
		REPLACE MOV_FATRC WITH " "		
		CTRAGG  = CTRAGG  + 1
     ENDIF
   ENDIF

   IF SBLOCCA_NOT_REVERSE_CHANGE	
     IF M.MOV_NOTRC = 'S'
		REPLACE MOV_NOTRC WITH " "		
		CTRAGG  = CTRAGG  + 1
     ENDIF
   ENDIF




IF !ExecRW('','mov_cont','I','','A_MOV_CONT')
   return(.f.)
ENDIF

SELECT(AABBSS)

RETURN
