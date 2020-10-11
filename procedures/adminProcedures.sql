---------------------------------------------------------
------procedure to login admin -----------------------
CREATE PROCEDURE dbo.spLoginAdmin
@username varchar(100),
@password varchar(100)
AS
BEGIN
	DECLARE @adminId int;
	DECLARE @password_hash NVARCHAR(500) = HASHBYTES('MD5', @password);

	SELECT @adminId = id FROM adminTable
	WHERE 
		username = @username
	AND 
		password = @password_hash;
	
	IF (@adminId > 0)
		BEGIN 
			-- neither email nor password matches
			SELECT 'email_password_matched' as message, 'FALSE' as 'error';
		END
	ELSE 
	BEGIN 
		-- neither email nor password matches
		SELECT 'email_password_mismatch' as message, 'TRUE' as 'error';
	END
END

GO;

-------------------------------------------------------------
-------------Update fcmToken---------------------------------
CREATE PROCEDURE dbo.spUpdateAdminToken
@adminId int,
@fcmToken NVARCHAR(255)
AS
BEGIN
	Update adminTable
	SET
		fcmToken = @fcmToken
	WHERE
		id = @adminId
END