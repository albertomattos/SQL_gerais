/*select t.*, t.rowid from bsc_items t where t.ref_indicator = '14894'
and t.competence >= '201600'
order by t.competence
*/
select t.*, t.rowid from bsc_items t where t.ref_indicator in (select t.id from bsc_indicators t
where upper(t.name) like 'CONSUMO%NEOPED%'  and t.family = '0')
and t.competence >= '201600' AND t.ref_indicator not in ('8821','8823')
order by t.competence
