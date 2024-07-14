/* 

	CLEANING DATA IN SQL

*/

SELECT *
FROM PortfolioProjects..NashVilleHousingOld

-- Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProjects..NashVilleHousingOld

ALTER TABLE PortfolioProjects..NashVilleHousingOld
ADD SaleDateConverted Date

UPDATE PortfolioProjects..NashVilleHousingOld
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Populate Property Address Data

SELECT *
FROM PortfolioProjects..NashVilleHousingOld
-- WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
	ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects..NashVilleHousingOld a
JOIN PortfolioProjects..NashVilleHousingOld b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is Null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects..NashVilleHousingOld a
JOIN PortfolioProjects..NashVilleHousingOld b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is Null

-- Breaking Out Address into Individual Columns (Address, city, State)

-- (Splitting Property Address)

SELECT PropertyAddress
FROM PortfolioProjects..NashVilleHousingOld
-- WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
	
FROM PortfolioProjects..NashVilleHousingOld


ALTER TABLE PortfolioProjects..NashVilleHousingOld
ADD PropertySplitAddress nvarchar(255)

UPDATE PortfolioProjects..NashVilleHousingOld
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE PortfolioProjects..NashVilleHousingOld
ADD PropertySplitCity nvarchar(255)

UPDATE PortfolioProjects..NashVilleHousingOld
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
FROM PortfolioProjects..NashVilleHousingOld


-- (Splitting Owner Address)

SELECT OwnerAddress
FROM PortfolioProjects..NashVilleHousingOld

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM PortfolioProjects..NashVilleHousingOld


ALTER TABLE PortfolioProjects..NashVilleHousingOld
ADD OwnerSplitAddress nvarchar(255)

UPDATE PortfolioProjects..NashVilleHousingOld
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfolioProjects..NashVilleHousingOld
ADD OwnerSplitCity nvarchar(255)

UPDATE PortfolioProjects..NashVilleHousingOld
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE PortfolioProjects..NashVilleHousingOld
ADD OwnerSplitState nvarchar(255)

UPDATE PortfolioProjects..NashVilleHousingOld
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant) 
FROM PortfolioProjects..NashVilleHousingOld
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProjects..NashVilleHousingOld

UPDATE PortfolioProjects..NashVilleHousingOld
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


-- Remove Duplicates

WITH RowNumCTE AS (
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY  ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) row_num

FROM PortfolioProjects..NashVilleHousingOld
--ORDER BY ParcelID
)

SELECT *
--DELETE
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


-- DELETE Unused Columns

SELECT *
FROM PortfolioProjects..NashVilleHousingOld

ALTER TABLE PortfolioProjects..NashVilleHousingOld
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProjects..NashVilleHousingOld
DROP COLUMN SaleDate