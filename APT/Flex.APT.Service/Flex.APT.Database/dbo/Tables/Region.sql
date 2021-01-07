CREATE TABLE [dbo].[Region] (
    [RegionId]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [RegionName]   NVARCHAR (100) NOT NULL,
    [RecordStatus] CHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([RegionId] ASC)
);

