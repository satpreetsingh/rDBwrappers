#Identifies integer & numeric types automatically; Everything else is a string (ie. stored as a factor)

hiveGetQuery <- function(query) {
    tmpfn = tempfile("hive")
    cmd = sprintf("hive -e \"%s\" > %s ", query, tmpfn)
    system(cmd, intern=TRUE)
    df = read.table(tmpfn, sep='\t', header=FALSE, na.strings=c("null", "NaN"), fill=TRUE)
    file.remove(tmpfn)
    return(df[,1:ncol(df)-1]) #remove extra tab at end
}


psqlGetQuery  <- function(query, dbname, host, username) {
    tmpfn = tempfile("psql")
    cmd = sprintf("psql -h %s -U %s -d %s -q -A -F',' -c \"%s\" -o %s ", host, username, dbname, query, tmpfn)
    system(cmd, intern=TRUE)
    df = read.csv(tmpfn, header=TRUE, na.strings=c("null", "NaN"), fill=TRUE)
    file.remove(tmpfn)
    return(df[1:nrow(df)-1,]) #remove psql footer
}

