--tạo khung hình lấy ra thông tin cơ bản trong Persom.Contact
CREATE VIEW V_Contact_Info As
SELECT FirstName, MiddleName, LastName
FROM Person.Person
Go

--tạo khung nhìn lấy ra thông tin về nhân viên
CREATE View V_Employee_Contact AS
SELECT p.FirstName, p.LastName, e.BusinessEntityId, e.HireDate
FROM HumanResources.Employee e
Join Person.Person AS p On e.BusinessEntityID = p.BusinessEntityID ;
Go

--xem khung nhìn
SELECT * FROM V_Employee_Contact
Go

--thay đổi khung hùng V_Employee_Contact băng việt thêm cột Birthdate
ALTER VIEW V_Employee_Contact AS
SELECT p.FirstName, P.lastName, e.BusinessEntityID, e.HireDate
FROM HumanResources.Employee e
JOIN Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID
WHERE p.FirstName like '%B%';

--xoá một khung hình
DROP VIEW V_Contact_Info
Go

--xem định nghĩ khung hình V_Employee_Contact 
sp_helptext 'V_Employee_Contact'

--xem các thành phần mà khung nhìn phụ thuộc
sp_depends 'V_Employee_Contact'
Go
--tạo khung hình ẩn mà định nghĩa bị ẩn đi (không xem được định nghĩa khung hình)
CREATE VIEW OrderRejects
WITH ENCRYPTION
AS
SELECT PurchaseOrderID, ReceivedQty, RejectedQty,
		RejectedQty/ receivedQty AS RejectRatio, DueDate
FROM Purchasing.PurchaseOrderDetail
WHERE RejectedQty / ReceivedQty >0
AND DueDate > CONVERT (DATETIME,'20010630',101) ,

--không xem được định nghĩa khung nhìn V_Employee_Info
sp_helptext 'OrderRejects'
Go

--thay đổi khung nhìn thêm tuỳ chọn CHECK OPTION
ALTER VIEW V_Employee_Contact AS
SELECT p.FirstName, p.lastName, e.BusinessEntityID, e.HireDate
FROM HumanResources.Employee e
JOIN Person.Person AS p On e.BusinessEntityID = p.BusinessEntityID
WHERE p.FirstName like 'A%'
WITH CHECK OPTION
GO

--cập nhật được khung nhìn khi lastname bắt đầu bằng ký tự 'A'
UPDATE V_Employee_Contact SET FirstName='Atest' WHERE LastName='Amy'
--không cập nhập khung nhìn khi lastname bắt đầu bằng ký tự khac 'A'
UPDATE V_Employee_Contact SET FirstName='BCD' WHERE LastName='Atest'
Go

--phải xoá khung nhìn trước
DROP VIEW V_Contact_Info
Go
--tạo khung nhì có giản đồ
CREATE VIEW V_Contact_Info WITH SCHEMABINDING AS
SELECT FirstNAme, MiddleName, LastName, EmailAddress
FROM Person.Contact
Go
--không thể truy vấn được khung nhìn có tên là V_Contact_Info
select * from V_Contact_Info
Go

--tạo chỉ mục duy nhất trên cột EmailAddress trên khung nhìn V_Contact_Info
CREATE UnIQUE CLUSTERED INDEX IX_contact_EMail
On V_Contact_Info(EmailAddress)
Go

--thực hiên đổi tên khung nhìn
exec sp_rename V_Contact_Info, V_Contact_Infomation
--truy vấn khung nhìn
select * from V_Contact_Infomation

--không thể thêm bản ghi vào khung nhìn vì có côt không cho phép null trong bảng contact
INSERT INTO V_Contact_Infomation values ('ABC','DEF','GHI','abc@yahoo.com') 

--không thể xoá bản ghi của khung nhìn V_Contact_Infomation vì bảng person.contact còn có các khoá ngoại
DELETE V_Contact_Infomation WHERE LastName='Gilbert' and Firstname='Guy'