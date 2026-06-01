
CSQL = "SELECT plan_handle, st.text FROM sys.dm_exec_cached_plans CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st WHERE text LIKE N'SELECT * FROM U_AZI_AN%'"
IF !ExecCommand(cSql,"TMP_PLAN_HANDLE")
  return(.f.)
ENDIF
SELECT TMP_PLAN_HANDLE
GO TOP
BROWSE NORMAL