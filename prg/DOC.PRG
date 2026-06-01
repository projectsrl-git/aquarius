yindirizzo			="via le mani dal naso"
yindirizz1			="--------------------"
ycitta              =""
yprovincia          =""
ycap				=""
conti_telefono      =""
conti_fax           =""
conti_partitaiva    =""
conti_codicefisc    =""
conti_descrizion    =""
m.rif               =""
m.numero            =""
m.oggetto           =""
listino_descrizion  =""
listino_note        =""

tmpstp_codice       ="-----"
tmpstp_scontoa      =20
tmpstp_um           ="-----"
tmpstp_quantita     =100
tmpstp_prezzo       =10.222
tmpstp_impo         =15.880
m.totimpo			=100


m.paga				="m.paga	   "
m.consegna          ="m.consegna   "
m.installazi        ="m.installazi "
m.trasporto         ="m.trasporto  "
m.imballo           ="m.imballo    "
m.avviamento        ="m.avviamento "
m.garanzia          ="m.garanzia   "


parametr_ditta		="parametr_ditta	 "
parametr_indirizzo1 ="parametr_indirizzo1"
parametr_citta      ="parametr_citta     "
parametr_telefono   ="parametr_telefono  "
parametr_fax        ="parametr_fax       "
parametr_pi         ="parametr_pi        "
parametr_cciaa      ="parametr_cciaa     "
parametr_citta_trib ="parametr_citta_trib"
parametr_tribunale  ="parametr_tribunale "
parametr_email      ="parametr_email     "
parametr_web        ="parametr_web       "


***************************
oword=createobject("Word.Application")
oDoc = oWord.Documents.Open('C:\AQUASQL\prova.doc')
*odoc  = oword.documents.add()
oword.selection.font.size = 10
oword.selection.font.name= "Arial"
oword.visible = .t.
oword.windowstate = 1


*=seek(m.conto,"conti","CODICE")
with oword.selection
	for i = 1 to 4
		.insertparagraphafter
	endfor
	.insertafter("Spett.le")
	.insertparagraphafter
	.movedown
	.font.bold = .t.
	.insertafter(conti_descrizion)
	.insertparagraphafter
	.movedown
	.font.bold = .f.
	.insertafter(yindirizzo)
	if !empty(yindirizz1)
		.insertparagraphafter
		.insertafter(yindirizz1)
	endif
	.insertparagraphafter
	.insertafter(ycap+" "+alltrim(ycitta)+" ("+yprovincia+")")
	if !empty(conti_telefono)
		.insertparagraphafter
		.insertafter("Tel. "+conti_telefono)
	endif
	if !empty(conti_fax)
		.insertparagraphafter
		.insertafter("Fax. "+conti_fax)
	endif
	if !empty(conti_partitaiva)
		.insertparagraphafter
		.insertafter("P.Iva "+conti_partitaiva)
	endif
	if !empty(conti_codicefisc)
		.insertparagraphafter
		.insertafter("C.F.  "+conti_codicefisc)
	endif
	.insertparagraphafter
	.insertparagraphafter
	.movedown
	.font.italic=.t.
	.font.bold=.t.
	.insertafter("Alla cortese attenzione : "+m.rif)
	.insertparagraphafter
	.insertparagraphafter
	.insertafter("Prot: "+m.numero)
	.font.italic=.f.
	.font.bold=.f.
	.insertparagraphafter
	.insertparagraphafter
	.insertparagraphafter
	.movedown
	.paragraphformat.alignment = 3      && giustificato
	.font.size=12
	.font.bold=.t.
	.font.italic=.f.
	.insertafter("OGGETTO: "+m.oggetto)
	.insertparagraphafter
	.insertparagraphafter
	.insertparagraphafter
	.movedown
	.font.size=10
	.font.bold=.f.
	.insertafter("Come da Vs. gentile richiesta, Vi rimettiamo la ns. migliore offerta per:")
	.insertparagraphafter
	.insertparagraphafter
	.movedown
	*** mettere ciclo per codici articoli
	*select tmpstp
	*go top
	do while !eof()
		*=seek(tmpstp_codice,"listino","codice")
		.insertafter("*"+chr(9))
		.font.size=10
		.font.bold=.f.
		.paragraphformat.alignment = 1      && cent
		.movedown
		.font.size=8
		.font.bold=.f.
		.insertafter("Articolo ")
		.paragraphformat.alignment = 3      && GIUST
		.moveright
		.insertafter(tmpstp_codice+" "+listino_descrizion)
		.font.size=10
		.font.bold=.t.
		.movedown
		if !empty(listino_note)
			.insertparagraphafter
			.insertparagraphafter
			.movedown
			.insertafter("DESCRIZIONE / NOTE TECNICHE")
			.font.bold=.t.
			.font.size=8
			.insertparagraphafter
			.movedown
			.font.bold=.f.
			.insertafter(listino_note)
		else
			.insertparagraphafter
			.movedown
		endif
		.movedown
		.paragraphformat.alignment = 2 &&dx
		.font.bold=.t.
		.font.size=10
		if tmpstp_scontoa=0
		lSconto=.f.
			.tables.add(.range, 3, 3)
			.tables(1).cell(1,1).range.insertafter("Quantita'")
			.tables(1).cell(1,1).width=150
			.tables(1).cell(1,2).range.insertafter(tmpstp_um)
			.tables(1).cell(1,2).width=20
			.tables(1).cell(1,3).range.insertafter(padl(transform(tmpstp_quantita,"999,999,999.99"),20," "))
			.tables(1).cell(1,3).width=100
			.tables(1).cell(2,1).range.insertafter("Prezzo singolo prodotto")
			.tables(1).cell(2,1).width=150
			.tables(1).cell(2,2).range.insertafter("€.")
			.tables(1).cell(2,2).width=20
			.tables(1).cell(2,3).range.insertafter(padl(transform(tmpstp_prezzo,"999,999,999.9999"),20," "))
			.tables(1).cell(2,3).width=100
			.tables(1).cell(3,1).range.insertafter("Prezzo complessivo ")
			.tables(1).cell(3,1).width=150
			.tables(1).cell(3,2).range.insertafter("€.")
			.tables(1).cell(3,2).width=20
			.tables(1).cell(3,3).range.insertafter(padl(transform(tmpstp_impo,"999,999,999.9999"),20," "))
			.tables(1).cell(3,3).width=100
		ELSE
				lSconto=.t.
			.tables.add(.range, 4, 3)
			.tables(1).cell(1,1).range.insertafter("Quantita'")
			.tables(1).cell(1,1).width=150
			.tables(1).cell(1,2).range.insertafter(tmpstp_um)
			.tables(1).cell(1,2).width=20
			.tables(1).cell(1,3).range.insertafter(padl(transform(tmpstp_quantita,"999,999,999.99"),20," "))
			.tables(1).cell(1,3).width=100
			.tables(1).cell(2,1).range.insertafter("Prezzo singolo prodotto")
			.tables(1).cell(2,1).width=150
			.tables(1).cell(2,2).range.insertafter("€.")
			.tables(1).cell(2,2).width=20
			.tables(1).cell(2,3).range.insertafter(padl(transform(tmpstp_prezzo,"999,999,999.9999"),20," "))
			.tables(1).cell(2,3).width=100
			.tables(1).cell(3,1).range.insertafter("Sconto Praticato ")
			.tables(1).cell(3,1).width=150
			.tables(1).cell(3,2).range.insertafter("")
			.tables(1).cell(3,2).width=20
			.tables(1).cell(3,3).range.insertafter(padl(transform(-tmpstp_scontoa,"999,99 %"),20," "))
			.tables(1).cell(3,3).width=100
			.tables(1).cell(4,1).range.insertafter("Prezzo complessivo ")
			.tables(1).cell(4,1).width=150
			.tables(1).cell(4,2).range.insertafter("€.")
			.tables(1).cell(4,2).width=20
			.tables(1).cell(4,3).range.insertafter(padl(transform(tmpstp_impo,"999,999,999.9999"),20," "))
			.tables(1).cell(4,3).width=100
		endif

		.tables(1).rows.alignment=2
		.tables(1).borders(-1).linestyle=0
		.tables(1).borders(-2).linestyle=0
		.tables(1).borders(-3).linestyle=0
		.tables(1).borders(-4).linestyle=0
		.tables(1).borders(-5).linestyle=0
		.tables(1).borders(-6).linestyle=0
		.insertbreak(1)
		.movedown
		.movedown
		.movedown
		.movedown
		if lSconto
			.movedown
		endif	
		.paragraphformat.alignment = 3 &&giu
		.insertparagraphafter
		.movedown
		*select tmpstp
		*skip
		exit
	enddo
	.font.size=10
	.font.bold=.f.
	.insertparagraphafter
	.movedown
	.insertafter("Totale fornitura I.V.A. esclusa €. "+padl(transform(m.totimpo,"999,999,999.99"),20," "))
	.font.bold=.t.
	.paragraphformat.alignment = 2 &&DX
	.insertparagraphafter
	.insertparagraphafter
	.movedown
	.insertafter("CONDIZIONI DI VENDITA")
	.font.bold=.t.
	.font.size=12
	.paragraphformat.alignment = 3 &&giu
	.insertparagraphafter
	.movedown
	.insertafter("Pagamento"+chr(9)+chr(9)+chr(9)+chr(9)+chr(9)+m.paga)
	.insertparagraphafter
	.insertafter("Consegna"+chr(9)+chr(9)+chr(9)+chr(9)+chr(9)+m.consegna)
	.insertparagraphafter
	.insertafter("Installazione"+chr(9)+chr(9)+chr(9)+chr(9)+chr(9)+m.installazi)
	.insertparagraphafter
	.insertafter("Trasporto"+chr(9)+chr(9)+chr(9)+chr(9)+chr(9)+m.trasporto)
	.insertparagraphafter
	.insertafter("Imballo"+chr(9)+chr(9)+chr(9)+chr(9)+chr(9)+chr(9)+m.imballo)
	.insertparagraphafter
	.insertafter("Avviamento"+chr(9)+chr(9)+chr(9)+chr(9)+chr(9)+m.avviamento)
	.insertparagraphafter
	.insertafter("Garanzia"+chr(9)+chr(9)+chr(9)+chr(9)+chr(9)+m.garanzia)
	.font.bold=.f.
	.font.size=10
	.insertparagraphafter
	.insertparagraphafter
	.movedown
	.insertafter("In attesa di un Vs. cenno di riscontro, cogliamo l'occasione per porgere distinti saluti.")
	.insertparagraphafter
	.insertparagraphafter
	.insertafter("Data :"+replicate(chr(9),5)+parametr_ditta)
	.font.bold=.f.
	.font.size=10
	.paragraphformat.alignment = 3 &&gIUST
endwith
oword.activedocument.sections(1).footers(1).range.paragraphformat.alignment =1
oword.activedocument.sections(1).footers(1).range.font.name="Arial"
oword.activedocument.sections(1).footers(1).range.font.size=7
oword.activedocument.sections(1).footers(1).range.insertafter(alltrim(parametr_ditta)+" "+alltrim(parametr_indirizzo1)+" "+alltrim(parametr_citta)+" - Tel. "+alltrim(parametr_telefono)+" - Fax. "+alltrim(parametr_fax))
oword.activedocument.sections(1).footers(1).range.insertparagraphafter
oword.activedocument.sections(1).footers(1).range.insertafter(alltrim("Partitia I.V.A. "+parametr_pi)+" - Iscrizione Imprese N. "+alltrim(parametr_tribunale)+" - C.C.I.A.A. di "+alltrim(parametr_citta_trib)+" N. "+alltrim(parametr_cciaa))
oword.activedocument.sections(1).footers(1).range.insertparagraphafter
oword.activedocument.sections(1).footers(1).range.insertafter(alltrim("WEB "+parametr_web)+" - E-mail  "+alltrim(parametr_email))
oword.activedocument.sections(1).footers(3).pagenumbers.add
oword.activedocument.sections(1).footers(1).range.insertbefore("Pagina : ")





 oword.activedocument.saveas("C:\AQUASQL\pippo.doc")
 oword.application.quit
