--Watson June 2024

--Cleaning Data Project 
--from Nashville housing dataset

Select * from [SQL project].[dbo].[Nashville_Housing_Data]

--Standardize Date format

Select saledate, CONVERT(Date, Saledate)
from [SQL project].[dbo].[Nashville_Housing_Data]

Update [SQL project].[dbo].[Nashville_Housing_Data]
SET SaleDate = CONVERT(Date, Saledate)

--Populate Property Address data

Select *
from [SQL project].[dbo].[Nashville_Housing_Data]
Where propertyaddress is null


Select a.parcelID, a.Propertyaddress, b.ParcelID, b.Propertyaddress,ISNULL(a.Propertyaddress, b.Propertyaddress)
from [SQL project].[dbo].[Nashville_Housing_Data] a
join [SQL project].[dbo].[Nashville_Housing_Data] b
on a.ParcelID = b.ParcelID
and a.[UniqueID]<> b.[UniqueID]
Where a.propertyaddress is null

Update a
Set Propertyaddress = ISNULL(a.Propertyaddress, b.Propertyaddress)
from [SQL project].[dbo].[Nashville_Housing_Data] a
join [SQL project].[dbo].[Nashville_Housing_Data] b
on a.ParcelID = b.ParcelID
and a.[UniqueID]<> b.[UniqueID]

-- Breaking out Address into individual columns (Address, City, State)

Select Propertyaddress
from [SQL project].[dbo].[Nashville_Housing_Data]

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [SQL project].[dbo].[Nashville_Housing_Data]

Alter Table [SQL project].[dbo].[Nashville_Housing_Data]
add PropertySplitCity Nvarchar(255);

Update [SQL project].[dbo].[Nashville_Housing_Data]
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table [SQL project].[dbo].[Nashville_Housing_Data]
Add PropertySplitAddress Nvarchar(255);

Update [SQL project].[dbo].[Nashville_Housing_Data]
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select * from [SQL project].[dbo].[Nashville_Housing_Data]

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
		ROW_NUMBER() OVER(
		PARTITION BY ParcelID,
							     PropertyAddress,
								 SalePrice,
								 SaleDate,
								 LegalReference
								 ORDER BY
										UniqueID
										) row_num

from [SQL project].[dbo].[Nashville_Housing_Data] 
)

Select *
From RowNumCTE
Where row_num > 1 
Order by PropertyAddress


-- Delete Unused Columns

ALTER TABLE [SQL project].[dbo].[Nashville_Housing_Data]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate






