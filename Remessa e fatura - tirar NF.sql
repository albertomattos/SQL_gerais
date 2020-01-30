select remessa, nota_fis from faremcad where remessa = "041837"
update faremcad set nota_fis = "00014858" where remessa = "041615"

select * from fafatcad where remessa = "041615" and fatura = "712911"
update fafatcad set nota_fiscal = "00014858" where fatura = "715344"
