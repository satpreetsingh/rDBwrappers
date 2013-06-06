rDBwrappers
=========

**rDBwrappers** are rudimentary wrapper-functions for performing SELECT queries using standard CLI database clients: hive (for Apache Hive) and psql (for Postgres)


**Usage:**
Source the latest version of rDBwrappers in your R-code as follows:
`source("https://github.com/satpreetsingh/rDBwrappers/raw/master/RdbWrappers.R") # Source from a URL or from a locally downloaded version
`

**Notes**
* The following instructions are for using the functions on R on clients where the hive & psql clients are already installed. In any other situation, create aliases OR install local hive & psql clients as required.
* Functions return data.frames with properly named column-names for psqlGetQuery(). For hiveGetQuery(), names need to be manually added as Hive does not return such metadata 
* Post-processing is required to set the correct data-type for the returned data.frame's columns. rDBwrappers uses R's read.table() function which identifies integer & numeric types automatically. Everything else is a string (ie. stored as a factor)

Hive: hiveGetQuery()
---

*Sample Query*
* Create query statement & execute  
    `q = "SELECT column_name1,column_name2 FROM table_name LIMIT 10"`  
    `df = hiveGetQuery(q) #Executes query using CLI hive command`  

*Post-processing example*
* Set names for the data.frame columns   
    `q = "describe table_name"`  
    `ndf = hiveGetQuery(q)[,1]`  
    `ndf = ndf[1:length(ndf)-1]`  
    `names(df) <- ndf`  

* Set column classes where required  
    `df$search_date = as.Date(df$search_date) #So on...`  

Postgres: psqlGetQuery()
---

Before you can use the psqlGetQuery() function, you need to [setup your pgpass file](http://wiki.postgresql.org/wiki/Pgpass). Don't forget to chmod 0600 it. Note how doing this means that your code will not contain your password (doing otherwise would be a very poor scripting practice)

*Sample Query*  
* Setup DB connection parameters, create query statement & execute  
 `dbname="my_database`  
 `host="db.mydatabase.com`  
 `username="bob"`  

 `query="SELECT column_name1,column_name2 FROM table_name LIMIT 10"`  
 `df = psqlGetQuery(query, dbname, host, username) #executes query using psql command`  

*Post-processing example*  
* Set column classes where required  
 `df$date_column = as.Date(df$date_column) #So on...`  

Addendum
---

*Alternative example Using RJDBC (only Postgres, not Hive)*

[RJDBC Homepage](http://www.rforge.net/RJDBC/)  

*Example code*  
 `install.packages("RJDBC", repos="http://cran.r-project.org", dep=TRUE) #Install required packages`    
 `library(RJDBC)`     
 ```drv <- JDBC("org.postgresql.Driver", "/Users/ssingh/jdbc/postgresql-8.1-407.jdbc3.jar", identifier.quote="`") #Instatiate driver```    
 `conn <- dbConnect(drv, "jdbc:postgresql://db.mydatabase.com/databasename", "username", "pwd") #make connection```  

 `dbListTables(conn) #list tables`    
 `sql = "SELECT * FROM mytable WHERE date >= '2011-04-01';" #create query statement`    
 `rs = dbGetQuery(conn, sql) #get ResultSet as a data.frame`  

As with installing other R libraries, the R library folder must be writable by your user-id (that's executing it).  On a Linux-based system it will most likely be `/usr/lib/R/library/`.  

