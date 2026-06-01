oword=createobject("Word.Application")
oDoc = oWord.Documents.Open('L:\TEMP\TESORERIA\prova_sostituzione.doc')
*odoc  = oword.documents.add()
oword.visible = .t.
oword.windowstate = 1

with oword.selection.Find
	    .ClearFormatting
    	.Replacement.ClearFormatting
        .Text = "#TEST#"
        .Replacement.Text = "prova la sostituzione"
        .Forward = .t.
        .Wrap = 1
        .Format = .f.
        .MatchCase = .f.
        .MatchWholeWord = .f.
        .MatchWildcards = .f.
        .MatchSoundsLike = .f.
        .MatchAllWordForms = .f.

endwith
oword.selection.Find.Execute
oword.activedocument.saveas("l:\temp\tesoreria\pippo1.doc")
oword.application.quit
