SELECT   A.UNIQUENESS, A.INDEX_NAME , 
 A.TABLESPACE_NAME AS Tablespace,
 A.initial_extent/1024 || 'K' InitialExtentSize,
 A.PCT_INCREASE AS PercentIncrease,
 A.PCT_FREE AS MinimumPercentFree, 
 A.next_extent/1024 || 'K' next_extent,
 A.Min_Extents, A.Max_Extents 
, NULL as partitioned 
 FROM USER_INDEXES A WHERE (A.TABLE_NAME = :TBLNAME)
 AND (A.INDEX_NAME = :IDXNAME)
