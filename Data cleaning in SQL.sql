--Standardize date format

SELECT SaleDateConverted, CONVERT(date, SaleDate) 
FROM sql..NashvilleHousing

UPDATE sql..NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate) 

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE sql..NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)



--Populate property address data
SELECT *
FROM sql..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM sql..NashvilleHousing a
join sql..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.uniqueID <> b.uniqueID
where a.PropertyAddress is null

UPDATE a
SET a.propertyaddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM sql..NashvilleHousing a
join sql..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.uniqueID <> b.uniqueID
where a.PropertyAddress is null

--Breaking out Address into individual columns (Address, City, State)
SELECT propertyaddress, OwnerAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
		SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))  AS City,
		SUBSTRING(OwnerAddress, LEN(OwnerAddress)-1, 2)  AS State
FROM sql..NashvilleHousing 


ALTER TABLE sql..NashvilleHousing
ADD Address Nvarchar(255);

UPDATE sql..NashvilleHousing
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE sql..NashvilleHousing
ADD City Nvarchar(255);

UPDATE sql..NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

ALTER TABLE sql..NashvilleHousing
ADD State Nvarchar(255);

UPDATE sql..NashvilleHousing
SET State = SUBSTRING(OwnerAddress, LEN(OwnerAddress)-1, 2)

--Change Y and N to Yes and No in 'Sold as Vacant' field

SELECT SoldAsVacant
CASE WHEN SoldAsVacant = 'N' THEN 'No'
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	ELSE SoldAsVacant END AS SoldAsVacantCorrected
FROM sql..NashvilleHousing


UPDATE sql..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'N' THEN 'No'
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	ELSE SoldAsVacant END 


--Remove Duplicate


--Delete unused column
Select*
FROM sql..NashvilleHousing

Alter table sql..NashvilleHousing
Drop column PropertyAddress, OwnerAddress