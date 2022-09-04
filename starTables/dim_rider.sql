--############################################################################
-- Create Rider table
BEGIN 
    DROP TABLE dim_rider
END
GO;

CREATE TABLE dim_rider (
	[rider_id] [bigint]  NULL,
	[firstName] [nvarchar](4000)  NULL,
	[lastName] [nvarchar](4000)  NULL,
	[_address] [nvarchar](4000)  NULL,
	[birthday] [varchar](50)  NULL,
	[account_start_date] [varchar](50)  NULL,
	[account_end_date] [varchar](50)  NULL,
	[is_member] [bit]  NULL
)
GO;

INSERT INTO dim_rider (
    [rider_id]
    ,[firstName]
    ,[lastName]
    ,[_address]
    ,[birthday]
    ,[account_start_date]
    ,[account_end_date]
    ,[is_member])
SELECT 
    [rider_id]
    ,[firstName]
    ,[lastName]
    ,[_address]
    ,[birthday]
    ,[account_start_date]
    ,[account_end_date]
    ,[is_member]
FROM staging_riders

GO;

SELECT TOP (100) * FROM [dbo].[dim_rider]
--############################################################################