-- CLEANING DATA IN SQL QUERIES 

 SELECT * from PortfolioProject.dbo.NashvilleHousing


-- ---------------------------------------------------------

--   FORMAT DATE 

--  SELECT SaleDate, CONVERT(date,SaleDate)
--  from PortfolioProject.dbo.NashvilleHousing

-- UPDATE .DBO.NASHVILLEHOUSING
-- SET SaleDate = CONVERT(Date,SaleDate)


-- ---------------------------------------------------------

-- POPLUATE PROPERTY ADDRESS DATA

SELECT * 
FROM PortfolioProject.DBO.NASHVILLEHOUSING
-- WHERE PROPERTYADDRESS IS NULL
ORDER BY PARCELID ASC

SELECT A.PARCELID, A.PROPERTYADDRESS, B.PARCELID, B.PROPERTYADDRESS, ISNULL(A.PROPERTYADDRESS,B.PROPERTYADDRESS)
FROM PortfolioProject.DBO.NASHVILLEHOUSING A
JOIN PortfolioProject.DBO.NASHVILLEHOUSING B 
    ON A.PARCELID = B.PARCELID 
    AND A.UNIQUEID <> B.UNIQUEID 
WHERE A.PROPERTYADDRESS IS NULL

-- UPDATE A 
-- SET PROPERTYADDRESS = ISNULL(A.PROPERTYADDRESS,B.PROPERTYADDRESS)
-- FROM PortfolioProject.DBO.NASHVILLEHOUSING A
-- JOIN PortfolioProject.DBO.NASHVILLEHOUSING B 
--     ON A.PARCELID = B.PARCELID 
--     AND A.UNIQUEID <> B.UNIQUEID 
-- WHERE A.PROPERTYADDRESS IS NULL


-- ------------------------------------------------------------------------------------------
-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

SELECT PROPERTYADDRESS
FROM PortfolioProject.DBO.NASHVILLEHOUSING
-- WHERE PROPERTYADDRESS IS NULL
-- ORDER BY PARCELID ASC

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,

SUBSTRING(PROPERTYADDRESS,CHARINDEX(',', PropertyAddress) +1, LEN(PROPERTYADDRESS)) AS CITY 

-- - (CHARINDEX(',' , PropertyAddress))) AS CITY

FROM PortfolioProject.DBO.NASHVILLEHOUSING


ALTER TABLE NashvilleHousing
add PASplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PASplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

ALTER TABLE NashvilleHousing
add PASplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PASplitCity = SUBSTRING(PROPERTYADDRESS,CHARINDEX(',',PropertyAddress) +1, LEN(PROPERTYADDRESS))

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing


SELECT Owneraddress
FROM PortfolioProject.dbo.NashvilleHousing

 SELECT 
 PARSENAME(REPLACE(OwnerAddress,',' , '.'), 3) AS OWNERSplitAddress,
 PARSENAME(REPLACE(OwnerAddress,',' , '.'), 2) AS OWNERSplitCity,
 PARSENAME(REPLACE(OwnerAddress,',' , '.'), 1) AS OWNERSplitState
 FROM PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
add OWNERSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OWNERSplitAddress = PARSENAME(REPLACE(OwnerAddress,',' , '.'), 3)


ALTER TABLE NashvilleHousing
add OWNERSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OWNERSplitCity = PARSENAME(REPLACE(OwnerAddress,',' , '.'), 2)


ALTER TABLE NashvilleHousing
add OWNERSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OWNERSplitState = PARSENAME(REPLACE(OwnerAddress,',' , '.'), 1)

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "SOld as Vacant" field

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) as CountSoldAsVacant
FROM PortfolioProject.dbo.NashvilleHousing
GROUP by SoldAsVacant
order by 2

SELECT SoldasVacant,
 CASE When SoldasVacant = 'Y' THEN 'Yes'
      When SoldasVacant = 'N' THEN 'No'
      ELSE SoldasVacant 
      END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldasVacant =  CASE When SoldasVacant = 'Y' THEN 'Yes'
                         When SoldasVacant = 'N' THEN 'No'
                         ELSE SoldasVacant 
                         END




-- ------------------------------------------------------------------------------------------
-- Remove Duplicate (For this dataset)

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing


WITH CTE_Duplicates AS (
        SELECT * ,
     row_number() OVER(PARTITION by ParcelID,
                    PropertyAddress,
                    SalePrice,
                    SaleDate,
                    LegalReference
                    ORDER BY
                        UNIQUEID ) as RowNum
FROM PortfolioProject.dbo.NashvilleHousing
)

-- Delete
FROM CTE_Duplicates
WHERE RowNum > 1 
-- ORDER by propertyAddress

SELECT *
FROM CTE_Duplicates
WHERE RowNum > 1


-------------------------------------------------------------------------------------
-- DELETE UNUSED COLUMNS FOR VIEWS ONLY  DEPENDING ON PROJECT - NOT FOR RAW DATA 

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress






