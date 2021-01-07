CREATE TABLE [dbo].[Country] (
    [CountryId]    BIGINT         IDENTITY (1, 1) NOT NULL,
    [CountryName]  NVARCHAR (100) NOT NULL,
    [CountryCode]  NVARCHAR (10)  NULL,
    [RecordStatus] CHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([CountryId] ASC)
);

