#Introduction to R 
#Introduction to R 
# Read the data
Data <- read.table(file="C:/Users/singh/Desktop/midterm/Part2/historical_data1_Q12005.txt", header=FALSE, sep="|") 
test<-read.table(file = "C:/Users/singh/Desktop/midterm/Part2/historical_data1_Q22005.txt", header=FALSE, sep="|")

origclass <- c('numeric','numeric','character', 'numeric', 'numeric', 'numeric', 'numeric',  
                'character','numeric','numeric','numeric','numeric','numeric','character',
                'character','character','character', 'character','character','numeric','character',
                'numeric', 'numeric','character','character','character') 
#origfile_Qnyyyy <- read.table("historical_data1_Qnyyyy.txt", sep="|", header=FALSE, colClasses=origclass ) 
Data <- read.table(file="C:/Users/singh/Desktop/midterm/Part2/historical_data1_Q12005.txt", header=FALSE, sep="|",
                     colClasses=origclass) 
test<-read.table(file="C:/Users/singh/Desktop/midterm/Part2/historical_data1_Q22005.txt", header=FALSE, sep="|",
                 colClasses=origclass)

#Define Columns
colnames(Data)<- c("CreditScore", "FirstPaymentDate", "FirstTimeHomebuyerFlag", "MaturityDate", "MSA", "MIpercentage", "NoOfUnits",
                     "OccupancyStatus", "CLTV", "DTIratio",
                     "UPB","LTV", "InterestRate", "Channel", "PPMflag", "ProductType", "PropertyState", 
                     "PropertyType", "PostalCode", "LoanSequenceNumber", "LoanPurpose", "LoanTerm", 
                     "NoOfBorrowers", "SellerName", "ServicerName", "Flag")
colnames(test)<- c("CreditScore", "FirstPaymentDate", "FirstTimeHomebuyerFlag", "MaturityDate", "MSA", "MIpercentage", "NoOfUnits",
                   "OccupancyStatus", "CLTV", "DTIratio",
                   "UPB","LTV", "InterestRate", "Channel", "PPMflag", "ProductType", "PropertyState", 
                   "PropertyType", "PostalCode", "LoanSequenceNumber", "LoanPurpose", "LoanTerm", 
                   "NoOfBorrowers", "SellerName", "ServicerName", "Flag")
summary(test)
MyData<-Data

head(MyData)
#names of column
MyData
names(MyData)
#as.data.frame(MyData) 
#check the dataset
#str(MyData)
summary(MyData)



#fill the missing value 
#which(is.na(column1))
test$CreditScore[which(is.na(test$CreditScore))]<-0
test$CreditScore[test$CreditScore == 0] <- mean(MyData$CreditScore)
summary(test$CreditScore)
test$FirstPaymentDate[which(is.na(test$FirstPaymentDate))]<-0

MyData$CreditScore[which(is.na(MyData$CreditScore))]<-0
MyData$CreditScore[MyData$CreditScore == 0] <- mean(MyData$CreditScore)
summary(MyData$CreditScore)
MyData$FirstPaymentDate[which(is.na(MyData$FirstPaymentDate))]<-0
test$FirstPaymentDate[which(is.na(MyData$FirstPaymentDate))]<-0
MyData$MSA[MyData$MSA == "      "] <-"NA"
MyData$MSA[which(is.na(MyData$MSA))]<-0
test$MSA[test$MSA == "      "] <-"NA"
test$MSA[which(is.na(test$MSA))]<-0

MyData$MIpercentage[which(is.na(MyData$MIpercentage))]<-0
test$MIpercentage[which(is.na(test$MIpercentage))]<-0

MyData$NoOfUnits[which(is.na(MyData$NoOfUnits))]<-0
test$NoOfUnits[which(is.na(test$NoOfUnits))]<-0
#MyData$OccupancyStatus[which(is.na(MyData$OccupancyStatus))]<-0
MyData$CLTV[which(is.na(MyData$CLTV))]<-0
test$CLTV[which(is.na(test$CLTV))]<-0
MyData$DTIratio[which(is.na(MyData$DTIratio))]<-0
test$DTIratio[which(is.na(test$DTIratio))]<-0

MyData$UPB[which(is.na(MyData$UPB))]<-0
MyData$LTV[which(is.na(MyData$LTV))]<-0
MyData$InterestRate[which(is.na(MyData$InterestRate))]<-0
test$UPB[which(is.na(test$UPB))]<-0
test$LTV[which(is.na(test$LTV))]<-0
test$InterestRate[which(is.na(test$InterestRate))]<-0
#MyData$Channel[which(is.na(MyData$Channel))]<-0
#MyData$PPMflag[which(is.na(MyData$PPMflag))]<-0
#MyData$ProductType[which(is.na(MyData$ProductType))]<-0
#MyData$PropertyState[which(is.na(MyData$PropertyState))]<-0
#MyData$PropertyType[which(is.na(MyData$PropertyType))]<-0
#MyData$PostalCode[which(is.na(MyData$PostalCode))]<-0
#MyData$LoanSequenceNumber[which(is.na(MyData$LoanSequenceNumber))]<-0
#MyData$LoanPurpose[which(is.na(MyData$LoanSequenceNumber))]<-0
MyData$LoanTerm[which(is.na(MyData$LoanTerm))]<-0
MyData$NoOfBorrowers[which(is.na(MyData$NoOfBorrowers))]<-0
test$LoanTerm[which(is.na(test$LoanTerm))]<-0
test$NoOfBorrowers[which(is.na(test$NoOfBorrowers))]<-0
#MyData$SellerName[which(is.na(MyData$SellerName))]<-0
#MyData$ServicerName[which(is.na(MyData$ServicerName))]<-0
#MyData$Flag[which(is.na(MyData$Flag))]<-0
MyData
summary(MyData)
TrainingData<-(MyData)

DF <- data.frame(TrainingData)
DFtest <- data.frame(test)
drops <- c("FirstTimeHomebuyerFlag","Flag","OccupancyStatus","Channel", "PPMflag","ProductType", "PropertyState",
           "LoanPurpose","SellerName", "ServicerName",   "PropertyType", "PostalCode")
TrainData<-DF[ , !(names(DF) %in% drops)]
test<-DFtest[ , !(names(DFtest) %in% drops)]
TrainData
test

summary(TrainData)
names(test)
names(TrainData) 

TrainData$CreditScore[TrainData$CreditScore == 0] <- mean(TrainData$CreditScore)
summary(TrainData$CreditScore)
mean(TrainData$CreditScore)
#Now Select The TRaining data
typeof(TrainData)
summary(TrainData)


#Feature Selection using linear Selection
lm.fit1=lm(TrainingData$InterestRate~TrainingData$CreditScore+TrainingData$MaturityDate+TrainingData$MIpercentage +  
           TrainingData$MSA+TrainingData$NoOfUnits+TrainingData$CLTV+TrainingData$DTIratio+TrainingData$UPB+TrainingData$LTV   
          +TrainingData$PostalCode+TrainingData$LoanTerm+TrainingData$ServicerName+TrainingData$NoOfBorrowers)
summary(lm.fit1)          
       
test$CreditScore[which(is.na(test$CreditScore))]<-0

test$CreditScore[test$CreditScore == 0] <- mean(TrainData$CreditScore)  
lm.fit2=lm(test$InterestRate~test$CreditScore+test$MaturityDate+test$MIpercentage +  
             test$MSA+test$NoOfUnits+test$CLTV+test$DTIratio+test$UPB+test$LTV   
           +test$PostalCode+test$LoanTerm+test$ServicerName+test$NoOfBorrowers)

summary(lm.fit2)
#measure the predictive Accuracy
library(forecast)
pred=predict(lm.fit,test)
accuracy(pred,TrainingData$InterestRate)


#Exhaustive Selection
install.packages("leaps")
library(leaps)
regfit.full=regsubsets(TrainingData$InterestRate~TrainingData$CreditScore+TrainingData$MaturityDate+TrainingData$MIpercentage +  
                         TrainingData$MSA+TrainingData$NoOfUnits+TrainingData$CLTV+TrainingData$DTIratio+TrainingData$UPB+TrainingData$LTV   
                       +TrainingData$PostalCode+TrainingData$LoanTerm+TrainingData$NoOfBorrowers, data=TrainingData,nvmax =11 )
reg.summary=summary(regfit.full)
reg.summary
names(reg.summary)
reg.summary$rss
reg.summary$adjr2

plot(reg.summary$adjr2, type = "line")
plot(reg.summary$rss, type = "line")


accuracy(reg.summary,TrainingData$InterestRate)



#---------------------------------------------
#Forward Selection
regfit.fwd=regsubsets(TrainingData$InterestRate~TrainingData$CreditScore+TrainingData$MaturityDate+TrainingData$MIpercentage +  
                        TrainingData$MSA+TrainingData$NoOfUnits+TrainingData$CLTV+TrainingData$DTIratio+TrainingData$UPB+TrainingData$LTV   
                      +TrainingData$PostalCode+TrainingData$LoanTerm+TrainingData$NoOfBorrowers, data=TrainingData,nvmax =11,method = "forward")


F=summary(regfit.fwd)
names(F)
F$rss
F$adjr2
coef(regfit.fwd,11)
accuracy(F,TrainingData$InterestRate)
plot(F$adjr2,type="line")

plot(F$rss, type="line")

#Backward Selection
regfit.bwd=regsubsets(TrainingData$InterestRate~TrainingData$CreditScore+TrainingData$MaturityDate+TrainingData$MIpercentage +  
                        TrainingData$MSA+TrainingData$NoOfUnits+TrainingData$CLTV+TrainingData$DTIratio+TrainingData$UPB+TrainingData$LTV   
                      +TrainingData$PostalCode+TrainingData$LoanTerm+TrainingData$NoOfBorrowers, data=TrainingData,nvmax =11,method = "backward")


B=summary(regfit.bwd)
names(B)
B$rss
B$adjr2
coef(regfit.bwd,11)
plot(B$adjr2)
plot(B$rss)


#-------------------random Fores
install.packages("neuralnet")
library(neuralnet)

ibrary (neuralnet)
neuralnet <- neuralnet(TrainingData$InterestRate~TrainingData$CreditScore+TrainingData$MaturityDate+TrainingData$MIpercentage +  
                         TrainingData$NoOfUnits+TrainingData$CLTV+TrainingData$DTIratio+
                         TrainingData$UPB+TrainingData$LoanTerm+TrainingData$NoOfBorrowers, 
                       data=TrainingData, hidden=3,  threshold = 0.01, linear.output=FALSE )

neuralnet$result.matrix
plot(neuralnet)



#----------------------
install.packages("randomForest")
library(randomForest)

TrainingData <- randomForest(TrainingData$InterestRate~TrainingData$CreditScore+TrainingData$MaturityDate+TrainingData$MIpercentage +  
                               TrainingData$MSA+TrainingData$NoOfUnits+TrainingData$CLTV+TrainingData$DTIratio+TrainingData$UPB+TrainingData$LTV   
                             +TrainingData$PostalCode+TrainingData$LoanTerm+TrainingData$NoOfBorrowers,
                             data=TrainingData,ntree=100,proximity=TRUE)
table(predict(TrainingData),TrainingData$InterestRate)
print(TrainingData)


#how Interest rate changes with combined effect of MI percentage & Credit Score
#coplot(TrainingData$InterestRate~ TrainingData$CreditScore|TrainingData$MIpercentage, panel = panel.smooth)



#Model1=lm.fit(TrainingData$InterestRate~.,data=TrainingData)
#summary(Model1)



