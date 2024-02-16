-- TỔNG HỢP THỰC HÀNH SQL
Use AdventureWorksDW2019

EX1: Từ bộ AdventureWorksDW2019, bảng FactInternetSales,  
lấy tất cả các bản ghi có OrderDate từ ngày '2011-01-01' về sau và ShipDate trong năm 2011  
CÁCH 1:
SELECT
    *
FROM dbo.FactInternetSales
WHERE OrderDate >= '2011-01-01'
AND YEAR(ShipDate) = '2011'
CÁCH 2: DÙNG DATEPART
SELECT
    *
FROM dbo.FactInternetSales
WHERE OrderDate >= '2011-01-01'
AND DATEPART(YEAR,ShipDate) = 2011

EX2:
*/ Từ bộ AdventureWorksDW2019, bảng DimProduct, 
Lấy ra thông tin ProductKey, ProductAlternateKey và EnglishProductName của các sản phẩm.  
Lọc các sản phẩn có ProductAlternasteKey bắt đầu bằng chữ 'BK-' theo sau đó là 1 ký tự bất kỳ khác chữ T và kết thúc bằng 2 con số bất kỳ 
Đồng thời, thoả mãn điều kiện Color là Black hoặc Red hoặc White  
*/ 
SELECT
    ProductKey,
    ProductAlternateKey,
    EnglishProductName
FROM dbo.DimProduct
WHERE ProductAlternateKey LIKE 'BK-[^T]%[0-9][0-9]'
AND Color IN ('Black','Red','White')


EX3:Từ bộ AdventureWorksDW2019, bảng DimProduct, lấy ra tất cả các sản phẩm có cột Color là Red  
SELECT
    *
FROM dbo.DimProduct
WHERE Color IN ('Red')

EX4: Từ bộ AdventureWorksDW2019, bảng DimEmployee, lấy ra EmployeeKey, FirstName, LastName, MiddleName của những nhân viên có MiddleName không bị Null và cột Phone có độ dài 12 ký tự  

SELECT
    EmployeeKey,
    FirstName,
    LastName,
    MiddleName, Phone
FROM dbo.DimEmployee
WHERE MiddleName IS NOT NULL
AND LEN(PHONE)=12

EX5: 
Từ bộ AdventureWorksDW2019, bảng DimEmployee, lấy ra danh sách các EmployeeKey 

Sau đó lấy ra thêm các cột sau:  

a. Cột FullName được lấy ra từ kết hợp 3 trường FirstName, MiddleName và LastName, với dấu cách ngăn cách giữa các trường (sử dụng 2 cách: toán tử '+' và hàm, sau đó so sánh sự khác biệt)  

b. Cột AgeHired tính tuổi nhân viên tại thời điểm được tuyển, sử dụng cột HireDate và BirthDate 

c. Cột AgeNow tính tuổi nhân viên đến thời điểm hiện tại, sử dụng cột BirthDate 

d. Cột UserName được lấy ra từ phần đằng sau dấu "\" của cột LoginID  

(Cách 1)
SELECT
    EmployeeKey,
    FirstName + isnull(' ' + middlename,'') + ' ' + lastname as 'FullName',
    year(hiredate) - year(birthdate) as 'AgeHired',
    year(GETDATE()) - year(birthdate) as 'AgeNow',
    SUBSTRING(LoginID,17,1000) as 'UserName'
FROM dbo.DimEmployee

(Cách 2)
SELECT
    EmployeeKey,
    CONCAT(FirstName,' ', middlename,' ',lastname) as 'FullName',
    DATEDIFF(year,BirthDate,HireDate) as 'AgeHired',
    DATEDIFF(year,BirthDate,GETDATE()) as 'AgeNow',
    SUBSTRING(LoginID,17,1000) as 'UserName'
FROM dbo.DimEmployee

(Cách 3: dùng hàm concat ws)
SELECT
    EmployeeKey,
    CONCAT(FirstName,' ', middlename,' ',lastname) as 'FullName',
    CONCAT_WS(' ',firstname,middlename,lastname) as fullnameconcatws, có thể xử lý với nhiều cột ghép vào bị null
    DATEDIFF(year,BirthDate,HireDate) as 'AgeHired',
    DATEDIFF(year,BirthDate,GETDATE()) as 'AgeNow',
    SUBSTRING(LoginID,17,1000) as 'UserName'
FROM dbo.DimEmployee

EX6: Từ bộ AdventureWorksDW2019, bảng FactInternetSales chứa thông tin bán hàng,  
lấy ra tất cả các bản ghi bán các sản phẩm có màu là Red */ 
SELECT *
FROM dbo.FactInternetSales
Where ProductKey in (
    select ProductKey
    from dbo.DimProduct
    where Color in ('Red'))

/*Ex7: Từ bảng dbo.FactInternetSales và dbo.DimSalesTerritory, lấy ra thông tin SalesOrderNumber, SalesOrderLineNumber, ProductKey, SalesTerritoryCountry của các bản ghi có SalesAmount trên 1000
*/ 
SELECT
    FIS.SalesOrderNumber,
    FIS.SalesOrderLineNumber,
    FIS.ProductKey,
    DIS.SalesTerritoryCountry
FROM DBO.FactInternetSales AS FIS
INNER JOIN DBO.DimSalesTerritory AS DIS
ON DIS.SalesTerritoryKey = FIS.SalesTerritoryKey
WHERE FIS.SalesAmount > 1000

/*Ex8: Từ bảng dbo.DimProduct và dbo.DimProductSubcategory. Lấy ra ProductKey, EnglishProductName và Color của các sản phẩm thoả mãn EnglishProductSubCategoryName chứa chữ 'Bikes' và ListPrice có phần nguyên là 3399 
*/ 
CÁCH 1: DÙNG LIKE
SELECT
    DP.ProductKey,
    DP.EnglishProductName,
    DP.Color,
    DP.ListPrice
FROM DBO.DimProduct AS DP 
INNER JOIN DBO.DimProductSubcategory AS DPS 
ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
WHERE DPS.EnglishProductSubcategoryName LIKE '%Bikes%'
AND DP.ListPrice LIKE '3399.%'

CÁCH 2: DÙNG TOÁN TỬ >= và <
SELECT
    DP.ProductKey,
    DP.EnglishProductName,
    DP.Color,
    DP.ListPrice
FROM DBO.DimProduct AS DP 
INNER JOIN DBO.DimProductSubcategory AS DPS 
ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
WHERE DPS.EnglishProductSubcategoryName LIKE '%Bikes%'
AND DP.ListPrice >=3399 AND DP.ListPrice<3400

CÁCH 3: DÙNG HÀM FLOOR
SELECT
    DP.ProductKey,
    DP.EnglishProductName,
    DP.Color,
    DP.ListPrice
FROM DBO.DimProduct AS DP 
INNER JOIN DBO.DimProductSubcategory AS DPS 
ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
WHERE DPS.EnglishProductSubcategoryName LIKE '%Bikes%'
AND FLOOR(DP.ListPrice)=3399


/* Ex9: Từ bảng dbo.DimPromotion, dbo.FactInternetSales, lấy ra ProductKey, SalesOrderNumber, SalesAmount từ các bản ghi thoả mãn DiscountPct >= 20% */ 

SELECT
    FIS.ProductKey,
    FIS.SalesOrderNumber,
    FIS.SalesAmount,
    DPR.DiscountPct
FROM dbo.DimPromotion AS DPR 
INNER JOIN dbo.FactInternetSales AS FIS
ON DPR.PromotionKey = FIS.PromotionKey
WHERE DPR.DiscountPct >= 0.2

/* Ex10: Từ bảng dbo.DimCustomer, dbo.DimGeography, lấy ra cột Phone, FullName (kết hợp FirstName, MiddleName, LastName kèm khoảng cách ở giữa) của các khách hàng có YearlyInCome > 150000 và CommuteDistance nhỏ hơn 5 Miles*/ 

CÁCH 1: DÙNG IN (TRƯỚC ĐÓ PHẢI DÙNG DISTINCT ĐỂ KHẢO SÁT CỘT DỮ LIỆU CỦA CommuteDistance)

SELECT
    DC.Phone,
    CONCAT_WS(DC.FirstName, DC.MiddleName,DC.LastName) AS 'Fullname',
    DC.CommuteDistance,
    DC.YearlyIncome
FROM dbo.DimCustomer AS DC 
INNER JOIN dbo.DimGeography AS DG 
ON DC.GeographyKey = DG.GeographyKey
WHERE DC.YearlyIncome > 150000
AND DC.CommuteDistance in ('0-1 Miles','1-2 Miles','2-5 Miles')

CÁCH 2: DÙNG HÀM LIKE
SELECT
    DC.Phone,
    CONCAT_WS(DC.FirstName, DC.MiddleName,DC.LastName) AS 'Fullname',
    DC.CommuteDistance,
    DC.YearlyIncome
FROM dbo.DimCustomer AS DC 
INNER JOIN dbo.DimGeography AS DG 
ON DC.GeographyKey = DG.GeographyKey
WHERE DC.YearlyIncome > 150000
AND DC.CommuteDistance LIKE '[0-5]-[0-5] Miles'

/* Ex11: Từ bảng dbo.DimCustomer, lấy ra CustomerKey và thực hiện các yêu cầu sau:  
a. Tạo cột mới đặt tên là YearlyInComeRange từ các điều kiện sau:  
- Nếu YearlyIncome từ 10000 đến 50000 thì gán giá trị "Low Income"  
- Nếu YearlyIncome từ 50001 đến 90000 thì gán giá trị "Middle Income"  
- Nếu YearlyIncome từ  90001 trở lên thì gán giá trị "High Income"  
b. Tạo cột mới đặt tên là AgeRange từ các điều kiện sau:  
- Nếu tuổi của Khách hàng tính đến 31/12/2019 đến 39 tuổi thì gán giá trị "Young Adults"  
- Nếu tuổi của Khách hàng tính đến 31/12/2019 từ 40 đến 59 tuổi thì gán giá trị "Middle-Aged Adults"  
- Nếu tuổi của Khách hàng tính đến 31/12/2019 lớn hơn 60 tuổi thì gán giá trị "Old Adults"  
 */

SELECT
    CUSTOMERKEY,
    CASE
        WHEN YearlyIncome BETWEEN 10000 AND 50000 THEN 'Low Income'
        WHEN YearlyIncome BETWEEN 50001 AND 90000 THEN 'Middle Income'
        When YearlyIncome >=90001 THEN 'High Income'
        ELSE 'Undefined'
    END AS 'YearlyInComeRange',
    CASE
        WHEN DATEDIFF(YEAR,BirthDate,'2019-12-31') <= 39 THEN 'Young Adults'
        WHEN DATEDIFF(YEAR,BirthDate,'2019-12-31') BETWEEN 40 AND 59 THEN 'Young Adults'
        WHEN DATEDIFF(YEAR,BirthDate,'2019-12-31') >= 60 THEN 'Old Adults'
    END AS 'AgeRange'
FROM dbo.DimCustomer

/* Ex12: Từ bảng FactInternetSales, FactResellerSale và DimProduct. Tìm tất cả SalesOrderNumber có EnglishProductName chứa từ 'Road' và có màu vàng (Yellow) */ 

CÁCH 1: JOIN TRƯỚC UNION SAU
SELECT
    FIS.SalesOrderNumber
FROM dbo.FactInternetSales AS FIS 
INNER JOIN dbo.DimProduct AS DP 
ON DP.ProductKey = FIS.ProductKey
WHERE DP.EnglishProductName LIKE '%Road%' 
AND COLOR IN ('YELLOW')
UNION 
SELECT
    FRS.SalesOrderNumber
FROM dbo.FactResellerSales AS FRS 
INNER JOIN dbo.DimProduct AS DP 
ON DP.ProductKey = FRS.ProductKey
WHERE DP.EnglishProductName LIKE '%Road%' 
AND COLOR IN ('YELLOW')

CÁCH 2: DÙNG SUBQUERY

WITH SALES as (
    SELECT
    SalesOrderNumber,
    ProductKey
FROM dbo.FactInternetSales
UNION 
SELECT
    SalesOrderNumber,
    ProductKey
FROM dbo.FactResellerSales
)
SELECT
    DISTINCT
    SALES.SalesOrderNumber
FROM SALES
LEFT JOIN dbo.DimProduct AS DP 
ON SALES.ProductKey = DP.ProductKey
WHERE DP.EnglishProductName LIKE '%Road%' 
AND DP.Color IN ('YELLOW')

/*Ex 13: Từ các bảng dbo.DimProduct, dbo.DimPromotion, dbo.FactInternetSales, lấy ra ProductKey, EnglishProductName của các dòng thoả mãn Discount Pct >= 20% */ 
-- Bảng nào là chính nếu dùng left join? Database chuẩn thì bảng nào làm chuẩn cũng như nhau
-- Thường trong thực tế sẽ dùng bảng fact làm chuẩn thay vì dùng dim vì bảng fact thường liên quan đến tiền

SELECT
    DP.ProductKey,
    DP.EnglishProductName,
    DPM.DiscountPct
FROM dbo.DimProduct AS DP 
LEFT JOIN dbo.FactInternetSales AS FIS ON DP.ProductKey = FIS.ProductKey
LEFT JOIN dbo.DimPromotion AS DPM ON FIS.PromotionKey = DPM.PromotionKey
WHERE DPM.DiscountPct >= 0.2

/*Ex14: Từ các bảng DimProduct, DimProductSubcategory, DimProductCategory, lấy ra các cột Product key, EnglishProductName, EnglishProductSubCategoryName, EnglishProductCategoryName của sản phẩm thoả mãn điều kiện EnglishProductCategoryName là 'Clothing' */ 

Select 
    DP.ProductKey,
    DP.EnglishProductName,
    PC.EnglishProductCategoryName,
    PS.EnglishProductSubcategoryName,
    DP.Color
 from dbo.DimProduct as DP
 left join dbo.DimProductSubcategory as PS on DP.ProductSubcategoryKey = PS.ProductSubcategoryKey
 left join dbo.DimProductCategory as PC on PS.ProductCategoryKey = PC.ProductCategoryKey
 WHERE PC.EnglishProductCategoryName IN ('Clothing')

/*Ex15: Từ bảng FactInternetSales và DimProduct, lấy ra ProductKey, EnglishProductName, ListPrice của những sản phẩm chưa từng được bán. Sử dụng 2 cách: toán tử IN và phép JOIN */

WITH TEMP AS
(SELECT
DISTINCT
FIS.ProductKey as 'Thống kê mã bán',
DP.ProductKey as 'Thống kê mã hàng',
DP.EnglishProductName,
DP.ListPrice
FROM dbo.FactInternetSales AS FIS
FULL JOIN dbo.DimProduct AS DP ON FIS.ProductKey = DP.ProductKey)
SELECT
    Temp.[Thống kê mã hàng] as 'Productkey',
    Temp.EnglishProductName,
    Temp.ListPrice
FROM TEMP
WHERE Temp.[Thống kê mã bán] IS NULL

SELECT
    ProductKey,
    EnglishProductName,
    ListPrice
FROM dbo.DimProduct 
WHERE ProductKey NOT IN (
Select ProductKey FROM dbo.FactInternetSales)

SELECT
    DP.ProductKey,
    DP.EnglishProductName,
    DP.ListPrice
FROM dbo.DimProduct AS DP
LEFT JOIN dbo.FactInternetSales AS FIS
ON DP.Productkey = FIS.ProductKey
WHERE FIS.ProductKey IS NULL

/*Ex16: Từ bảng DimDepartmentGroup, lấy ra thông tin DepartmentGroupKey, DepartmentGroupName, ParentDepartmentGroupKey và thực hiện self-join lấy ra ParentDepartmentGroupName */ 

SELECT *
FROM dbo.DimDepartmentGroup

SELECT
    Child.DepartmentGroupKey,
    Child.DepartmentGroupName,
    Child.ParentDepartmentGroupKey,
    Parent.DepartmentGroupName as 'ParentDepartmentGroupName'
FROM dbo.DimDepartmentGroup as Child
LEFT JOIN dbo.DimDepartmentGroup as Parent
ON Parent.DepartmentGroupKey = Child.ParentDepartmentGroupKey

/*Ex17: Từ bảng FactFinance, DimOrganization, DimScenario, lấy ra OrganizationKey, OrganizationName, Parent OrganizationKey, và thực hiện self-join lấy ra Parent OrganizationName, Amount thoả mãn điều kiện ScenarioName là 'Actual'. */ 

SELECT * FROM DBO.DimOrganization

WITH TEMP AS 
(SELECT
    Child.OrganizationKey,
    Child.OrganizationName,
    Child.ParentOrganizationKey,
    Parent.OrganizationName AS 'ParentOrganizationName'
FROM dbo.DimOrganization AS Child
LEFT JOIN dbo.DimOrganization AS Parent
ON Child.ParentOrganizationKey = Parent.OrganizationKey
)
SELECT
    Temp.OrganizationKey,
    Temp.OrganizationName,
    Temp.ParentOrganizationKey,
    Temp.ParentOrganizationName,
    FF.Amount,
    DS.ScenarioName
FROM dbo.FactFinance AS FF
LEFT JOIN dbo.DimScenario AS DS ON DS.ScenarioKey = FF.ScenarioKey
LEFT JOIN TEMP ON TEMP.OrganizationKey = FF.OrganizationKey
WHERE DS.ScenarioName IN ('Actual')

/* Ex18: Từ bảng DimEmployee, tính BaseRate trung bình của từng Title có trong công ty */  

SELECT
    Title,
    AVG(BaseRate) AS Average_Baserate
FROM DBO.DimEmployee
GROUP BY Title

/* Ex19: Từ bảng FactInternetSales, lấy ra cột TotalOrderQuantity, sử dụng cột OrderQuantity tính tổng số lượng bán ra với từng ProductKey và từng ngày OrderDate*/ 

SELECT
    OrderDate,
    ProductKey,
    SUM(OrderQuantity) AS TotalOrderQuantity
FROM dbo.FactInternetSales
GROUP BY OrderDate, ProductKey

/* Ex20: Từ bảng DimProduct, FactInternetSales, DimProductCategory và các bảng liên quan nếu cần thiết 
Lấy ra thông tin ngành hàng gồm: CategoryKey, EnglishCategoryName của các dòng thoả mãn điều kiện OrderDate trong năm 2012 và tính toán các cột sau đối với từng ngành hàng:  
- TotalRevenue sử dụng cột SalesAmount 
- TotalCost sử dụng côt TotalProductCost 
- TotalProfit được tính từ (TotalRevenue - TotalCost)/TotalRevenue  
Chỉ hiển thị ra những bản ghi có TotalRevenue > 5000 */  

SELECT
    DPC.ProductCategoryKey,
    DPC.EnglishProductCategoryName,
    FIS.OrderDate,
    SUM(FIS.SalesAmount) AS TotalRevenue,
    SUM(FIS.TotalProductCost) AS TotalCost,
    (SUM(FIS.SalesAmount)-SUM(FIS.TotalProductCost))/SUM(FIS.SalesAmount) AS TotalProfit
FROM dbo.FactInternetSales AS FIS
INNER JOIN dbo.DimProduct AS DP ON DP.ProductKey = FIS.ProductKey
INNER JOIN dbo.DimProductSubcategory AS DPS ON DPS.ProductSubcategoryKey = DP.ProductSubcategoryKey
INNER JOIN dbo.DimProductCategory AS DPC ON DPC.ProductCategoryKey = DPS.ProductCategoryKey
GROUP BY DPC.ProductCategoryKey, DPC.EnglishProductCategoryName, FIS.OrderDate
HAVING YEAR(FIS.OrderDate) = 2012 
AND SUM(FIS.SalesAmount) > 5000
ORDER BY FIS.OrderDate

/* Ex21: Từ bảng FactInternetSale, DimProduct, 

- Tạo ra cột Color_group từ cột Color, nếu Color là 'Black' hoặc 'Silver' gán giá trị 'Basic' cho cột Color_group, nếu không lấy nguyên giá trị cột Color sang 
- Sau đó tính toán cột TotalRevenue từ cột SalesAmount đối với từng Color_group mới này */  

WITH TEMP AS
(SELECT
    DP.Color,
    FIS.ProductKey,
    FIS.SalesAmount,
    CASE 
        WHEN DP.Color IN ('Black','Silver','Silver/Black') THEN 'Basic'
    ELSE DP.Color
    END AS Color_group 
FROM dbo.FactInternetSales AS FIS
LEFT JOIN dbo.DimProduct AS DP
ON FIS.ProductKey = DP.ProductKey)
SELECT
    TEMP.Color_group,
    SUM(TEMP.SalesAmount) AS TotalRevenue
FROM TEMP
GROUP BY TEMP.Color_group

/* Ex22: Từ bảng FactInternetSales, FactResellerSales và các bảng liên quan nếu cần, sử dụng cột SalesAmount tính toán doanh thu ứng với từng tháng của 2 kênh bán Internet và Reseller 
Kết quả trả ra sẽ gồm các cột sau: Year, Month, InternSales, Reseller_Sales */

SELECT *
FROM dbo.FactInternetSales

SELECT *
FROM dbo.FactResellerSales

WITH INTERNET AS 
(SELECT 
    YEAR(OrderDate) AS ONLYEAR,
    MONTH(OrderDate) AS ONLMONTH,
    SUM(SalesAmount) AS ONLTOTALVALUE
FROM dbo.FactInternetSales
GROUP BY YEAR(OrderDate),MONTH(OrderDate))
,RESELLER AS 
(SELECT
    YEAR(OrderDate) AS RS_YEAR,
    MONTH(OrderDate) AS RS_MONTH,
    SUM(SalesAmount) AS RS_TOTALVALUE
FROM dbo.FactResellerSales
GROUP BY YEAR(OrderDate),MONTH(OrderDate))
SELECT
    ISNULL(I.ONLYEAR,R.RS_YEAR) AS YEAR,
    ISNULL(I.ONLMONTH,R.RS_MONTH) AS MONTH,
    I.ONLTOTALVALUE AS INETRNETSALES,
    R.RS_TOTALVALUE AS RESELLERSALES
FROM INTERNET AS I
FULL OUTER JOIN RESELLER AS R
ON I.ONLYEAR = R.RS_YEAR AND I.ONLMONTH = R.RS_MONTH
ORDER BY  ISNULL(I.ONLYEAR,R.RS_YEAR), ISNULL(I.ONLMONTH,R.RS_MONTH)
