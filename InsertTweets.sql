CREATE PROCEDURE [dbo].[InsertTweet]
(@Date DATETIME
           ,@UserName NVARCHAR(20)
           ,@Tweet NVARCHAR(MAX)
           ,@UserLocation NVARCHAR(50)
           ,@Sentiment NVARCHAR(20)
           ,@__PowerAppsId__ NVARCHAR(50)
		   )
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO [dbo].[Tweets]
           ([Date]
           ,[UserName]
           ,[Tweet]
           ,[UserLocation]
           ,[Sentiment]
           ,[__PowerAppsId__])
     VALUES
           (@Date
		   ,@UserName
		   ,@Tweet
		   ,@UserLocation
		   ,CAST(@Sentiment AS DECIMAL(5, 4))
		   ,@__PowerAppsId__)

END;