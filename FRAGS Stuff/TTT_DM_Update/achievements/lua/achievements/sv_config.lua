local config = achievements.Config

--- Data Provider
-- Tells the script where and how to save data.
-- Default providers: SQLLite, MySQL

config["DataProvider"] = "SQLLite"
config["DataProviderSettings"] = {
	TablePrefix = "achv_"
}

-- MySQL Configuration
--config["DataProvider"] = "MySQL"
--config["DataProviderSettings"] = {
--	TablePrefix = "achv_",
--    Host   = "localhost",
--    User   = "root",
--    Pass   = "pass",
--    DBName = "test",
--    Port   = 3306
--}