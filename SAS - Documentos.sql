select t.*, t.rowid from dms_documents t where t.code in ('PCL.HSJ.257')

select t.*, t.rowid from dms_events t where t.ref_document in ('2484','2794') order by 2,5

select t.*, t.rowid from dms_documents t where t.ref_owner = '132'
