CREATE TABLE [dbo].[Site] (
    [SiteId]       BIGINT         IDENTITY (1, 1) NOT NULL,
    [RegionId]     BIGINT         NOT NULL,
    [SiteName]     NVARCHAR (100) NOT NULL,
    [SiteCode]     NVARCHAR (10)  NULL,
    [RecordStatus] CHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([SiteId] ASC),
    CONSTRAINT [FK_Site_To_Region] FOREIGN KEY ([RegionId]) REFERENCES [dbo].[Region] ([RegionId])
);

