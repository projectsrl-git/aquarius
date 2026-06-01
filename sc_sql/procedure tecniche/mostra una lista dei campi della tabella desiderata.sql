
select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
left outer join sys.all_columns as col on col.object_id = tab.object_id
where tab.type = 'U' AND tab.name = 'STDAnagrafiche'
order by tab.name,col.column_id





select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
left outer join sys.all_columns as col on col.object_id = tab.object_id
where tab.type = 'U' AND tab.name = 'STDAnagraficaFornitori'
order by tab.name,col.column_id



select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
left outer join sys.all_columns as col on col.object_id = tab.object_id
where tab.type = 'U' AND tab.name = 'STDAnagraficaClienti'
order by tab.name,col.column_id


select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
left outer join sys.all_columns as col on col.object_id = tab.object_id
where tab.type = 'U' AND tab.name = 'STDABICAB'
order by tab.name,col.column_id

select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
left outer join sys.all_columns as col on col.object_id = tab.object_id
where tab.type = 'U' AND tab.name = 'MAGAnagraficaArticoli'
order by tab.name,col.column_id

select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
left outer join sys.all_columns as col on col.object_id = tab.object_id
where tab.type = 'U' AND tab.name = 'COGPrimeNoteRCont'
order by tab.name,col.column_id



select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
left outer join sys.all_columns as col on col.object_id = tab.object_id
where tab.type = 'U' AND tab.name = 'COGPrimeNoteTeste'
order by tab.name,col.column_id



select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
left outer join sys.all_columns as col on col.object_id = tab.object_id
where tab.type = 'U' AND tab.name = 'COGScadenze'
order by tab.name,col.column_id





select tab.name as tab_name,tab.object_id,col.* from sys.all_objects as tab
left outer join sys.all_columns as col on col.object_id = tab.object_id
where tab.type = 'U' AND tab.name = 'STDScalaSconti'
order by tab.name,col.column_id


