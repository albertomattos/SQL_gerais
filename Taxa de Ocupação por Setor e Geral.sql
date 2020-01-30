

select case when num_pac is not null then
sum(num_pac)/sum(num_leitos)*100
end
from taxa_ocupacao where data between '25/02/2018' and '25/02/2018'
and cod_set in ('0130','0133','0453','0006','0191','0134','0132')
group by num_pac
