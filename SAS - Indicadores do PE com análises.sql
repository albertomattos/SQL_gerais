select * from ac_records t, ac_events u, ac_ocurrencies v, bsc_indicators w
where t.ref_ocurrency = v.id
and u.id = v.ref_acevent
and t.ref_indicator = w.id
and v.dt_period_start >='01/04/2017'
and v.dt_period_start <='30/04/2017'
and u.id in ('6','18','19','20','21')

select * from ac_events
