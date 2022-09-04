--############################################################################
--Create dim_time table
BEGIN 
    DROP TABLE dim_time
END
GO;

CREATE TABLE dim_time (
	[time_id] [uniqueidentifier] NOT NULL,
	[_date] [varchar](50)  NULL,
	[_month] [varchar](50)  NULL,
	--[_quarter] [varchar](50)  NULL,
	[_year] [varchar](50)  NULL
)
GO;

ALTER TABLE dim_time add CONSTRAINT PK_dim_time_time_id PRIMARY KEY NONCLUSTERED (time_id) NOT ENFORCED

INSERT INTO dim_time (
	[time_id],
	[_date],
	[_month],
	--[_quarter],
	[_year])
SELECT 
	NEWID(),
    _date,
    MONTH(_date) AS _month,
    YEAR(_date) AS _year
FROM staging_payments

UNION 

SELECT 
	NEWID(),
    start_at,
    MONTH(start_at) AS _month,
    YEAR(start_at) AS _year
FROM staging_trips

UNION 

SELECT 
	NEWID(),
    ended_at,
    MONTH(ended_at) AS _month,
    YEAR(ended_at) AS _year
FROM staging_trips 

SELECT TOP (100) * FROM [dbo].[dim_time]
--############################################################################