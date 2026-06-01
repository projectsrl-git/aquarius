Attribute VB_Name = "declare"
Public Declare Function SendCommand Lib "w32ecash" (ByVal lpBuffer As String) As Long
Public Declare Function SetEcrKeyboard Lib "w32ecash" (ByVal Enable As Boolean) As Long
Public Declare Function OpenConnection Lib "w32ecash" (ByVal hwnd As Long) As Long
Public Declare Function GetEcrData Lib "w32ecash" (ByVal DataType As Byte, ByVal Buffer As String, Size As Long) As Long

