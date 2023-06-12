/*
Cleaning Data in SQL Queries
*/


-- Populate Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    On a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    On a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]


-- Breaking out Address into Individual Colimns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)- 1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(50);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)- 1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity NVARCHAR(50);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3) as Address,
PARSENAME(REPLACE(OwnerAddress, ',','.'),2) as City,
PARSENAME(REPLACE(OwnerAddress, ',','.'),1) as State
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(50);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(50);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState NVARCHAR(50);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)


-- Change Y and N to Yes and No in "SoldasVacant" Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant, 
CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
     END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
     END


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
    ROW_NUMBER() Over(
    PARTITION BY ParcelID,
                 PropertyAddress,
                 SalePrice,
                 SaleDate,
                 LegalReference
                 ORDER BY
                    UniqueID
                     ) row_num

From PortfolioProject.dbo.NashvilleHousing
)

DELETE
From RowNumCTE
Where row_num > 1


-- Delete Unused Columns

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress