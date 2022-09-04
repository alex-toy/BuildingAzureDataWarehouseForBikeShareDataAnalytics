--############################################################################
--Create dim_payment tableBEGIN 
BEGIN 
    DROP TABLE fact_payment
END
GO;

CREATE TABLE fact_payment (
	[payment_id] [bigint]  NULL,
	[amount] [float]  NULL,
	[rider_id] [bigint]  NULL,
	[time_id] [uniqueidentifier]  NULL
)
GO;

INSERT INTO fact_payment (
	[payment_id],
	[amount],
	[rider_id] ,
	[time_id])
SELECT
    [payment_id],
    [staging_payments].[amount],
    [staging_payments].[rider_id],
    [dim_time].[time_id]
FROM [dbo].[staging_payments]
JOIN dim_time ON dim_time._date = staging_payments._date

GO;

SELECT TOP (100) * FROM [dbo].[fact_payment]
--############################################################################