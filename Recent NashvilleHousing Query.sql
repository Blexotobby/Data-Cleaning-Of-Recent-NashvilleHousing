-- Data Cleaning

SELECT *
FROM PortfolioProjectt2..NashvilleHousing

--using apporiprate Date Format
SELECT SaleDate
FROM PortfolioProjectt2..NashvilleHousing

SELECT CAST(SaleDate AS date) 
FROM PortfolioProjectt2..NashvilleHousing

ALTER TABLE PortfolioProjectt2..NashvilleHousing
ADD SaleDateConverted date;

Update PortfolioProjectt2..NashvilleHousing
SET SaleDateConverted=CAST(SaleDate AS date)

--Populating The PropertyAddress
SELECT PropertyAddress
FROM PortfolioProjectt2..NashvilleHousing
WHERE PropertyAddress IS NULL


SELECT *
FROM PortfolioProjectt2..NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.UniqueID,a.ParcelID,a.PropertyAddress,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProjectt2..NashvilleHousing a
JOIN PortfolioProjectt2..NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	 AND a.UniqueID <> B.UniqueID
	 WHERE a.PropertyAddress IS NULL

	 UPDATE a
	 SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
	 FROM PortfolioProjectt2..NashvilleHousing a
JOIN PortfolioProjectt2..NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	 AND a.UniqueID <> B.UniqueID
	 WHERE a.PropertyAddress IS NULL

	 SELECT PropertyAddress
	 FROM PortfolioProjectt2..NashvilleHousing

	 -- BReaking Property Address Into City AND STATE

	 SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS PropertySplitAddress,
	 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEn(PropertyAddress)) AS PropertySplitCity
	FROM PortfolioProjectt2..NashvilleHousing

	ALTER TABLE NashvilleHousing
	ADD PropertySplitAddress nvarchar(255)

	UPDATE NashvilleHousing
	SET PropertySplitAddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

	ALTER TABLE NashvilleHousing
	ADD PropertySplitCity nvarchar(255)

	UPDATE NashvilleHousing
	SET PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEn(PropertyAddress))

	SELECT *
	FROM PortfolioProjectt2..NashvilleHousing

	
	--BReaking Owner Address into Adresss, city and State
	
	SELECT OwnerAddress
	FROM PortfolioProjectt2..NashvilleHousing

	SELECT
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
	FROM PortfolioProjectt2..NashvilleHousing

	ALTER TABLE NashvilleHousing
	ADD SplictOwnerAddress nvarchar(255);

	Update NashvilleHousing
	SET SplictOwnerAddress=PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

	ALTER TABLE NashvilleHousing
	ADD SplictOwnerCity nvarchar(255);

	UPDATE NashvilleHousing
	SET SplictOwnerCity=PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

	ALTER TABLE NashvilleHousing
	ADD SplictOwnerState nvarchar(255);

	Update NashvilleHousing
	SET SplictOwnerState=PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

	SELECT *
	FROM PortfolioProjectt2..NashvilleHousing

	--Change Y,N To YES AND NO In soldASVacant
	
SELECT SoldAsVacant,COUNT(SoldAsVacant) 
FROM PortfolioProjectt2..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant='Y' THEN 'YES'
	WHEN SoldAsVacant='N' THEN 'NO'
	ELSE SoldAsVacant
	END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant=CASE WHEN SoldAsVacant='Y' THEN 'YES'
	WHEN SoldAsVacant='N' THEN 'NO'
	ELSE SoldAsVacant
	END
FROM NashvilleHousing

--REMOVING DuPLIcates
	WITH CTE_ROWNUM AS (SELECT *, ROW_NUMBER() OVER (
						PARTITION BY ParcelID,
									PropertyAddress,
									SalePrice,
									SaleDate,
									LegalReference
									ORDER BY UniqueID
	)ROW_NUM
	FROM PortfolioProjectt2..NashvilleHousing
	--ORDER BY [UniqueID ]
	)
	SELECT *
	FROm CTE_ROWNUM

	-- DELECTING DUPLICATES
	WITH CTE_ROWNUM AS (SELECT *, ROW_NUMBER() OVER (
						PARTITION BY ParcelID,
									PropertyAddress,
									SalePrice,
									SaleDate,
									LegalReference
									ORDER BY UniqueID
	)ROW_NUM
	FROM PortfolioProjectt2..NashvilleHousing
	--ORDER BY [UniqueID ]
	)
	DELETE
	FROm CTE_ROWNUM
	WHERE ROW_NUM >1

	-- DELETING UNUSED COLUMN
	ALTER TABLE NashvilleHousing
	DROP  COLUMN OwnerAddress,TaxDistrict, PropertyAddress,SaleDate

	
	-- ALL COLUMNS OF CLEANED DATA
	SELECT *
	FROM NashvilleHousing