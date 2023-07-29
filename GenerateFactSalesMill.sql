declare @startDate as date;  
declare @endDate as date; 

set @startDate = '2023-01-01';
set @endDate = '2023-01-31'; 

declare @seedNumber as int; 
declare @maxDimOpsiteKey as int; 
declare @maxDimProductKey as int; 
declare @howManyRowsInADay as int; 

declare @currentDate as date; 
set @currentDate = @startDate; 

select @maxDimOpsiteKey = MAX(SITE_KEY) 
from DimBuyerSite; 

select @maxDimProductKey = MAX(PRODUCT_KEY) 
from DimProduct; 

declare @dateAsId as int; 

while @currentDate <= @endDate 
begin 
    set @dateAsId = year(@currentDate) * 10000 + month(@currentDate) * 100 + day(@currentDate); 
    
    set @seedNumber = convert(INT, CONVERT(BIGINT,CONVERT(BINARY(8), NEWID()))/100000000000); 
    set @howManyRowsInADay = RAND(@seedNumber)*(8000001-2999999)+2999999; 

    insert into FactSales 
    select @dateAsId as dateId 
            , rand(@seedNumber)*(@maxDimOpsiteKey-1)+1 as siteId  
            , rand(@seedNumber)*(@maxDimProductKey-1)+1 as productId 
            , rand(@seedNumber)*(100-1)+1 as Qty 
            , rand(@seedNumber)*(25000-500)+1 as Amount 
    from x 
    where id < @howManyRowsInADay; 


    set @currentDate = dateadd(d, 1, @currentDate); 
end