select t.*, t.rowid from crt_feedback t where t.REF_ANSWER in (select t.id from crt_answers t where t.ref_topic = '83')
