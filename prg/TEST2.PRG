PUBLIC oform1
oform1=NEWOBJECT("form1")
oform1.Show
RETURN
DEFINE CLASS form1 AS form
    DoCreate = .T.
    Caption = "Form1"
    Name = "Form1"
    ADD OBJECT command1 AS commandbutton WITH ;
        DragMode = 1, ;
        Top = 60, ;
        Left = 228, ;
        Height = 27, ;
        Width = 84, ;
        Caption = "Command1", ;
        Name = "Command1"
    ADD OBJECT text1 AS textbox WITH ;
        DragMode = 1, ;
        Height = 23, ;
        Left = 36, ;
        Top = 48, ;
        Width = 100, ;
        Name = "Text1"
    PROCEDURE DragDrop
        LPARAMETERS oSource, nXCoord, nYCoord
        oSource.Left = nXCoord
        oSource.Top = nYCoord
    ENDPROC
    PROCEDURE command1.DragDrop
        LPARAMETERS oSource, nXCoord, nYCoord
        THIS.Parent.DragDrop(oSource, nXCoord, nYCoord)
    ENDPROC
    PROCEDURE text1.DragDrop
        LPARAMETERS oSource, nXCoord, nYCoord
        THIS.Parent.DragDrop(oSource, nXCoord, nYCoord)
    ENDPROC
ENDDEFINE