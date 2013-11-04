# sample workflow to help work out staticreader functions

library(staticreader)
runConfig()
currURL <- getSavedURL(ctx, gistID)

oxfordU <- grep(".*oxfordjournals.*", currURL)

currURL[oxfordU] <- sapply(currURL[oxfordU], modURL_oxfordJ)

currTitles <- sapply(currURL, getTitle)
names(currTitles) <- NULL

bmcJ <- c("^BMC Bioinformatics", "^BioData Mining")
bmcIndex <- unlist(sapply(bmcJ, grep, currTitles), use.names=F)

elife <- c("eLife$")
elifeIndex <- grep(elife, currTitles)


modTitle_bmc <- function(inTitle){
  splitTitle <- strsplit(inTitle, " | ", fixed=T)[[1]]
  return(splitTitle[3])
}


modTitle_elife <- function(inTitle){
  splitTitle <- strsplit(inTitle, " | ", fixed=T)[[1]]
  return(splitTitle[1])
}

removeNewLines <- function(inTitle){
  splitNew <- strsplit(inTitle, "\n", fixed=T)[[1]]
  return(paste(splitNew, collapse=" "))
}

currTitles[bmcIndex] <- sapply(currTitles[bmcIndex], modTitle_bmc, USE.NAMES=F)

currTitles[elifeIndex] <- sapply(currTitles[elifeIndex], modTitle_elife, USE.NAMES=F)

currTitles <- sapply(currTitles, removeNewLines, USE.NAMES=F)

errorStr <- c("^Error : XML content does not seem to be XML", "^Error : failed to load HTTP resource")

hasErrors <- unique(unlist(lapply(errorStr, grep, currTitles, invert=F), use.names=F))

currTitles <- currTitles[-hasErrors]
currURL <- currURL[-hasErrors]
