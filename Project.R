####Step 1 Creation for Directory

dirHome="C:/Users/akhil/Desktop/R/coursera/Data_Cleaning/"
folder="Project"

dir=paste(dirHome,folder,sep="")
if(!dir.exists(dir)){dir.create(dir)}

#### Step 2 Downloading Data and unzipping
url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName="phone.zip"
file=paste(dir,"/",fileName,sep="")
download.file(url,file,mode="wb")
unzip(file,exdir=dir)
##help page https://stat.ethz.ch/R-manual/R-devel/library/utils/html/unzip.html

####Step 3 Reading Data

dirData=paste0(dir,"/","UCI HAR Dataset","/")
features=read.table(paste0(dirData,"features.txt"))
lables=read.table(paste0(dirData,"activity_labels.txt"))

##Train Data
#reading
dirTrain=paste0(dir,"/","UCI HAR Dataset","/","train","/")

fileTrainLables=paste0(dirTrain,"y_train.txt")
lablesTrain=read.table(fileTrainLables)

fileTrainData=paste0(dirTrain,"X_train.txt")
dataTrain=read.table(fileTrainData)

fileTrainsub=paste0(dirTrain,"subject_train.txt")
subTrain=read.table(fileTrainsub)

#adding variables
names(dataTrain)=features[,2]
dataTrain[,"subject"]=subTrain
dataTrain[,"activity"]=lablesTrain
dataTrain[,"activityName"]=factor(dataTrain$activity,labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))


##Test Data
#reading
dirTest=paste0(dir,"/","UCI HAR Dataset","/","test","/")

fileTestLables=paste0(dirTest,"y_test.txt")
lablesTest=read.table(fileTestLables)

fileTestData=paste0(dirTest,"X_test.txt")
dataTest=read.table(fileTestData)

fileTestsub=paste0(dirTest,"subject_test.txt")
subTest=read.table(fileTestsub)

#adding variables
names(dataTest)=features[,2]
dataTest[,"subject"]=subTest
dataTest[,"activity"]=lablesTest
dataTest[,"activityName"]=factor(dataTest$activity,labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))


#### Step 4 Tidying and combining data
##combine data
dataAll=rbind(dataTrain,dataTest)

##subsetting data for mean and standard deviation
A=grep("(\\bmean\\b|\\bstd()\\b)",names(dataAll),value=TRUE)
#grep("(\\<mean\\>|\\<std()\\>)",names(dataAll),value=TRUE) # will also work

dataAll_M_S=dataAll[,c(A,"subject","activity","activityName")]

#for help
#https://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html

##Summarising data by fun=mean

#summarise_each(group_by(dataAll_M_S,subject,activity),mean)

Summary=dataAll_M_S%>%group_by(subject,activity,activityName)%>%summarise_each(funs(mean))%>%as.data.frame()

##Writing Tidy Datasets
dir="C:/Users/akhil/Desktop/R/coursera/Data_Cleaning/Project/Solution/"
fileName1="dataTidy_full.csv"
file1=paste0(dir,fileName1)
write.csv(dataAll,file1,append=FALSE,row.names=FALSE)
write.table(dataAll,paste0(dir,"dataTidy_full.txt"),row.names=FALSE)

fileName2="dataTidy_Summ.csv"
file2=paste0(dir,fileName2)
write.csv(Summary,file2,append=FALSE,row.names=FALSE)
