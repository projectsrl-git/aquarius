DO SETLIB

=DEF_VIP()

SET STEP ON 

=CREA_SALDI_CF("F","0209000000603","000000","XXXXXXXXXX","CREACF")    && RICREA SALDI SU TUTTO IL FORNITORE


*=CREA_SALDI_CF("F","2202002002303",'501042',"XXXXXXXXXX","A","NO","ESTRAITUTTELEPARTITE")
*=CREA_SALDI_CF("F","2202002002303",'501042',"XXXXXXXXXX","A","NO","ESTRAILEPARTITEDELCLIENTE-FORNITORE")

*=CREA_SALDI_CF("C","2202002002303",'501042',"XXXXXXXXXX","CREA","NO","ESTRAITUTTELEPARTITE")



RETURN



*!*	=CREA_SALDI_CF("F","TUTTO",'99999998',"XXXXXXXXXX","CREA")


*!*	=CREA_SALDI_CF("F","2202002002303",'501042',"XXXXXXXXXX","A")
*!*	=CREA_SALDI_CF("F","2202002002303",'501042',"XXXXXXXXXX","C")
*!*	=CREA_SALDI_CF("F","2202002002303",'501042',"XXXXXXXXXX","T")

*=CREA_SALDI_CF("C","1090900901040",'500935',"XXXXXXXXXX","CREA")
*=CREA_SALDI_CF("C","1090900901040",'500935',"XXXXXXXXXX","ANNUA")
*=CREA_SALDI_CF("C","1090900901040",'99999998',"XXXXXXXXXX","T")
*=CREA_SALDI_CF("C","TUTTO",'99999998',"XXXXXXXXXX","T")

*!*	=CREA_SALDI_CF("F","2202002002303",'501042',"XXXXXXXXXX","ANNU")
*!*	=CREA_SALDI_CF("F","2202002002303",'501042',"XXXXXXXXXX","ANNUA")
*!*	=CREA_SALDI_CF("F","2202002002303",'501042',"XXXXXXXXXX","ANNUC")


*=CREA_SALDI_CF("F","2202002002303",'99999998',"XXXXXXXXXX","T")
*=CREA_SALDI_CF("F","2202002002303",'99999998',"XXXXXXXXXX","A")
*=CREA_SALDI_CF("F","2202002002303",'99999998',"XXXXXXXXXX","C")
*=CREA_SALDI_CF("F","2202002002303",'500934',"XXXXXXXXXX","ANNU")
*=CREA_SALDI_CF("F","2202002002303",'500934',"XXXXXXXXXX","CREA")
*=CREA_SALDI_CF("F","2202002002303",'500934',"XXXXXXXXXX","ANNUA")
*=CREA_SALDI_CF("F","2202002002303",'500934',"XXXXXXXXXX","ANNUC")

*!*	=CREA_SALDI_CF("F","2202002002303",'99999998',"XXXXXXXXXX","C")
*=CREA_SALDI_CF("F","TUTTO",'99999998',"XXXXXXXXXX","ANNU")

*=CREA_SALDI_CF("C","TUTTO",'99999998',"XXXXXXXXXX","CREA")
*=CREA_SALDI_CF("C","TUTTO",'99999998',"XXXXXXXXXX","ANNU")

*=CREA_SALDI_CF("F","TUTTO",'99999998',"XXXXXXXXXX","A")


*!*	=CREA_SALDI_CF("C","1090900901040",'99999998',"XXXXXXXXXX","T")

*!*	*******<<<<<
*!*	=CREA_SALDI_CF("F","2202006000337","99999998","XXXXXXXXXX","A")
*!*	SELECT CUR_SALDI_FOR
*!*	GO TOP
*!*	BROWSE NORMAL
*!*	=CREA_SALDI_CF("F","2202006000337","99999998","XXXXXXXXXX","A","SI")
*!*	SELECT PARTITECF
*!*	GO TOP
*!*	BROWSE NORMAL

*!*	*******<<<<<
*******<<<<<
*!*	=CREA_SALDI_CF("C","TUTTO","99999998","XXXXXXXXXX","A")
*!*	SELECT CUR_SALDI_CLI
*!*	GO TOP
*!*	REPLACE PAR_ESTRAIPARTITA WITH .T. ALL
*!*	GO TOP
*!*	BROWSE NORMAL
*!*	=CREA_SALDI_CF("C","TUTTO","99999998","XXXXXXXXXX","A","SI")
*!*	SELECT PARTITECF
*!*	GO TOP
*!*	BROWSE NORMAL

*******<<<<<
RETURN



*!*	SELECT par_cosatratta,par_gradoimportanza,par_formapagamento,par_tipocontratto,par_codacq,par_pripaga,par_codcli,par_npart,par_dtscad, SUM(par_fatt) AS par_fattd,000000.00 as par_fatta 
*!*	FROM part_for
*!*	WHERE PAR_NPROG > 100 AND PAR_TMOV = 'D'
*!*	GROUP BY par_cosatratta,par_gradoimportanza,par_formapagamento,par_tipocontratto,par_codacq,par_pripaga,par_codcli,par_npart,par_dtscad
*!*	ORDER BY par_cosatratta,par_gradoimportanza,par_formapagamento,par_tipocontratto,par_codacq,par_pripaga,par_codcli,par_npart,par_dtscad


__campi__="par_cosatratta,par_gradoimportanza,par_formapagamento,par_tipocontratto,par_codacq,par_pripaga,par_codcli,par_npart,par_dtscad"
__somma__=", SUM(par_fatt) AS par_fattd,00000000.000 as par_fatta"
__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'D' AND PAR_NPART = '501042'"

cSql="SELECT "+__campi__+__somma__+" FROM PART_FOR WHERE " + __condi__ +  ;
    					                          " group by "+__campi__+" order by PAR_CODCLI"

        
IF !ExecCommand(cSql,"cur_dare")
   return(.f.)
ENDIF


__campi__="par_cosatratta,par_gradoimportanza,par_formapagamento,par_tipocontratto,par_codacq,par_pripaga,par_codcli,par_npart,par_dtscad"
__somma__=", 00000000.000 AS par_fattd, SUM(par_fatt) AS par_fatta"
__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'A' AND PAR_NPART = '501042'"

cSql="SELECT "+__campi__+__somma__+" FROM PART_FOR WHERE " + __condi__ +  ;
    					                          " group by "+__campi__+" order by PAR_CODCLI"

        
IF !ExecCommand(cSql,"cur_avere")
   return(.f.)
ENDIF



SELECT * FROM cur_dare UNION SELECT * FROM cur_avere INTO CURSOR cur_da 




__campi__="par_cosatratta,par_gradoimportanza,par_formapagamento,par_tipocontratto,par_codacq,par_pripaga,par_codcli,par_npart,par_dtscad"
__somma__=",SUM(par_fattd-par_fatta) AS par_fatt"
__condi__="1=1"

cSql="SELECT "+__campi__+__somma__+" FROM CUR_DA WHERE " + __condi__ +  ;
    					                          " group by "+__campi__+" INTO CURSOR cu_saldi_for"

&CSQL
        
* PARTITE APERTE
SELECT * FROM cu_saldi_for WHERE PAR_FATT <> 0 INTO CURSOR CU_APERTE_FOR

SELECT CU_APERTE_FOR
BROWSE normal


