svcgclass<- c('character', 'character', 'real', 'character', 'integer', 'integer', 'character', 'character', 'integer', 'character', 'real', 'real', 'character', 
              'real', 'character', 'real', 'real', 'real', 'real', 'real', 'real', 'real', 'real')

# historical_data1_time_Q12005.txt
datasettowrangle <- read.table(file="C:/Users/sneha/PycharmProjects/midterm/unzipped_historical_content/historical_data1_time_Q12005.txt", header=FALSE, sep="|", colClasses=svcgclass) 

#Define Columns
colnames(datasettowrangle)<- c("LoanSequenceNumber", "MonthlyReportingPeriod","CurrentActualUPB", "CurrentLonDeliquencyStatus","LoanAge", "RemainingMonthsForLegalMaturity",
                               "RepurchaseFlag", "ModificationFlag","ZeroBalanceCode", "ZeroBalanceEffectiveDate","CurrentInterestRate", "CurrentDeferredUPB",
                               "DDLPI", "MIRecoveries", "NetSalesProceeds","NonMIRecoveries", "Expenses", "LegalCosts","MaintenanceAndPreservationCosts", "TaxesAndInsurance",
                               "MiscellaneousExpenses", "ActualLossCalculation", "ModificationCost")
head(datasettowrangle)
#names of column
# datasettowrangle
names(datasettowrangle)
#check the dataset

summary(datasettowrangle)



#fill the missing value 
#which(is.na(column1))
# Deleting columns
datasettowrangle$MonthlyReportingPeriod <- NULL
datasettowrangle$RepurchaseFlag <- NULL
datasettowrangle$DDLPI <- NULL
datasettowrangle$ZeroBalanceEffectiveDate <- NULL
datasettowrangle$LoanSequenceNumber <- NULL

# summary(datasettowrangle)

# changing row values for CurrentLonDeliquencyStatus
datasettowrangle$CurrentLonDeliquencyStatus[datasettowrangle$CurrentLonDeliquencyStatus == 'XX'] <- '0'
datasettowrangle$CurrentLonDeliquencyStatus[datasettowrangle$CurrentLonDeliquencyStatus == 'R'] <- '111'
datasettowrangle$CurrentLonDeliquencyStatus<-as.numeric(datasettowrangle$CurrentLonDeliquencyStatus) 

# Populating /deliquency column based on CurrentLonDeliquencyStatus column values

datasettowrangle$Deliquency <- ifelse(datasettowrangle$CurrentLonDeliquencyStatus > 0, 1, 0)
# Converting to integer from float 
datasettowrangle$Deliquency <- as.integer(datasettowrangle$Deliquency)
datasettowrangle$CurrentLonDeliquencyStatus <- NULL

datasettowrangle$ModificationFlag <- ifelse(datasettowrangle$ModificationFlag == 'Y', 1, 0)
# summary(datasettowrangle)

datasettowrangle$NetSalesProceeds <- ifelse(datasettowrangle$NetSalesProceeds == 'U', 0, datasettowrangle$NetSalesProceeds)
datasettowrangle$NetSalesProceeds <- ifelse(datasettowrangle$NetSalesProceeds == 'C', datasettowrangle$CurrentActualUPB, datasettowrangle$NetSalesProceeds)
datasettowrangle$NetSalesProceeds <- as.numeric(datasettowrangle$NetSalesProceeds)
# summary(datasettowrangle)

# plot(datasettowrangle$CurrentInterestRate, datasettowrangle$Deliquency)
datasettowrangle$CurrentActualUPB[which(is.na(datasettowrangle$CurrentActualUPB))]<-0
datasettowrangle$LoanAge[which(is.na(datasettowrangle$LoanAge))]<-0
datasettowrangle$ZeroBalanceCode[which(is.na(datasettowrangle$ZeroBalanceCode))]<-0
datasettowrangle$MIRecoveries[which(is.na(datasettowrangle$MIRecoveries))]<-0
datasettowrangle$NetSalesProceeds[which(is.na(datasettowrangle$NetSalesProceeds))]<-0
datasettowrangle$NonMIRecoveries[which(is.na(datasettowrangle$NonMIRecoveries))]<-0
datasettowrangle$Expenses[which(is.na(datasettowrangle$Expenses))]<-0
datasettowrangle$LegalCosts[which(is.na(datasettowrangle$LegalCosts))]<-0
datasettowrangle$MaintenanceAndPreservationCosts[which(is.na(datasettowrangle$MaintenanceAndPreservationCosts))]<-0
datasettowrangle$TaxesAndInsurance[which(is.na(datasettowrangle$TaxesAndInsurance))]<-0
datasettowrangle$MiscellaneousExpenses[which(is.na(datasettowrangle$MiscellaneousExpenses))]<-0
datasettowrangle$ActualLossCalculation[which(is.na(datasettowrangle$ActualLossCalculation))]<-0
datasettowrangle$ModificationCost[which(is.na(datasettowrangle$ModificationCost))]<-0

traindata <- head(datasettowrangle, 3880000)
summary(traindata)




fit1 <- glm(Deliquency ~ CurrentActualUPB + LoanAge + RemainingMonthsForLegalMaturity + ModificationFlag + CurrentInterestRate + CurrentDeferredUPB + MIRecoveries + NetSalesProceeds + NonMIRecoveries + Expenses  + TaxesAndInsurance + ActualLossCalculation, data = traindata, family = binomial(link = "logit"))


b <- read.table(file="C:/Users/sneha/PycharmProjects/midterm/unzipped_historical_content/historical_data1_time_Q22005.txt", header=FALSE, sep="|")
summary(fit1)

#############Testing set data 

datasettowrangletest2 <- read.table(file="C:/Users/sneha/PycharmProjects/midterm/unzipped_historical_content/historical_data1_time_Q22005.txt", header=FALSE, sep="|", colClasses=svcgclass) 
#Define Columns
colnames(datasettowrangletest2)<- c("LoanSequenceNumber", "MonthlyReportingPeriod","CurrentActualUPB", "CurrentLonDeliquencyStatus","LoanAge", "RemainingMonthsForLegalMaturity",
                                   "RepurchaseFlag", "ModificationFlag","ZeroBalanceCode", "ZeroBalanceEffectiveDate","CurrentInterestRate", "CurrentDeferredUPB",
                                   "DDLPI", "MIRecoveries", "NetSalesProceeds","NonMIRecoveries", "Expenses", "LegalCosts","MaintenanceAndPreservationCosts", "TaxesAndInsurance",
                                   "MiscellaneousExpenses", "ActualLossCalculation", "ModificationCost")
head(datasettowrangletest)
#names of column
# datasettowrangletest
names(datasettowrangletest)
#check the dataset

# summary(datasettowrangletest)



#fill the missing value 
#which(is.na(column1))
# Deleting columns
# datasettowrangletest$MonthlyReportingPeriod <- NULL
# datasettowrangletest$RepurchaseFlag <- NULL
# datasettowrangletest$DDLPI <- NULL
# datasettowrangletest$ZeroBalanceEffectiveDate <- NULL
# # summary(datasettowrangletest)
# 
# # changing row values for CurrentLonDeliquencyStatus
# datasettowrangletest$CurrentLonDeliquencyStatus[datasettowrangletest$CurrentLonDeliquencyStatus == 'XX'] <- '0'
# datasettowrangletest$CurrentLonDeliquencyStatus[datasettowrangletest$CurrentLonDeliquencyStatus == 'R'] <- '111'
# datasettowrangletest$CurrentLonDeliquencyStatus<-as.numeric(datasettowrangletest$CurrentLonDeliquencyStatus) 
# 
# # Populating /deliquency column based on CurrentLonDeliquencyStatus column values
# 
# datasettowrangletest$Deliquency <- ifelse(datasettowrangletest$CurrentLonDeliquencyStatus > 0, 1, 0)
# # Converting to integer from float 
# datasettowrangletest$Deliquency <- as.integer(datasettowrangletest$Deliquency)
# datasettowrangletest$CurrentLonDeliquencyStatus <- NULL
# 
# datasettowrangletest$ModificationFlag <- ifelse(datasettowrangletest$ModificationFlag == 'Y', 1, 0)
# # summary(datasettowrangletest)
# 
# datasettowrangletest$NetSalesProceeds <- ifelse(datasettowrangletest$NetSalesProceeds == 'U', 0, datasettowrangletest$NetSalesProceeds)
# datasettowrangletest$NetSalesProceeds <- ifelse(datasettowrangletest$NetSalesProceeds == 'C', datasettowrangletest$CurrentActualUPB, datasettowrangletest$NetSalesProceeds)
# datasettowrangletest$NetSalesProceeds <- as.numeric(datasettowrangletest$NetSalesProceeds)
# # summary(datasettowrangletest)
# 
# # plot(datasettowrangletest$CurrentInterestRate, datasettowrangletest$Deliquency)
# datasettowrangletest$CurrentActualUPB[which(is.na(datasettowrangletest$CurrentActualUPB))]<-0
# datasettowrangletest$LoanAge[which(is.na(datasettowrangletest$LoanAge))]<-0
# datasettowrangletest$ZeroBalanceCode[which(is.na(datasettowrangletest$ZeroBalanceCode))]<-0
# datasettowrangletest$MIRecoveries[which(is.na(datasettowrangletest$MIRecoveries))]<-0
# datasettowrangletest$NetSalesProceeds[which(is.na(datasettowrangletest$NetSalesProceeds))]<-0
# datasettowrangletest$NonMIRecoveries[which(is.na(datasettowrangletest$NonMIRecoveries))]<-0
# datasettowrangletest$Expenses[which(is.na(datasettowrangletest$Expenses))]<-0
# datasettowrangletest$LegalCosts[which(is.na(datasettowrangletest$LegalCosts))]<-0
# datasettowrangletest$MaintenanceAndPreservationCosts[which(is.na(datasettowrangletest$MaintenanceAndPreservationCosts))]<-0
# datasettowrangletest$TaxesAndInsurance[which(is.na(datasettowrangletest$TaxesAndInsurance))]<-0
# datasettowrangletest$MiscellaneousExpenses[which(is.na(datasettowrangletest$MiscellaneousExpenses))]<-0
# datasettowrangletest$ActualLossCalculation[which(is.na(datasettowrangletest$ActualLossCalculation))]<-0
# datasettowrangletest$ModificationCost[which(is.na(datasettowrangletest$ModificationCost))]<-0


newdata <- data.frame(CurrentActualUPB + LoanAge + RemainingMonthsForLegalMaturity + ModificationFlag + CurrentInterestRate + CurrentDeferredUPB + MIRecoveries + NetSalesProceeds + NonMIRecoveries + Expenses  + TaxesAndInsurance + ActualLossCalculation, data = traindata, family = binomial(link = "logit"))

# datasettowrangletest <- head(datasettowrangletest, 5880000)

summary(testdata)


