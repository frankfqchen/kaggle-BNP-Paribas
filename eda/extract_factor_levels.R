###
# this code looks at all the data to define the factor levels to
# be used in modeling
###

library(data.table)
library(plyr)

DATA.DIR <- "./data"


# get attribute data types
load(paste0(DATA.DIR,"/attr_data_types.RData"))

# get the data
load(paste0(DATA.DIR,"/train_calib_test.RData"))
test.kag <- fread(paste0(DATA.DIR,"/test.csv"))

#combine all the data to catalog all factor levels
all.data <- rbind.fill(train0.raw,train1.raw,calib.raw,test.raw,test.kag)

#determine levels for each factor attribute
factor.levels <- lapply(attr.data.types$character,function(x){
    unique.values <- unique(all.data[[x]])
    unique.values <- unique.values[order(unique.values)]
    return(unique.values)
})

names(factor.levels) <- attr.data.types$character
comment(factor.levels) <- "defines factor levels for categorical attributes"

#determine dummy variables
dummy.vars <- lapply(attr.data.types$character,function(x){
    df <- data.frame(all.data[,x])
    names(df) <- x
    dummy.effect <- dummyVars(~.,data=df)
    return(dummy.effect)
})

names(dummy.vars) <- attr.data.types$character
comment(dummy.vars) <- "dummy var specification"

save(factor.levels,dummy.vars,file=paste0(DATA.DIR,"/factor_levels.RData"))
