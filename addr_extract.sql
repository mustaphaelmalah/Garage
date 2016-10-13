declare @Addr varchar(100) = '572 Mountain Rd'
declare @StreetNo varchar(20)
declare @Street varchar(50)

-- Address variations
--set @Addr = 'Mountain Rd 572'
--set @Addr = 'Mountain 572 Rd'

set @StreetNo = case 
		when @Addr is null then null
		when patindex('%[1-9]%', @Addr) = 1 then substring(@Addr, 1, charindex(' ', @Addr)) 
		when patindex('%[1-9]%', @Addr) > 1 then substring(@Addr, patindex('%[1-9]%', @Addr), (case when charindex(' ', @Addr, patindex('%[1-9]%', @Addr)) = 0 then len(@Addr) else charindex(' ', @Addr, patindex('%[1-9]%', @Addr)) - patindex('%[1-9]%', @Addr) end)) 
		else ''
	end

set @Street = case 
		when patindex('%[1-9]%', @Addr) = 1 then substring(@Addr, charindex(' ', @Addr), len(@Addr))
		when patindex('%[1-9]%', @Addr) > 1 then substring(@Addr, 1, patindex('%[1-9]%', @Addr) - 1) + (case when charindex(' ', @Addr, patindex('%[1-9]%', @Addr)) = 0 then '' else substring(@Addr, charindex(' ', @Addr, patindex('%[1-9]%', @Addr)), len(@Addr)) end)
		else @Addr
	end
 
select @StreetNo
select @Street

 SELECT  top 100 parcel.PARCELID, parcel.PARCELNUMBER, parceladdress.ADDRESSLINE1, 
 (case 
		when parceladdress.ADDRESSLINE1 is null then null
		when patindex('%[1-9]%', parceladdress.ADDRESSLINE1) = 1 then rtrim(substring(parceladdress.ADDRESSLINE1, 1, charindex(' ', parceladdress.ADDRESSLINE1)))
		when patindex('%[1-9]%', parceladdress.ADDRESSLINE1) > 1 then rtrim(substring(parceladdress.ADDRESSLINE1, patindex('%[1-9]%', parceladdress.ADDRESSLINE1), len(parceladdress.ADDRESSLINE1)))
		else ''
	end) as StreetNo,
 (case 
		when parceladdress.ADDRESSLINE1 is null then null
		when patindex('%[1-9]%', parceladdress.ADDRESSLINE1) = 1 then ltrim(substring(parceladdress.ADDRESSLINE1, charindex(' ', parceladdress.ADDRESSLINE1), len(parceladdress.ADDRESSLINE1) - 1))
		when patindex('%[1-9]%', parceladdress.ADDRESSLINE1) > 1 then rtrim(substring(parceladdress.ADDRESSLINE1, 1, patindex('%[1-9]%', parceladdress.ADDRESSLINE1) - 1))
		else parceladdress.ADDRESSLINE1
	end) as StreetAddr
FROM [EnerGov].[dbo].[PARCEL]
left join [EnerGov].[dbo].[PARCELADDRESS] on PARCEL.PARCELID=parceladdress.PARCELID