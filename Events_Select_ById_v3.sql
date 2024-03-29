USE [C76_Recycle]
GO
/****** Object:  StoredProcedure [dbo].[Events_Select_ById_v3]    Script Date: 9/8/2019 5:13:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[Events_Select_ById_v3]
				@Id INT

AS

/*

	DECLARE @Id INT = 15

	EXECUTE dbo.Events_Select_ById_v3
			@Id

*/


BEGIN

	SELECT	e.[Id]
			,t.[Id] as EventTypeId
			,t.[Name] AS EventTypeName
			,e.[Name]
			,e.[Summary]
			,e.[ShortDescription]
			,v.[Id] as VenueId
			,v.[Name]  as VenueName
			,l.[Id] as LocationId
			,l.[LineOne]
			,l.[City]
			,l.[Zip]
			,l.[Latitude]
			,l.[Longitude]
			,s.[Id] as EventStatusId
			,s.[Name] as EventStatusName
			,e.[ImageUrl]
			,e.[ExternalSiteUrl]
			,e.[IsFree]
			,e.[DateCreated]
			,e.[DateModified]
			,e.[DateStart]
			,e.[DateEnd]
			,e.[CreatedBy]
			,e.[ModifiedBy]
			,[TotalCount] = COUNT(1) OVER()


		
	FROM [dbo].[Events] AS e

	INNER JOIN dbo.EventTypes AS t
		ON t.[Id] = e.[EventTypeId]

	INNER JOIN dbo.Venues AS v
		ON v.[Id] = e.[VenueId]

	INNER JOIN dbo.EventStatus AS s
		ON s.[Id] = e.[EventStatusId]

	INNER JOIN dbo.Locations AS l
		ON l.[Id] = v.[LocationId]

	WHERE e.Id = @Id

END