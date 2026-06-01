

D_FILE=SYS(5)+SYS(2003)+"\documenti\budget.xls"		&& PRENDE IL DOCUMENTO EXCEL ORIGINALE (TEMPLATE)
A_FILE=SYS(5)+SYS(2003)+"\Budget_excel\"

A_FILE=GETDIR(A_FILE,"Memorizza in:")

A_FILE=A_FILE+"Budget_del_"+dtos(DATE())			&& NOME EXCEL DI DESTINAZIONE

A_FILE=STRTRAN(A_FILE,"/","_")
A_FILE=STRTRAN(A_FILE,"-","_")
A_FILE=STRTRAN(A_FILE,".","_")
A_FILE=STRTRAN(A_FILE,"*","_")
A_FILE=STRTRAN(A_FILE," ","")
A_FILE=A_FILE+".XLS"

release oexcel, w_row
public oexcel, w_row
local obook, orange

oexcel=createobject("excel.application")
oexcel.Workbooks.Open(D_FILE).SaveAs(a_file)
oexcel.Workbooks.Open(a_file)
oexcel.visible=.t.

w_row=8								&& INDICA LA RIGA DI EXCEL

IF TIPO = 1							&&& BUDGET OPERATIVO
	T_BUDGET = "OPERATIVO"
ELSE								&&& BUDGET INIZIALE
	T_BUDGET = "INIZIALE"
ENDIF	
SELECT cur_budget
oexcel.range("G2").value = alltrim("STAMPA BUDGET ")+ t_budget

oexcel.range("G3").value = alltrim("Periodo  ") + RIBALTA2(v_data) + ' - '+ v_descri

*!*	 	.range(_rag1).font.name="Times New Roman"
*!*		.range(_rag1).font.size=8
*!*		.range(_rag1).font.bold=.f.
*!*		.range(_rag1).columnwidth = 15
*!*		.range(_rag1).columnbackcolor = "192.192.192"

SELECT cur_budget
GO top
scan
	with oexcel.activesheet
	    _rag1="A"+alltrim(str(w_row))			&& COLONNA A  - RIGA 8 (INIZIALE)
		.range(_rag1).value=art_codpri
		
	    _rag1="B"+alltrim(str(w_row))
		.range(_rag1).value=art_descr

	    _rag1="C"+alltrim(str(w_row))
		.range(_rag1).value=v_qta
		.range(_rag1).numberformat="###,###,##0.00"

	    _rag1="D"+alltrim(str(w_row))
		.range(_rag1).value=v_qtakg
		.range(_rag1).numberformat="###,###,##0.00"
		
	    _rag1="E"+alltrim(str(w_row))
		.range(_rag1).value=v_przven
		.range(_rag1).numberformat="###,###,##0.00"
		
	    _rag1="F"+alltrim(str(w_row))
		.range(_rag1).value=v_przcos
		.range(_rag1).numberformat="###,###,##0.00"
		
	    _rag1="G"+alltrim(str(w_row))
		.range(_rag1).value=v_tprzven
		.range(_rag1).numberformat="###,###,##0.00"
		
	    _rag1="H"+alltrim(str(w_row))
		.range(_rag1).value=v_tprzven
		.range(_rag1).numberformat="###,###,##0.00"
		
	    _rag1="I"+alltrim(str(w_row))
		.range(_rag1).value=v_reddi
		.range(_rag1).numberformat="###,###,##0.00"
		
	    _rag1="J"+alltrim(str(w_row))
		.range(_rag1).value=v_media
		.range(_rag1).numberformat="###,###,##0.00"
		
	    _rag1="K"+alltrim(str(w_row))
		.range(_rag1).value=v_qtamed
		.range(_rag1).numberformat="###,###,##0.00"
		
	    _rag1="L"+alltrim(str(w_row))
		.range(_rag1).value=v_mprzven
		.range(_rag1).numberformat="###,###,##0.00"
		
	    _rag1="M"+alltrim(str(w_row))
		.range(_rag1).value=v_mprzcos
		.range(_rag1).numberformat="###,###,##0.00"
		
	    _rag1="N"+alltrim(str(w_row))
		.range(_rag1).value=v_treddi
		.range(_rag1).numberformat="###,###,##0.00"
		
	    _rag1="O"+alltrim(str(w_row))
		.range(_rag1).value=v_mmedia
		.range(_rag1).numberformat="###,###,##0.00"
		
	ENDWITH
	w_row=w_row+1
endscan



with oexcel.activesheet.pagesetup
	.orientation   			= 2						
	.papersize      		= 9
	.fittopagestall 		= 1
	.fittopageswide 		= 1 
*	.topmargin     			= 1.5
*	.bottommargin   		= 3.5
	.leftmargin     		= 1.5
	.rightmargin    		= 1.5
	.centerfooter   		= "Pagina &p di &n"
	.centerhorizontally   	= .t.
*	.centervertically   	= .t.
	.zoom 					= 100
endwith

oexcel.ActiveWorkbook.Save

*if _preview="P"
  oexcel.activesheet.printpreview()
*else
*  oexcel.activesheet.printout()
*endif

oexcel.ActiveWorkbook.Close
oexcel.Quit



