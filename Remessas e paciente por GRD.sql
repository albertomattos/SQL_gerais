select faremcad.remessa, faremcad.grd_sulame, fafatcad.cod_pac from faremcad, fafatcad
where fafatcad.remessa = faremcad.remessa
and faremcad.grd_sulame = "0369" and faremcad.cod_con = "018"
order by grd_sulame
