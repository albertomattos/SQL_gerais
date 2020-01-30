select t.data, t.endereco_ip, t.nome_computador, t.sistema, t.modulo, t.funcao, t.complemento
from falogcad t where t.matricula = '208' and t.data between '01/06/2016' and '01/07/2016'
