-- Cleaning Data in SQL queries

SELECT *
FROM CleaningPortfolioProject.dbo.NashvilleHousing

-- Standardize Data 

SELECT SaleDateConverted, CONVERT(DATE, SaleDate)
FROM CleaningPortfolioProject.dbo.NashvilleHousing

UPDATE CleaningPortfolioProject.dbo.NashvilleHousing
SET SaleDate = CONVERT(DATE, SaleDate)

ALTER TABLE CleaningPortfolioProject.dbo.NashvilleHousing
ADD SaleDateConverted Date;

UPDATE CleaningPortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate)

-- Populate Property Address Data

SELECT PropertyAddress
FROM CleaningPortfolioProject.dbo.NashvilleHousing

SELECT *
FROM CleaningPortfolioProject.dbo.NashvilleHousing
ORDER BY ParcelID


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM CleaningPortfolioProject.dbo.NashvilleHousing a
JOIN CleaningPortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM CleaningPortfolioProject.dbo.NashvilleHousing a
JOIN CleaningPortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- Breaking out Address Into Individual Columns(Address, City, State)

SELECT PropertyAddress
FROM CleaningPortfolioProject.dbo.NashvilleHousing

 SELECT  
 SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) AS Address
  ,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Address
 FROM CleaningPortfolioProject.dbo.NashvilleHousing

 ALTER TABLE CleaningPortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE CleaningPortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress =  SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE CleaningPortfolioProject.dbo.NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE CleaningPortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM CleaningPortfolioProject.dbo.NashvilleHousing

SELECT OwnerAddress
FROM CleaningPortfolioProject.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM CleaningPortfolioProject.dbo.NashvilleHousing


 ALTER TABLE CleaningPortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE CleaningPortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)


 ALTER TABLE CleaningPortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE CleaningPortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress,',','.'), 2)


 ALTER TABLE CleaningPortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE CleaningPortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

SELECT *
FROM CleaningPortfolioProject.dbo.NashvilleHousing

/* Change Y and N to Yes and No in "Sold as Vacant" field */

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM CleaningPortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
FROM CleaningPortfolioProject.dbo.NashvilleHousing

UPDATE CleaningPortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END

 --Remove Duplicates

 WITH RowNumCTE AS(
 SELECT *
 ,ROW_NUMBER () OVER(
 PARTITION BY ParcelID,
              PropertyAddress,
              SalePrice,
              SaleDate,
             LegalReference
			 ORDER BY 
			 UniqueID
			 )ROW_NUM
 FROM CleaningPortfolioProject.dbo.NashvilleHousing
 )
 SELECT *
 FROM RowNumCTE
 WHERE ROW_NUM  > 1
 --ORDER BY PropertyAddress



 --Delete Unused Columns

 SELECT *
 FROM CleaningPortfolioProject.dbo.NashvilleHousing

 ALTER TABLE CleaningPortfolioProject.dbo.NashvilleHousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

 
 ALTER TABLE CleaningPortfolioProject.dbo.NashvilleHousing
 DROP COLUMN SaleDate











  
