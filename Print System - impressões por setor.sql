SELECT sum(TotalPages) copias
  FROM [PrinterSQL].[dbo].[Jobs]
  where SubmitTime between '20/06/2016' and '19/07/2016'
  and StatusPrintText = ''
    --and PrinterID in ('140','426')
  --and NotifyName = 'adiele.freitas'
  --group by NotifyName, Document, SubmitTime
  --order by NotifyName

select distinct b.GroupName, sum(a.TotalPages)
from PrinterSQL.dbo.Jobs a, PrinterSQL.dbo.Groups b, PrinterSQL.dbo.SPrinters c
where a.PrinterID = c.PrinterID and b.GroupID = c.GroupID
--and b.GroupID = 9
and a.SubmitTime between '20/06/2016' and '19/07/2016'
and a.StatusPrintText = ''
group by b.GroupName

select distinct b.SubGroupName, sum(a.TotalPages)
from PrinterSQL.dbo.Jobs a, PrinterSQL.dbo.SubGroups b, PrinterSQL.dbo.SPrinters c
where a.PrinterID = c.PrinterID and b.SubGroupId = c.SubGroupId
--and b.SubGroupId = 2
and a.SubmitTime between '20/06/2016' and '19/07/2016'
and a.StatusPrintText = ''
group by b.SubGroupName

select c.PrinterName, c.SerialNumber
from PrinterSQL.dbo.Jobs a, PrinterSQL.dbo.Groups b, PrinterSQL.dbo.SPrinters c
where a.PrinterID = c.PrinterID and b.GroupID = c.GroupID
and a.SubmitTime between '20/06/2016' and '19/07/2016'
and a.StatusPrintText = ''

select * from [PrinterSQL].[dbo].[Printers]