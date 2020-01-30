select t.*, t.rowid from cpmovcad t where t.nota_ori like '%00011920'
select t.*, t.rowid from cpmovite t where t.documento in (select documento from cpmovcad where nota_ori like '%00011920')
