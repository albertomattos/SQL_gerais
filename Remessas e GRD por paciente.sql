select r.remessa, r.grd_sulame, c.data_entrega from faremcad r, fafatcad f, csremcad c
where f.remessa = r.remessa
and r.grd_sulame = c.cod_rem
and f.cod_pac = "E520457" and c.cod_conv_unif = "90016"
order by grd_sulame
