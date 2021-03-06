
-- list your row counts for dimensional model
-- rick sherman
-- 2020-04-23

use imdb  -- substitute your db name
go

 SELECT 
        db_name() as dbName,
        s.name AS SchemaName,
		t.NAME AS TableName,
	--	p.Rows as TableRows,
         format(p.Rows,'n0') as TableRows,
	     @@SERVERNAME as ServerName,
	     SYSTEM_USER AS 'LoginName',
	--   	@@DBTS as DBtimestamp,
        getdate() QueryTime
    FROM    sys.tables t
    INNER JOIN  sys.indexes i ON t.OBJECT_ID = i.object_id
    INNER JOIN  sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
    INNER JOIN sys.schemas s on s.schema_id = t.schema_id
    WHERE 
	    (t.NAME NOT LIKE 'dim%' or t.NAME NOT LIKE 'fct%') and
        t.NAME NOT LIKE 'dt%' AND
		s.name = 'dbo' and
         i.OBJECT_ID > 255 AND   
          i.index_id <= 1 
    GROUP BY 
        t.NAME, i.object_id
		, i.index_id
		, i.name
		, s.name
		 , p.Rows
     ORDER BY  t.name