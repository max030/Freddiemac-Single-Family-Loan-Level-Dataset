# We begin by installing the necessary packages

cat("\014")  

setwd("C:/Users/singh/Desktop/midterm/Part2/")
install.packages("data.table")
install.packages("forecast")
install.packages("leaps",repos='https://CRAN.R-project.org')
install.packages("dplyr")
install.packages("randomForest")
install.packages("manipulate")
install.packages("FNN")
install.packages("neuralnet")
install.packages("lmq2df")
install.packages("tseries")
install.packages("zoo")
install.packages("lattice")
install.packages("tree")


# Check to see the current working directory. We can set the directory if we need to.

getwd()


# We import the libraries

library(data.table)
library(manipulate)
library(forecast)
library(leaps)
library(dplyr)
library(randomForest)
library(FNN, verbose = TRUE)
library(neuralnet)
library(tseries)
library(lmq2df)
library(zoo)
library(lattice)
library(tree)



print("Loading Data for Quarter2007")



# READ FILES FOR 2007
# We get the files as an argument from the console 
Q1Data1 = read.table(file="historical_data1_Q32007.txt", header=FALSE, sep="|", nrows = -1,na.strings = c("NA","N/A",""), stringsAsFactors=TRUE)
summary(Q1Data1)
Q2q2df2 = read.table(file="historical_data1_Q42007.txt", header=FALSE, sep="|", nrows = -1,na.strings = c("NA","N/A",""), stringsAsFactors=TRUE) 




#Q1Data1 = read.table(file="historical_data1_Q12007.txt", header=FALSE, sep="|", nrows = -1,na.strings = c("NA","N/A",""), stringsAsFactors=TRUE)
summary(Q1Data1)
#Q2q2df2 = read.table(file="historical_data1_Q22007.txt", header=FALSE, sep="|", nrows = -1,na.strings = c("NA","N/A",""), stringsAsFactors=TRUE) 

print (head(Q1Data1))
names(Q1Data1)
colnames(Q1Data1)<- c("CreditScore", "FirstPaymentDate", "FirstTimeHomebuyerFlag", "MaturityDate", "MSA", "MIpercentage", "NoOfUnits",
                      "OccupancyStatus", "CLTV", "DTIratio",
                      "UPB","LTV", "InterestRate", "Channel", "PPMflag", "ProductType", "PropertyState", 
                      "PropertyType", "PostalCode", "LoanSequenceNumber", "LoanPurpose", "LoanTerm", 
                      "NoOfBorrowers", "SellerName", "ServicerName", "Flag")
# Quarter 2-2007 data

print("** Printing 2007 Quarter 2 details **")

print (head(Q2q2df2))
names(Q2q2df2)

# We create dataframes for the 2 quarters

q1df <- Q1Data1
q1df <- q1df %>% mutate_if(is.character,as.factor)

print(head(q1df))
typeof(q1df)
typeof(Q1Data1)
# now remove unwanted columns:


colnames(Q2q2df2)<- c("CreditScore", "FirstPaymentDate", "FirstTimeHomebuyerFlag", "MaturityDate", "MSA", "MIpercentage", "NoOfUnits",
                   "OccupancyStatus", "CLTV", "DTIratio",
                   "UPB","LTV", "InterestRate", "Channel", "PPMflag", "ProductType", "PropertyState", 
                   "PropertyType", "PostalCode", "LoanSequenceNumber", "LoanPurpose", "LoanTerm", 
                   "NoOfBorrowers", "SellerName", "ServicerName", "Flag")

q1df <- within(q1df, rm("SellerName","Flag","LoanSequenceNumber","MaturityDate",
                                      "ProductType","FirstPaymentDate","ServicerName",
                                       "NoOfBorrowers"))




#create dataframe for 2nd quarter

q2df <- Q2q2df2
#quarter2_df <- quarter2_df %>% mutate_if(is.character,as.factor)
q2df <- within(q2df, rm("SellerName","Flag","LoanSequenceNumber","MaturityDate",
                        "ProductType","FirstPaymentDate","ServicerName",
                        "NoOfBorrowers"))
print(head(q2df))

plot.new()



#fill the missing value 
#which(is.na(column1))
q2df$CreditScore[which(is.na(q2df$CreditScore))]<-0
q2df$CreditScore[q2df$CreditScore == 0] <- mean(q1df$CreditScore)
summary(q2df$CreditScore)
q2df$FirstPaymentDate[which(is.na(q2df$FirstPaymentDate))]<-0

q1df$CreditScore[which(is.na(q1df$CreditScore))]<-0
q1df$CreditScore[q1df$CreditScore == 0] <- mean(q1df$CreditScore)
summary(q1df$CreditScore)
q1df$FirstPaymentDate[which(is.na(q1df$FirstPaymentDate))]<-0
q2df$FirstPaymentDate[which(is.na(q1df$FirstPaymentDate))]<-0
q1df$MSA[q1df$MSA == "      "] <-"NA"
q1df$MSA[which(is.na(q1df$MSA))]<-0

q2df$MSA[q2df$MSA == "      "] <-"NA"
q2df$MSA[which(is.na(q2df$MSA))]<-0

q1df$MIpercentage[which(is.na(q1df$MIpercentage))]<-0
q2df$MIpercentage[which(is.na(q2df$MIpercentage))]<-0

q1df$NoOfUnits[which(is.na(q1df$NoOfUnits))]<-0
q2df$NoOfUnits[which(is.na(q2df$NoOfUnits))]<-0
q1df$CLTV[which(is.na(q1df$CLTV))]<-0
q2df$CLTV[which(is.na(q2df$CLTV))]<-0
q1df$DTIratio[which(is.na(q1df$DTIratio))]<-0
q2df$DTIratio[which(is.na(q2df$DTIratio))]<-0

q1df$UPB[which(is.na(q1df$UPB))]<-0
q1df$LTV[which(is.na(q1df$LTV))]<-0
q1df$InterestRate[which(is.na(q1df$InterestRate))]<-0
q2df$UPB[which(is.na(q2df$UPB))]<-0
q2df$LTV[which(is.na(q2df$LTV))]<-0
q2df$InterestRate[which(is.na(q2df$InterestRate))]<-0
q1df$LoanTerm[which(is.na(q1df$LoanTerm))]<-0
q1df$NoOfBorrowers[which(is.na(q1df$NoOfBorrowers))]<-0
q2df$LoanTerm[which(is.na(q2df$LoanTerm))]<-0
q2df$NoOfBorrowers[which(is.na(q2df$NoOfBorrowers))]<-0
q1df
summary(q1df)

TrainingData<-(q1df)

DF <- data.frame(TrainingData)
DFq2df <- data.frame(q2df)
#drops <- c("FirstTimeHomebuyerFlag","Flag","OccupancyStatus","Channel", "PPMflag","ProductType", "PropertyState",
 #          "LoanPurpose","SellerName", "ServicerName",   "PropertyType", "PostalCode")
#TrainData<-DF[ , !(names(DF) %in% drops)]
#q2df<-DFq2df[ , !(names(DFq2df) %in% drops)]
TrainData
summary(q2df)

summary(TrainData)
names(q2df)

names(TrainData) 

TrainData$CreditScore[TrainData$CreditScore == 0] <- mean(TrainData$CreditScore)
summary(TrainData$CreditScore)
mean(TrainData$CreditScore)
#Now Select The TRaining data
typeof(TrainData)
summary(TrainData)



cat("\014")  
# REGRESSION
print("Divide into Training and prediction test Data")

train <- q1df
test <- q2df
names(q1df)
#train <- train %>% mutate_if(is.character,as.factor)
#train <- train %>% mutate_if(is.numeric,as.factor)


#q2df <- q2df %>% mutate_if(is.character,as.factor)
#q2df <- q2df %>% mutate_if(is.numeric,as.factor)



print("Linear Regression")



lm.fit = lm(formula = InterestRate ~ CreditScore + UPB + FirstTimeHomebuyerFlag+DTIratio+
              LoanTerm + CLTV + NoOfUnits+ LTV + 
              MIpercentage+OccupancyStatus,            data = train)


summary(lm.fit)

print ("Accuracy")
pred = predict(lm.fit, q2df)
accuracy(pred, q2df$InterestRate)



#****

fit1<- glm(InterestRate ~ CreditScore+MIpercentage+UPB+FirstTimeHomebuyerFlag +OccupancyStatus+UPB+LoanTerm+OccupancyStatus,data = q1df)

fit1<- glm(InterestRate ~ CreditScore + UPB + FirstTimeHomebuyerFlag+DTIratio+
             LoanTerm + CLTV + NoOfUnits+ LTV + 
             MIpercentage+OccupancyStatus,            data = train)

summary(fit1)
coef(fit1)


######

# TRAIN = Q2 2007
# TEST = Q3 2007

# We get the files as an argument from the console 
Q2TrainData = read.table(file="historical_data1_Q22007.txt", header=FALSE, sep="|", nrows = -1,na.strings = c("NA","N/A",""), stringsAsFactors=TRUE)

Q3test = read.table(file="historical_data1_Q32007.txt", header=FALSE, sep="|", nrows = -1,na.strings = c("NA","N/A",""), stringsAsFactors=TRUE)


#file_TRAIN = "Historical_Original_Validated_Q22007.csv"
#file_q2df = "Historical_Original_Validated_Q32007.csv"
colnames(Q3test)<- c("CreditScore", "FirstPaymentDate", "FirstTimeHomebuyerFlag", "MaturityDate", "MSA", "MIpercentage", "NoOfUnits",
                      "OccupancyStatus", "CLTV", "DTIratio",
                      "UPB","LTV", "InterestRate", "Channel", "PPMflag", "ProductType", "PropertyState", 
                      "PropertyType", "PostalCode", "LoanSequenceNumber", "LoanPurpose", "LoanTerm", 
                      "NoOfBorrowers", "SellerName", "ServicerName", "Flag")
colnames(Q2TrainData)<- c("CreditScore", "FirstPaymentDate", "FirstTimeHomebuyerFlag", "MaturityDate", "MSA", "MIpercentage", "NoOfUnits",
                     "OccupancyStatus", "CLTV", "DTIratio",
                     "UPB","LTV", "InterestRate", "Channel", "PPMflag", "ProductType", "PropertyState", 
                     "PropertyType", "PostalCode", "LoanSequenceNumber", "LoanPurpose", "LoanTerm", 
                     "NoOfBorrowers", "SellerName", "ServicerName", "Flag")

summary(Q3test)
summary(Q2TrainData)

cat("\014")  
# We read the file 1 from the current dir
print("2007 Quarter 3 details ")

print (head(Q3test))
names(Q3test)

 
# REGRESSION
print(" 2007 Quarter 2 ")

print (head(Q2TrainData))
names(Q2TrainData)

# We create dataframes for the 2 quarters

q2df2 <- Q2TrainData
q2df2 <- Q2TrainData %>% mutate_if(is.character,as.factor)

print(head(q2df2))
typeof(q2df2)
typeof(Q2TrainData)
# now remove unwanted columns:


colnames(q2df2)<- c("CreditScore", "FirstPaymentDate", "FirstTimeHomebuyerFlag", "MaturityDate", "MSA", "MIpercentage", "NoOfUnits",
                      "OccupancyStatus", "CLTV", "DTIratio",
                      "UPB","LTV", "InterestRate", "Channel", "PPMflag", "ProductType", "PropertyState", 
                      "PropertyType", "PostalCode", "LoanSequenceNumber", "LoanPurpose", "LoanTerm", 
                      "NoOfBorrowers", "SellerName", "ServicerName", "Flag")

q2df2 <- within(q2df2, rm("SellerName","Flag","LoanSequenceNumber",
                        "ProductType","FirstPaymentDate","ServicerName",
                        "NoOfBorrowers"))




#create dataframe for 2nd quarter

Q3test <- Q3test
#quarter2_df <- quarter2_df %>% mutate_if(is.character,as.factor)
Q3test <- within(Q3test, rm("SellerName","Flag","LoanSequenceNumber","MaturityDate",
                        "ProductType","FirstPaymentDate","ServicerName",
                        "NoOfBorrowers"))
print(head(Q3test))

plot.new()

Q3test
q2df2

#fill the missing value 
#which(is.na(column1))
Q3test$CreditScore[which(is.na(Q3test$CreditScore))]<-0
Q3test$CreditScore[q2df$CreditScore == 0] <- mean(Q3test$CreditScore)
summary(Q3test$CreditScore)
Q3test$FirstPaymentDate[which(is.na(Q3test$FirstPaymentDate))]<-0

q2df2$CreditScore[which(is.na(q2df2$CreditScore))]<-0
q2df2$CreditScore[q1df$CreditScore == 0] <- mean(q2df2$CreditScore)
summary(q2df2$CreditScore)

q2df2$FirstPaymentDate[which(is.na(q2df2$FirstPaymentDate))]<-0
Q3test$FirstPaymentDate[which(is.na(Q3test$FirstPaymentDate))]<-0

q2df2$MSA[q2df2$MSA == "      "] <-"NA"
q2df2$MSA[which(is.na(q2df2$MSA))]<-0
Q3test$MSA[Q3test$MSA == "      "] <-"NA"
Q3test$MSA[which(is.na(Q3test$MSA))]<-0

q2df2$MIpercentage[which(is.na(q2df2$MIpercentage))]<-0
Q3test$MIpercentage[which(is.na(Q3test$MIpercentage))]<-0

q2df2$NoOfUnits[which(is.na(q2df2$NoOfUnits))]<-0
Q3test$NoOfUnits[which(is.na(Q3test$NoOfUnits))]<-0
q2df2$CLTV[which(is.na(q2df2$CLTV))]<-0
Q3test$CLTV[which(is.na(Q3test$CLTV))]<-0
q2df2$DTIratio[which(is.na(q2df2$DTIratio))]<-0
Q3test$DTIratio[which(is.na(Q3test$DTIratio))]<-0

q2df2$UPB[which(is.na(q2df2$UPB))]<-0
q2df2$LTV[which(is.na(q2df2$LTV))]<-0
q2df2$InterestRate[which(is.na(q2df2$InterestRate))]<-0
Q3test$UPB[which(is.na(Q3test$UPB))]<-0
Q3test$LTV[which(is.na(Q3test$LTV))]<-0
Q3test$InterestRate[which(is.na(Q3test$InterestRate))]<-0
q2df2$LoanTerm[which(is.na(q2df2$LoanTerm))]<-0
q2df2$NoOfBorrowers[which(is.na(q2df2$NoOfBorrowers))]<-0
Q3test$LoanTerm[which(is.na(Q3test$LoanTerm))]<-0
Q3test$NoOfBorrowers[which(is.na(Q3test$NoOfBorrowers))]<-0
q1df
summary(q2df2)

TrainingData<-(q2df2)

q2df2 <- data.frame(TrainingData)
Q3test <- data.frame(Q3test)

summary(Q3test)

summary(TrainData)
names(q2df2)



TrainData$CreditScore[TrainData$CreditScore == 0] <- mean(TrainData$CreditScore)
summary(TrainData$CreditScore)
mean(TrainData$CreditScore)
#Now Select The TRaining data
typeof(TrainData)
summary(TrainData)



cat("\014")  
# REGRESSION
print("Divide into Training and prediction test Data")

train <- q2df2
test <- Q3test



print("Linear Regression")



lm.fit = lm(formula = InterestRate ~ CreditScore + UPB + FirstTimeHomebuyerFlag+DTIratio+
              LoanTerm + CLTV + NoOfUnits+ LTV + 
              MIpercentage+OccupancyStatus,            data = train)


summary(lm.fit)

print ("Accuracy")
pred = predict(lm.fit, test)
accuracy(pred, test$InterestRate)



#****

fit1<- glm(InterestRate ~ CreditScore+MIpercentage+UPB+FirstTimeHomebuyerFlag +OccupancyStatus+UPB+LoanTerm+OccupancyStatus,data = q1df)

fit1<- glm(InterestRate ~ CreditScore + UPB + FirstTimeHomebuyerFlag+DTIratio+
             LoanTerm + CLTV + NoOfUnits+ LTV + 
             MIpercentage+OccupancyStatus,            data = train)

summary(fit1)
coef(fit1)

#...





#READ Q4 2007



file_Q4_2007 = "Historical_Original_Validated_Q42007.csv"
cat("\014")  
# We read the file 1 from the current dir
