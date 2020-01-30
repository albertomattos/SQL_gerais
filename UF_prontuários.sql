select est_res, count(est_res) from faprtcad where est_res <> "BA" and est_res <> "SE" and est_res <> ""
group by est_res
order by count(est_res) desc
update faprtcad set est_res = "BA" where est_res = "SA"
