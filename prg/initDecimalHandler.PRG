
********************************
*** Funzione centrale di binding
********************************
PROCEDURE GlobalBindDecimalOverride(oContainer)
    LOCAL loControl

    IF PEMSTATUS(oContainer, "Controls", 5)
        FOR EACH loControl IN oContainer.Controls

            DO CASE
                * TextBox con ControlSource numerico
                CASE UPPER(loControl.BaseClass) == "TEXTBOX" AND ;
                     VARTYPE(loControl.ControlSource) = "C"
                    *LOCAL mValue
                    TRY
                        *mValue = EVAL(loControl.ControlSource)
                        *IF TYPE("mValue") $ "N,F,B"
                        IF TYPE(loControl.ControlSource) $ "N,F,B"
	                    	_c_oDecimalHandler = "oDecimalHandler"+SYS(2015)
							RELEASE &_c_oDecimalHandler
							PUBLIC &_c_oDecimalHandler
							&_c_oDecimalHandler = CREATEOBJECT("DecimalKeyHandler")
							BINDEVENT(loControl, "KeyPress", &_c_oDecimalHandler, "HandleDecimalKey", 1)
                        ENDIF
                    CATCH
                    ENDTRY

                * PageFrame ? entra nelle sue Pagine
                CASE UPPER(loControl.BaseClass) == "PAGEFRAME"
                    FOR i = 1 TO loControl.PageCount
                        GlobalBindDecimalOverride(loControl.Pages(i))
                    ENDFOR
                
                * Grid ? entra nelle sue Columns
				CASE UPPER(loControl.BaseClass) == "GRID"
				    FOR EACH loColumn IN loControl.Columns
				        FOR EACH loMember IN loColumn.Objects
				            IF UPPER(loMember.BaseClass) == "TEXTBOX" AND ;
				               VARTYPE(loMember.ControlSource) = "C"
				                *LOCAL mValue
				                TRY
				                    *mValue = EVAL(loMember.ControlSource)
				                    *IF TYPE("mValue") $ "N,F,B"
				                    IF TYPE(loMember.ControlSource) $ "N,F,B"
				                    	_c_oDecimalHandler = "oDecimalHandler"+SYS(2015)
										RELEASE &_c_oDecimalHandler
										PUBLIC &_c_oDecimalHandler
										&_c_oDecimalHandler = CREATEOBJECT("DecimalKeyHandler")
										BINDEVENT(loMember, "KeyPress", &_c_oDecimalHandler, "HandleDecimalKey", 1)
				                    ENDIF
				                CATCH
				                ENDTRY
				            ENDIF
				        ENDFOR
				    ENDFOR

                * Contenitori standard ? ricorsione
                CASE PEMSTATUS(loControl, "Controls", 5)
                    GlobalBindDecimalOverride(loControl)

            ENDCASE

        ENDFOR
    ENDIF
ENDPROC

********************************************************
*** Definizion classe e Funzione che intercetta il tasto
********************************************************
DEFINE CLASS DecimalKeyHandler AS Custom

    PROCEDURE HandleDecimalKey(nKeyCode, nShiftAltCtrl)
    	*WAIT WINDOWS "HandleDecimalKey" NOWAIT
        IF nKeyCode = 46  && "." tastierino numerico
            KEYBOARD "," PLAIN
            NODEFAULT
        ENDIF
    ENDPROC

ENDDEFINE
