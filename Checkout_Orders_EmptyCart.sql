USE [C76_Recycle]
GO
/****** Object:  StoredProcedure [dbo].[Checkout_Orders_EmptyCart]    Script Date: 9/8/2019 5:11:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[Checkout_Orders_EmptyCart]
		@CreatedBy INT

AS 

/*------TEST CODE ------

select * from dbo.Orders

*/


BEGIN
	SET XACT_ABORT ON
	DECLARE @Tran NVARCHAR(50) = 'shoppingCart'

	BEGIN TRY
		BEGIN TRANSACTION @Tran		

			UPDATE dbo.[Orders]
			SET 
			[IsVoided] = 1
			,[DateModified] = GETUTCDATE()

			WHERE  CreatedBy = @CreatedBy

			--select * from dbo.ShoppingCart
			--select * from dbo.Inventory

			UPDATE [dbo].[Inventory]
			   SET
				    [Quantity] = sc.Quantity +  ( select i.Quantity from dbo.Inventory as i where i.Id = sc.InventoryId and CreatedBy = @CreatedBy )
					From dbo.ShoppingCart as sc
					inner join  dbo.Inventory as i on 
					sc.InventoryId = i.Id
					Where sc.CreatedBy = @CreatedBy


			DELETE from 
			  [dbo].[ShoppingCart]
			WHERE CreatedBy = @CreatedBy

		COMMIT TRANSACTION @Tran
	END TRY
	BEGIN CATCH

		IF (XACT_STATE()) = -1  
		BEGIN  
			PRINT 'The transaction is in an uncommittable state.' +  
				  ' Rolling back transaction.'  
			ROLLBACK TRANSACTION @Tran;;  
		END;  
  
		IF (XACT_STATE()) = 1  
		BEGIN  
			PRINT 'The transaction is committable.' +   
				  ' Committing transaction.'  
			COMMIT TRANSACTION @Tran;;     
		END; 

		THROW

	END CATCH

END


