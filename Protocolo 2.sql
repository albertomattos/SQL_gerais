select * from hs_fatura_protocolo

select * from hs_protocolo where usuario_envio = "114"

SELECT cod_setor FROM hs_usuario_setor WHERE usuario="114"

select cod_protocolo, data_envio, usuario_envio from hs_protocolo
where data_recebimento is null and
cod_setor_destino="0091" and cod_setor_origem <> cod_setor_destino
ORDER BY data_envio
