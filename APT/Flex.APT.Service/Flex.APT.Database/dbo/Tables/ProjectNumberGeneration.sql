CREATE TABLE [dbo].[ProjectNumberGeneration] (
    [ProjectNumberGenerationId] BIGINT IDENTITY (1, 1) NOT NULL,
    [RegionId]                  BIGINT NOT NULL,
    [ProjectRegionNumber]       BIGINT NOT NULL,
    PRIMARY KEY CLUSTERED ([ProjectNumberGenerationId] ASC),
    CONSTRAINT [FK_ProjectNumberGeneration_To_Region] FOREIGN KEY ([RegionId]) REFERENCES [dbo].[Region] ([RegionId])
);

