-- ORDER BY
Lấy ra kết quả thông tin LastName và năm sinh của khách hang ở bảng DimCustomer và sắp xếp năm sinh theo thứ tự tăng dần/ giảm dần
SELECT
    LastName,
    YEAR(BirthDate) AS Birthyear
FROM DBO.DimCustomer
ORDER BY YEAR(BirthDate) ASC

SELECT
    LastName,
    YEAR(BirthDate) AS Birthyear
FROM DBO.DimCustomer
ORDER BY YEAR(BirthDate) DESC

Liệt kê thông tin khách hàng sinh năm 1970, 1971 và 1972

SELECT
*
FROM DBO.DimCustomer
WHERE YEAR(BirthDate) IN ('1970','1971','1972')
ORDER BY YEAR(BirthDate)

Liệt kê danh sách khách hàng có YearlyIncome > 30000 và sắp xếp YearlyIncome theo thứ tự tăng dần

SELECT 
*
FROM DBO.DimCustomer
WHERE YearlyIncome > 30000
ORDER BY YearlyIncome ASC

Lấy ra kết quả thông tin FirstName và năm sinh của khách hàng ở bảng DimCustomer và sắp xếp tên FirstName theo thứ tự tăng dần/giảm dần

-- BETWEEN/IN/NOT IN 
-- Question 1: Liệt kê các nhân viên có số giờ nghỉ phép lớn hơn 30 và nhỏ hơn 70
SELECT
*
FROM DimEmployee
WHERE SickLeaveHours BETWEEN 30 AND 70
-- Question 2: Liệt kê thông tin Reseller với mức doanh thu 150000, 300000, 800000
SELECT
*
FROM DBO.DimReseller
WHERE AnnualRevenue IN (150000, 300000, 800000)
-- Question 3: Liệt kê các cột FirstName, LastName, MiddleName, Title, BaseRate, VacationHours, SickLeaveHours and DepartmentName các nhân viên sinh năm 1950 đến 1990 ở bảng DimEmployee đổi tên và sắp xếp thứ tự tang/giảm dần theo VacationHours 
SELECT
    FirstName,
    LastName,
    MiddleName,
    Title,
    BaseRate,
    VacationHours,
    SickLeaveHours,DepartmentName
FROM DBO.DimEmployee
WHERE YEAR(BirthDate) BETWEEN 1950 AND 1990
ORDER BY VacationHours DESC
-- Question 4: Liệt kê các nhân viên bắt đầu làm việc tại phòng Production từ năm 2008 đến 2012 ở bảng DimEmployee và đếm tổng số nhân viên thỏa điều kiện trên. (HomeWork)
WITH temp as 
(SELECT
*
FROM DBO.DimEmployee
WHERE YEAR(StartDate) BETWEEN 2008 AND 2012)
SELECT COUNT(TEMP.EmployeeKey)
FROM TEMP
-- Question 5: Liệt kê các nhân viên nữ bảng DimEmployee có số giờ nghỉ lễ lớn hơn 20 và nhỏ hơn 40.
SELECT
*
FROM DBO.DimEmployee
WHERE Gender IN ('F')
AND VacationHours > 20 AND VacationHours < 40
-- CASE WHEN
-- Question 1: Kiểm tra lại kí tự gán cho giới tính của nhân viên trong bảng DimEmployee;
SELECT
    employeekey,
    gender,
    case 
        when gender in ('M') then 'Male'
        when gender in ('F') then 'Female'
    else 'Unidentified'
    end as full_gender
FROM DBO.DimEmployee
-- Question 2: Chọn cột Firstname, LastName, MiddleName, Title và tạo một cột mới Marital_Status với S = Single và M = Married những giá trị còn lại thì Unknown
SELECT
    FirstName,
    LastName,
    MiddleName,
    Title,
    CASE
        WHEN MaritalStatus IN ('S') THEN 'Single'
        WHEN MaritalStatus IN ('M') THEN 'Married'
    ELSE 'Unknow'
    END AS Marital_Status
FROM dbo.DimEmployee
-- Question 3: Chọn cột FirstName, LastName, MiddleName, Gender, MaritalStatus, TotalChilden với cột mới Current_Status thỏa 3 điều kiện sau:
             -- Điều kiện 1: Đã kết hôn và có con => Married
             -- Điều kiện 2: Đàn ông độc thân và có con => Single_Dad,
             -- Điểu kiền 3: Phụ nữ độc thân và có con => Single_Mom
             -- Còn lại là SINGLE

Select * from DimCustomer

SELECT
    FirstName,
    LastName,
    MiddleName,
    Gender,
    MaritalStatus,
    TotalChildren,
    CASE
        WHEN MaritalStatus = 'M' AND TotalChildren > 0 THEN 'Married'
        WHEN MaritalStatus = 'S' AND GENDER = 'M' AND TotalChildren > 0 THEN 'Single_Dad'
        WHEN MaritalStatus = 'S' AND GENDER = 'F' AND TotalChildren > 0 THEN 'Single_Mom'
    ELSE 'Single'
    END AS 'Current_Status'
FROM DimCustomer
-- Question 4: Viết câu truy vấn lấy ra giá trị FirstName, LastName, VacationHours đánh giá thời gian nghỉ lễ của nhân viên bằng cột VacationHours bảng DimEmployee. (Homework)
            -- Điều kiện 1: Nếu nhân viên nghỉ từ 0 – 33 giờ là thuộc Level 1
            -- Điều kiện 2: Từ 34 – 66 giờ là Level 2
            -- Điều kiện 3: Còn lại thuộc Level 3 và lưu cột mới tên là VacationHours_Level 

SELECT
    FirstName,
    LastName,
    VacationHours,
    CASE 
    WHEN VacationHours BETWEEN 0 AND 33 THEN 'LEVEL 1'
    WHEN VacationHours BETWEEN 34 AND 66 THEN 'LEVEL 2'
    ELSE 'LEVEL 3'
    END AS 'VacationHours_Level'
FROM DimEmployee
-- Question 5: Gán lại các phòng ban của công ty:  Production = Sản xuất, Human Resources = Nhân sự

SELECT
EmployeeKey,
DepartmentName,
CASE 
    WHEN DepartmentName = 'production' then 'Sản xuất'
    WHEN DepartmentName = 'Human Resources' then 'Nhân sự'
    ELSE DepartmentName
END AS Department_Name
FROM DimEmployee 

-- STRING PATTERN
-- Question 1: Liệt kê thông tin khách hàng FirstName bắt đầu bằng chữ M và có giới tính Nữ
SELECT
    *
FROM DimCustomer
WHERE FirstName LIKE 'M%'
AND Gender = 'F'
-- Question 2: Liệt kê tên của các thành phố có cụm chữ 'VAN' trong tên
SELECT
* 
FROM dbo.DimGeography
WHERE CITY LIKE '%VAN%'
-- Question 3: Liệt kê tất cả thông tin trong bảng Currency trong đó CurrencyALternateKey kết thúc có chữ K
SELECT
*
FROM dbo.DimCurrency 
WHERE CurrencyAlternateKey LIKE '%K'
-- SECTION 2: AGGREGATION FUNCTION 
-- Part I: Hàm SUM
-- Question 1: Tính tổng chi phí, tổng doanh thu, sau đó tính tổng lợi nhuận. Làm tròn đến số thập phân thứ 2
SELECT
    ROUND(SUM(TotalProductCost),2) AS 'Tổng_Chi_Phí',
    ROUND(SUM(SalesAmount),2) AS 'Tổng_Doanh_Thu',
    ROUND(SUM(SalesAmount-TotalProductCost),2) AS 'Tổng_Lợi_Nhuận'
FROM dbo.FactInternetSales

SELECT
    ROUND(SUM(TotalProductCost),-2) AS 'Tổng_Chi_Phí',
    ROUND(SUM(SalesAmount),-2) AS 'Tổng_Doanh_Thu',
    ROUND(SUM(SalesAmount-TotalProductCost),-2) AS 'Tổng_Lợi_Nhuận'
FROM dbo.FactInternetSales
-- Question 2: Tương tự như trên nhưng tính từ ngày 29-12-2010 đến ngày 01-01-2011 (Theo OrderDate)
SELECT
    ROUND(SUM(TotalProductCost),2) AS 'Tổng_Chi_Phí',
    ROUND(SUM(SalesAmount),2) AS 'Tổng_Doanh_Thu',
    ROUND(SUM(SalesAmount-TotalProductCost),2) AS 'Tổng_Lợi_Nhuận'
FROM dbo.FactInternetSales
WHERE OrderDate BETWEEN '2010-12-29' AND '2011-01-01'
-- Part II: Hàm Min MAX 
-- Question 1: Xác định mức giá cao nhất và thấp nhất của cột UnitPrice
SELECT 
    MIN(UnitPrice) AS 'Mức giá thấp nhất',
    MAX(UnitPrice) AS 'Mức giá cao nhất'
FROM dbo.FactInternetSales
-- Question 2: Xác định ngày gần/ xa nhất trong cột OrderDate và DueDate 
SELECT
    MAX(OrderDate) AS Latest_Order_Date,
    MIN(OrderDate) AS Oldest_Order_Date,
    MAX(DueDate) AS Latest_Due_Date,
    MIN(DueDate) AS Oldest_Due_Date
FROM FactInternetSales;
-- Part III: Hàm AVG (AVERAGE)
-- Question 1: Tính giá trị trung bình của UnitPrice trong bảng FactInternetSales
SELECT 
    AVG(UnitPrice) AS 'Mức giá trung bình'
FROM dbo.FactInternetSales
-- Question 2: Tính giá trị trung bình của ProductStandardCost trong bảng FactInternetSales
SELECT 
    AVG(ProductStandardCost) AS 'Mức chi phí trung bình'
FROM dbo.FactInternetSales
-- Part IV: Hàm Group By
-- Question 1: Tính tổng chi phí, doanh thu, lợi nhuận và giá trị trung bình (UnitPrice) của từng loại theo ProductKey. Làm tròn đến số thập phân thứ 2. Sắp xếp theo thứ tự từ lớn/nhỏ. 
SELECT
    ProductKey,
    ROUND(SUM(ProductStandardCost),2) AS Total_Cost,
    ROUND(SUM(SalesAmount),2) AS Total_Revenue,
    ROUND(SUM(SalesAmount)-SUM(ProductStandardCost),2) AS Profit,
    ROUND(AVG(UnitPrice),2) AS AVG_Price
FROM FactInternetSales
GROUP BY ProductKey
ORDER BY ProductKey

SELECT * FROM FactInternetSales

-- Question 2: Tính tổng và trung bình Unit_Cost theo từng ProductKey trong bảng FactProductInventory

SELECT
    ProductKey,
    SUM(UnitCost) AS Tổng,
    AVG(UnitCost) AS Trung_bình
FROM FactProductInventory
Group by productkey

-- Part V: Luyện tập 

-- Question 1: Thống kê tên và thu nhập từng nhóm đối tượng khách hàng với cột mới là 'Customer_Income_Level'
               --Với khách hàng có thu nhập giao động từ 100000 đến 170000 => 'High_Income_Customer'
               --Với khách hàng có thu nhập lớn hơn 50000 và nhỏ hơn 100000 => 'Middle_InCome_Customer'
               --Với khách hàng có thu nhập hằng năm dưới hoặc bằng 50000 => 'Low_Income_Customer'

SELECT
    CustomerKey,
    CONCAT_WS(' ',FirstName,MiddleName,LastName) AS Fullname,
    YearlyIncome,
    CASE 
        WHEN YearlyIncome <= 50000 THEN 'Low_Income_Customer'
        WHEN YearlyIncome > 50000 AND YearlyIncome < 100000 THEN 'Middle_Income_Customer'
        WHEN YearlyIncome >= 100000 AND YearlyIncome <= 170000 THEN 'High_Income_Customer'
    ELSE 'Undefined'
    END AS 'Customer_Income_Level'
FROM DimCustomer

-- Question 2: (Dùng bảng FactInternetSales): Liệt kê danh sách khách hàng theo customer_key và lợi nhuận của từng khách hàng  trong 2 năm 2011 và 2012 (Làm tròn đến số thập phân thứ 2)
-- Thêm cột Customer_Level theo 3 điều kiện sau:             
               --Với những khách hàng mang lại lợi nhuận từ 1000 đến 2300 là 'Premium_Customer'
               --Với những khách hàng mang lại lợi nhuận từ 470 đến 999 là 'Gold_Customer'
               --Với những khách hàng mang lại lợi nhuận từ 300 đến 460 là 'Silver_Customer'
-- Sắp xếp theo lợi nhuận từ cao đến thấp

SELECT
    CustomerKey,
    YEAR(OrderDate) Year_Order,
    ROUND(SUM(SalesAmount)-SUM(ProductStandardCost),2) AS Profit,
    CASE 
        WHEN SUM(SalesAmount)-SUM(ProductStandardCost) BETWEEN 300 AND 460 THEN 'Silver_Customer'
        WHEN SUM(SalesAmount)-SUM(ProductStandardCost) BETWEEN 470 AND 999 THEN 'Gold_Customer'
        WHEN SUM(SalesAmount)-SUM(ProductStandardCost) BETWEEN 1000 AND 2300 THEN 'Premium_Customer'
        ELSE 'Normal_Customer'
    END AS 'Customer_Level'
FROM FactInternetSales
WHERE YEAR(OrderDate) IN ('2011','2012')
GROUP BY CustomerKey, YEAR(OrderDate)
ORDER BY 3 DESC

SELECT * FROM FactInternetSales

-- Question 3: Thống kê khách hàng là đối tượng cho dòng xe mới của công ty (8-10 chỗ) và tạo 1 cột mới 'MALE_TARGET_CUSTOMER' theo tiêu chí:
        -- Là đàn ông đã lập gia đình và đã có ít nhất 1 căn nhà, có 2 đứa con và sở hữu trên 2 chiếc xe và thu nhập hằng năm giao động từ 100000 đến 170000  => 'Premium_Class_Target_Customer'
        -- Là Single Dad đã có nhà và có dưới 3 người con và ít nhất đã sỡ hữu xe hoặc thu nhập lớn hơn 50000 và nhỏ hơn 100000  => 'Middle_Class_Customer'
        -- Là Đàn ông đã có gia đình và có thể có con hoặc chưa có con, chưa có chiếc xe nào và hiện đang ở nhà thuê và thu nhập trong khoảng từ 30000 đến 50000 => 'Affordable_class_Target_customer'
        -- Còn lại là Other

SELECT 
    DC.CustomerKey AS Customer_Key,
    DC.FirstName AS First_Name, 
    DC.LastName AS Last_Name,
    DC.MaritalStatus AS Marital_Status,
    DC.Gender,
    DC.TotalChildren AS Total_Children,
    DC.HouseOwnerFlag AS House_Owner_Flag,
    DC.NumberCarsOwned AS Number_Cars_Owned,
    DC.YearlyInCome AS Yearly_Income,
    DG.EnglishCountryRegionName AS Country_Name,
CASE 
    WHEN MaritalStatus = 'M' AND Gender = 'M' AND TotalChildren > 2 AND  NumberCarsOwned > 2 AND HouseOwnerFlag > 0 AND YearlyIncome BETWEEN 100000 AND 170000  THEN 'PREMIUM_CLASS_TARGET_CUSTOMER'
    WHEN MaritalStatus = 'S' AND Gender = 'M' AND TotalChildren < 3 AND NumberCarsOwned >= 1 AND HouseOwnerFlag > 0 AND YearlyIncome > 50000 AND YearlyIncome < 100000 THEN 'MIDDLE_CLASS_TARGET_CUSTOMER'
    WHEN MaritalStatus = 'M' AND Gender = 'M' AND TotalChildren <= 1 AND NumberCarsOwned = 0 AND HouseOwnerFlag = 0 AND YearlyIncome > 30000 AND YearlyIncome < 50000 THEN 'AFFORADBLE_CLASS_TARGET_CUSTOMER'
    ELSE 'OTHER'
END AS 'TARGET_CUSTOMER'
FROM DimCustomer AS DC
LEFT JOIN DimGeography AS DG ON DC.GeographyKey = DG.GeographyKey
WHERE EnglishCountryRegionName IN ('United States', 'France', 'Canada')
GROUP BY   
    CustomerKey,
    FirstName,
    LastName,
    MaritalStatus,
    Gender,
    TotalChildren,
    HouseOwnerFlag,
    NumberCarsOwned,
    YearlyIncome,
    EnglishCountryRegionName
ORDER BY Target_Customer DESC; 


-- Question 4: Thống kê xem Product nào cần FILL IN (NEED TO FILL IN) và không cần FILL IN (NO NEED TO FILL IN) Sắp xếp theo thứ tự giảm dần trong bảng FactProductInventory.

SELECT 
    ProductKey AS Product_key,
    MovementDate AS Movement_Date,
    UnitsIN AS Units_IN,
    UnitsOut AS Units_OUT,
    UnitsBalance AS Units_Balance,
CASE 
    WHEN UnitsBalance > 0 THEN 'NO NEED TO FILL IN'
    WHEN UnitsBalance < 0 THEN 'NEED TO FILL IN'
    ELSE 'Unidentified'
END AS 'Current_Stock_Status'
FROM FactProductInventory
ORDER BY UnitsBalance ASC;

-- Class 7: 20/11/2023: Làm việc nhiều bảng với JOINs
-- Practice Question 1
-- Question 1: Xác định tất cả các key trong bảng FactFinance.
Select * From dbo.FactFinance
-- Question 2: Xác định Organization Name Theo từng OrganizationKey và FinanceKey.
SELECT
    FF.FinanceKey,
    FF.OrganizationKey,
    DO.OrganizationName
FROM dbo.FactFinance AS FF
LEFT JOIN DBO.DimOrganization AS DO
ON FF.OrganizationKey = DO.OrganizationKey
-- Question 3: Xác định Organization Name sẽ tương ứng với DeparmentGroupKey và Finance Key nào và tên của Department Group là gì?
SELECT
    FF.FinanceKey,
    FF.DepartmentGroupKey,
    DO.OrganizationName,
    DG.DepartmentGroupName
FROM dbo.FactFinance AS FF
LEFT JOIN DBO.DimOrganization AS DO ON FF.OrganizationKey = DO.OrganizationKey
LEFT JOIN DBO.DimDepartmentGroup AS DG ON FF.DepartmentGroupKey = DG.DepartmentGroupKey
-- Question 4: Xác định xem với các thông tin Organization Name, Deparment Group Name sẽ tương ứng với ScenarioKey và ScenarioName nào?
SELECT
    FF.FinanceKey,
    FF.OrganizationKey,
    FF.DepartmentGroupKey,
    DO.OrganizationName,
    DG.DepartmentGroupName,
    FF.ScenarioKey,
    DS.ScenarioName
FROM dbo.FactFinance AS FF
LEFT JOIN DBO.DimOrganization AS DO ON FF.OrganizationKey = DO.OrganizationKey
LEFT JOIN DBO.DimDepartmentGroup AS DG ON FF.DepartmentGroupKey = DG.DepartmentGroupKey
LEFT JOIN dbo.DimScenario AS DS ON FF.ScenarioKey = DS.ScenarioKey
-- Question 5: Chỉ lấy thông tin trong list name departmentGroup Quality Assurance, Manufacturing và Corporate.
SELECT
    FF.FinanceKey,
    FF.OrganizationKey,
    FF.DepartmentGroupKey,
    DO.OrganizationName,
    DG.DepartmentGroupName,
    FF.ScenarioKey,
    DS.ScenarioName
FROM dbo.FactFinance AS FF
LEFT JOIN DBO.DimOrganization AS DO ON FF.OrganizationKey = DO.OrganizationKey
LEFT JOIN DBO.DimDepartmentGroup AS DG ON FF.DepartmentGroupKey = DG.DepartmentGroupKey
LEFT JOIN dbo.DimScenario AS DS ON FF.ScenarioKey = DS.ScenarioKey
WHERE DG.DepartmentGroupName IN ('Quality Assurance','Manufacturing','Corporate')
-- Practice Question 2: Với Case Problem Statement đã làm ở lớp T6/17/11/2023
-- Question 1: Chúng ta đã thiếu mất 1 yếu tố nào trong câu query?
-- Question 2: Dùng Hàm Join để xác định thông tin yếu tố đó.
-- Practice Question 3: 
-- Question 1: Lấy thông tin cột customerkey, Produckey and orderdatekey trong bảng FactInternet Sale
select * from FactInternetSales
SELECT 
    FF.CustomerKey AS Customer_Key,
    FF.ProductKey AS Product_Key,
    FF.OrderDateKey AS Order_Date_Key 
FROM FactInternetSales AS FF;
-- Question 2: Từ bảng trên tìm hiểu xem customerkey sẽ tương ứng với tên của khách hàng nào (nghề nghiệp và thu nhập của họ ra sao) cùng với product key và orderDate Key 
SELECT 
    FF.CustomerKey AS Customer_Key,
    FF.ProductKey AS Product_Key,
    FF.OrderDateKey AS Order_Date_Key,
    CONCAT_WS(' ', DC.FirstName, DC.MiddleName, DC.LastName) AS Full_name,
    DC.EnglishOccupation AS Job,
    dc.YearlyIncome as Income 
FROM FactInternetSales AS FF
LEFT JOIN DimCustomer AS DC ON FF.CustomerKey = DC.CustomerKey
-- Question 3: Từ kết quả thu được ở question 2, tìm hiểu xem product key sẽ tưng ứng với tên sản phẩm nào và orderDatekey.
SELECT 
    FF.CustomerKey AS Customer_Key,
    FF.ProductKey AS Product_Key,
    DP.EnglishProductName AS Product_name,
    FF.OrderDateKey AS Order_Date_Key,
    CONCAT_WS(' ', DC.FirstName, DC.MiddleName, DC.LastName) AS Full_name,
    DC.EnglishOccupation AS Job,
    dc.YearlyIncome as Income
FROM FactInternetSales AS FF
LEFT JOIN DimCustomer AS DC ON FF.CustomerKey = DC.CustomerKey
LEFT JOIN DimProduct AS DP ON FF.ProductKey = DP.ProductKey
-- Question 4: Từ kết quả thu được ở question 3, tìm hiểu xem ngày khách hàng order tương ứng ngày tháng năm nào và thuộc thứ mấy trong tuần
SELECT 
    FF.CustomerKey AS Customer_Key,
    FF.ProductKey AS Product_Key,
    DP.EnglishProductName AS Product_name,
    FF.OrderDateKey AS Order_Date_Key,
    DD.FullDateAlternateKey AS Fulldate,
    DD.EnglishDayNameOfWeek AS Name_of_day,
    CONCAT_WS(' ', DC.FirstName, DC.MiddleName, DC.LastName) AS Full_name,
    DC.EnglishOccupation AS Job,
    dc.YearlyIncome as Income
FROM FactInternetSales AS FF
LEFT JOIN DimCustomer AS DC ON FF.CustomerKey = DC.CustomerKey
LEFT JOIN DimProduct AS DP ON FF.ProductKey = DP.ProductKey
LEFT JOIN DimDate AS DD ON FF.OrderDateKey = DD.DateKey
-- Question 5: Truy vấn danh sách sản phẩm đã được mua của tất cả những khách hàng có FirstName bắt đầu bằng chữ C
SELECT 
    FF.CustomerKey AS Customer_Key,
    FF.ProductKey AS Product_Key,
    DP.EnglishProductName AS Product_name,
    FF.OrderDateKey AS Order_Date_Key,
    DD.FullDateAlternateKey AS Fulldate,
    DD.EnglishDayNameOfWeek AS Name_of_day,
    CONCAT_WS(' ', DC.FirstName, DC.MiddleName, DC.LastName) AS Full_name,
    DC.EnglishOccupation AS Job,
    dc.YearlyIncome as Income
FROM FactInternetSales AS FF
LEFT JOIN DimCustomer AS DC ON FF.CustomerKey = DC.CustomerKey
LEFT JOIN DimProduct AS DP ON FF.ProductKey = DP.ProductKey
LEFT JOIN DimDate AS DD ON FF.OrderDateKey = DD.DateKey
WHERE DC.FirstName LIKE 'C%'
-- Question 6: Truy vấn danh sách sản phẩm đã được mua của tất cả những khách hàng có chữ 'Watson' trong tên
SELECT 
    FF.CustomerKey AS Customer_Key,
    FF.ProductKey AS Product_Key,
    DP.EnglishProductName AS Product_name,
    FF.OrderDateKey AS Order_Date_Key,
    DD.FullDateAlternateKey AS Fulldate,
    DD.EnglishDayNameOfWeek AS Name_of_day,
    CONCAT_WS(' ', DC.FirstName, DC.MiddleName, DC.LastName) AS Full_name,
    DC.EnglishOccupation AS Job,
    dc.YearlyIncome as Income
FROM FactInternetSales AS FF
LEFT JOIN DimCustomer AS DC ON FF.CustomerKey = DC.CustomerKey
LEFT JOIN DimProduct AS DP ON FF.ProductKey = DP.ProductKey
LEFT JOIN DimDate AS DD ON FF.OrderDateKey = DD.DateKey
WHERE CONCAT_WS(' ', DC.FirstName, DC.MiddleName, DC.LastName) LIKE '%WATSON%'
-- Question 7: Truy vấn danh sách sản phẩm đã được mua của tất cả những khách hàng có chữ 'Watson' trong tên và mua hàng trong 2 năm 2011 và 2012
SELECT 
    FF.CustomerKey AS Customer_Key,
    FF.ProductKey AS Product_Key,
    DP.EnglishProductName AS Product_name,
    FF.OrderDateKey AS Order_Date_Key,
    DD.FullDateAlternateKey AS Fulldate,
    DD.EnglishDayNameOfWeek AS Name_of_day,
    CONCAT_WS(' ', DC.FirstName, DC.MiddleName, DC.LastName) AS Full_name,
    DC.EnglishOccupation AS Job,
    dc.YearlyIncome as Income
FROM FactInternetSales AS FF
LEFT JOIN DimCustomer AS DC ON FF.CustomerKey = DC.CustomerKey
LEFT JOIN DimProduct AS DP ON FF.ProductKey = DP.ProductKey
LEFT JOIN DimDate AS DD ON FF.OrderDateKey = DD.DateKey
WHERE CONCAT_WS(' ', DC.FirstName, DC.MiddleName, DC.LastName) LIKE '%WATSON%'
AND YEAR(FF.OrderDate) IN ('2011','2012')
-- Question 8: Truy vấn danh sách sản phẩm đã được mua của tất cả những khách hàng sống ở Mỹ và mua hàng trong 2 năm 2011 và 2012 và thu nhập từ 100000 đến 1700000 và sắp xếp theo thứ tự income giảm dần;
SELECT 
    FF.CustomerKey AS Customer_Key,
    FF.ProductKey AS Product_Key,
    DP.EnglishProductName AS Product_name,
    FF.OrderDateKey AS Order_Date_Key,
    DD.FullDateAlternateKey AS Fulldate,
    DD.EnglishDayNameOfWeek AS Name_of_day,
    CONCAT_WS(' ', DC.FirstName, DC.MiddleName, DC.LastName) AS Full_name,
    DC.EnglishOccupation AS Job,
    dc.YearlyIncome as Income
FROM FactInternetSales AS FF
LEFT JOIN DimCustomer AS DC ON FF.CustomerKey = DC.CustomerKey
LEFT JOIN DimProduct AS DP ON FF.ProductKey = DP.ProductKey
LEFT JOIN DimDate AS DD ON FF.OrderDateKey = DD.DateKey
LEFT JOIN DimGeography AS DG ON DC.GeographyKey = DG.GeographyKey
WHERE DG.EnglishCountryRegionName = 'United States'
AND YEAR(FF.OrderDate) IN ('2011','2012')
AND DC.YearlyIncome BETWEEN 100000 AND 1700000 
ORDER BY DC.YearlyIncome DESC

-- CASE STUDY BUỔI 6
-- Problem Statement: Công ty đang muốn cải thiện chính sách ưu đãi cho những khách hàng đã mua 
-- 2 dòng xe đạp (Bikes) mới (Mountain Bikes và Touring Bikes) trong 2 năm 2011 và 2012 ở 
-- 3 thị trường chính của công ty là Úc, Anh và Pháp
-- Chính sách này muốn tập trung cho 3 phân phúc khách hàng
------ Premium_Customer: với những khách hàng mua sp có giá > $2049
------ Gold_Customer: với những khách hàng mua sp có giá > $1000 và < $2049
------ Silver_Customer: với những khách hàng mua sp có giá > $539 và < $1000

select * from FactInternetSales

SELECT
    FS.CustomerKey,
    CONCAT_WS(' ',DC.FirstName,DC.MiddleName,DC.LastName) AS Fullname,
    DC.EmailAddress,
    DC.YearlyIncome,
    DG.EnglishCountryRegionName AS Country,
    FS.ProductKey,
    DP.EnglishProductName,
    DPS.EnglishProductSubcategoryName,
    FS.UnitPrice,
    CASE
        WHEN FS.UnitPrice > 539 AND FS.UnitPrice < 1000 THEN 'Silver_Customer'
        WHEN FS.UnitPrice >= 1000 AND FS.UnitPrice < 2049 THEN 'Gold_Customer'
        WHEN FS.UnitPrice >= 2049 THEN 'Premium_Customer'
    ELSE 'Normal_Customer'
    END AS 'Customer_Segment',
    FS.OrderDate
FROM FactInternetSales AS FS 
LEFT JOIN DimCustomer AS DC ON FS.CustomerKey = DC.CustomerKey
LEFT JOIN DimProduct AS DP ON FS.ProductKey = DP.ProductKey
LEFT JOIN DimProductSubcategory AS DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
LEFT JOIN DimGeography AS DG ON DC.GeographyKey = DG.GeographyKey
WHERE DPS.EnglishProductSubcategoryName IN ('Mountain Bikes','Touring Bikes')
AND YEAR(FS.OrderDate) IN ('2011','2012')
AND DG.EnglishCountryRegionName IN ('Australia','France','United Kingdom')
ORDER BY FS.UnitPrice

SELECT 
    Customerkey,
    FirstName,
    Lastname,
    Concat(FirstName,' ',LastName) as Full_name
FROM Dimcustomer

-- BUỔI 7 ÔN TẬP JOIN NHIỀU BẢNG

-- Question 1: Xác định Reseller name hiện đang kinh doanh ở region và thành phố nào cùng với Reseller Key và Geography Key
SELECT
    DR.ResellerKey,
    DR.ResellerName,
    DG.GeographyKey,
    DG.EnglishCountryRegionName,
    DG.City
FROM DimReseller AS DR 
LEFT JOIN DimGeography AS DG
ON DR.GeographyKey = DG.GeographyKey

-- Question 2: Xuất dữ liệu từ bảng Factinternetsales và 1 cột mới là tên currency name và 1 cột mới về tỉ giá

SELECT
    FIS.ProductKey,
    FIS.CurrencyKey,
    DC.CurrencyName,
    ROUND(FCR.EndOfDayRate,2) AS Currency_rate
FROM FactInternetSales AS FIS 
LEFT JOIN DimCurrency AS DC ON FIS.CurrencyKey = DC.CurrencyKey
LEFT JOIN FactCurrencyRate AS FCR ON DC.CurrencyKey = FCR.CurrencyKey

SELECT * FROM DimCurrency
SELECT * FROM FactCurrencyRate

-- Question 3: Xác định Sales KPI (Sales_Amount_Quota) của từng nhân viên thuộc các department khác nhau ở các khu vực Sales Region và Sales Country tương ứng
-- Thông tin nhân viên cần bao gồm: ID, Full_name của nhân viên, giới tính, title, email_address và sắp xếp theo KPI giảm dần.

SELECT
    DE.EmployeeKey,
    CONCAT_WS(' ',DE.FirstName,DE.MiddleName,DE.LastName) AS Full_name,
    DE.Gender,
    DE.Title,
    DE.EmailAddress,
    DE.DepartmentName,
    DST.SalesTerritoryRegion,
    DST.SalesTerritoryCountry,
    FSQ.SalesAmountQuota
FROM DimEmployee AS DE 
LEFT JOIN FactSalesQuota AS FSQ ON DE.EmployeeKey = FSQ.EmployeeKey
LEFT JOIN DimSalesTerritory AS DST ON DE.SalesTerritoryKey = DST.SalesTerritoryKey
ORDER BY FSQ.SalesAmountQuota DESC

-- Question 4: 
-- a.Đếm có bao nhiêu ProductCategoryName và tên của CategoryName đó là gì?
-- b.Lấy hết thông tin liên quan của Productname, ProductCategoryName là 'Components' và ProductSubcategoryName là 'Road Bikes' và lợi nhuận mà nó mang lại trong 2 nàm 2011 và 2012

SELECT * FROM DimProductCategory
-- a. Có 4 ProductCategoryName là Bikes, Components, Clothing, Accessories
-- b. Query

SELECT
    DP.ProductKey,
    DP.EnglishProductName,
    DPS.EnglishProductSubcategoryName,
    DPC.EnglishProductCategoryName,
    FIS.TotalProductCost,
    FIS.SalesAmount,
    SUM(FIS.SalesAmount - FIS.TotalProductCost) AS Profit
FROM DimProduct AS DP 
LEFT JOIN DimProductSubcategory AS DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS DPC ON DPC.ProductCategoryKey = DPS.ProductCategoryKey
LEFT JOIN FactInternetSales AS FIS ON DP.ProductKey = FIS.ProductKey
WHERE
    DPC.EnglishProductCategoryName = 'Components'
    AND DPS.EnglishProductSubcategoryName = 'Road Bikes'
    AND YEAR(FIS.OrderDate) IN ('2011', '2012')
GROUP BY 
    DP.ProductKey,
    DP.EnglishProductName,
    DPS.EnglishProductSubcategoryName,
    DPC.EnglishProductCategoryName,
    FIS.TotalProductCost,
    FIS.SalesAmount;

SELECT * FROM FactInternetSales

-- Bài mẫu
SELECT 
    DP.ProductKey AS Product_Key,
    DP.EnglishProductName AS Product_Name,
    DPC.EnglishProductCategoryName AS Product_Category_Name,
    DPS.EnglishProductSubcategoryName AS Product_Subcategory_Name,
    FI.UnitPrice AS Unit_Price,
    FI.ProductStandardCost AS Product_Standard_Cost, 
    SUM(FI.UnitPrice - FI.ProductStandardCost) AS Profit
FROM DimProduct AS DP 
LEFT JOIN DimProductSubcategory AS DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
LEFT JOIN FactInternetSales AS FI ON FI.ProductKey = DP.ProductKey
LEFT JOIN DimProductCategory AS DPC ON DPC.ProductCategoryKey = DPS.ProductSubcategoryKey
WHERE 
    DPC.EnglishProductCategoryName = 'Components'
    AND DPS.EnglishProductSubcategoryName = 'Road Bikes'
    AND YEAR(FI.OrderDate) IN ('2011', '2012')
GROUP BY 
    DP.ProductKey,
    DP.EnglishProductName,
    DPC.EnglishProductCategoryName,
    DPS.EnglishProductSubcategoryName,
    FI.UnitPrice,
    FI.ProductStandardCost;

-- Question 5: Data Storytelling - Case study 

SELECT 
    CONCAT(DC.Firstname, ' ', DC.LastName) AS Full_Name,
     DC.Gender AS Gender,
    DC.EmailAddress AS Customer_Email,
    DC.YearlyIncome AS Customer_Income,
    DPR.EnglishPromotionName AS Current_Promotion,
    DP.EnglishProductName AS Product_Name,
    DPC.EnglishProductCategoryName AS Product_Category_Name,
    DPS.EnglishProductSubcategoryName AS Product_Subcategory_Name,
    FI.OrderQuantity AS Order_Quantity,
    DST.SalesTerritoryRegion AS Region,
    DST.SalesTerritoryCountry AS Country,
    YEAR(FI.OrderDate) AS Order_Year,
    FI.UnitPrice AS Unit_Price,
CASE 
    WHEN UnitPrice > 2049 THEN 'PREMIUM_CUSTOMER'
    WHEN UnitPrice > 1000  AND  UnitPrice < 2049  THEN 'GOLD_CUSTOMER'
    WHEN UnitPrice > 539  AND  UnitPrice < 10000  THEN 'SILVER_CUSTOMER'
ELSE 'Other'
END AS 'Customer_Segment'
FROM FactInternetSales AS FI
LEFT JOIN DimPromotion AS DPR ON FI.PromotionKey = DPR.PromotionKey
LEFT JOIN DimCustomer AS DC ON FI.CustomerKey = DC.CustomerKey
LEFT JOIN DimProduct AS DP ON FI.ProductKey = DP.ProductKey
LEFT JOIN DimProductSubCategory AS DPS ON DPS.ProductSubcategoryKey = DP.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS DPC ON  DPS.ProductCategoryKey = DPC.ProductCategoryKey
LEFT JOIN DimSalesTerritory AS DST ON FI.SalesTerritoryKey = DST.SalesTerritoryKey
WHERE DST.SalesTerritoryCountry IN  ('Australia', 'United Kingdom', 'France') 
AND DPC.EnglishProductCategoryName = 'Bikes' 
AND DPS.EnglishProductSubcategoryName IN ('Mountain Bikes', 'Touring Bikes')
AND YEAR(OrderDate) IN ('2011', '2012')

-- Question 6: Xuất bảng mới từ kênh nhà phân phối trong năm 2013 và 2014 với các nội dung như sau:
----Tên sản phẩm, Subcategory, Category sản phẩm, Resellerkey, resellername, territory countries, 
-- currency name, currency rate, Order Quantity, Unit Price, Total Product Cost, Sales Amount, Tax Amt, Order date. 
----Chú ý các cột về giá trị cần được đổi về đúng đơn vị currency.

-- BẢNG CẦN DỤNG Product, Productcate, Productsubcate, reseller, salesterritory, factresseller, factcurrency

SELECT
    DP.ProductKey,
    DP.EnglishProductName,
    DPS.EnglishProductSubcategoryName,
    DPC.EnglishProductCategoryName,
    DR.ResellerKey,
    DR.ResellerName,
    DST.SalesTerritoryCountry,
    DC.CurrencyName,
    FCR.EndOfDayRate,
    FRS.OrderQuantity,
    ROUND(FRS.TotalProductCost*FCR.EndOfDayRate,2) AS 'Total Product Cost',
    ROUND(FRS.SalesAmount*FCR.EndOfDayRate,2) AS 'Sales Amount',
    ROUND(FRS.TaxAmt*FCR.EndOfDayRate,2) AS 'Tax Amount',
    FRS.OrderDate
FROM FactResellerSales AS FRS
LEFT JOIN DimProduct AS DP ON DP.ProductKey = FRS.ProductKey
LEFT JOIN DimProductSubcategory AS DPS ON DPS.ProductSubcategoryKey = DP.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS DPC ON DPS.ProductCategoryKey = DPC.ProductCategoryKey
LEFT JOIN DimReseller AS DR ON DR.ResellerKey = FRS.ResellerKey
LEFT JOIN DimSalesTerritory as DST ON DST.SalesTerritoryKey = FRS.SalesTerritoryKey
LEFT JOIN DimCurrency AS DC ON DC.CurrencyKey = FRS.CurrencyKey
LEFT JOIN FactCurrencyRate AS FCR ON FCR.CurrencyKey = DC.CurrencyKey AND FRS.DueDateKey = FCR.DateKey 
WHERE YEAR(FRS.OrderDate) IN ('2013','2014')
ORDER BY DP.ProductKey
