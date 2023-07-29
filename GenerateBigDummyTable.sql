create table x 
with ( 
    distribution = ROUND_ROBIN, 
    clustered index (id) 
)
as 
select top 8000000 ROW_NUMBER() over (order by a.object_id) as id  
from sys.all_columns a cross join sys.all_columns b 


select min(id), max(id) from x 

