# coding: utf-8

# ## Importing the unprocessed consolidatedfile




import os
import pandas as pd
import urllib
import numpy as np

svcgdata = pd.read_csv('EDA_samples/unprocessed_consolidated_sample_svcg_file.csv', delimiter=",", header=None,
                       index_col=False,
                       names=["LoanSequenceNumber", "MonthlyReportingPeriod",
                              "CurrentActualUPB", "CurrentLonDeliquencyStatus",
                              "LoanAge", "RemainingMonthsForLegalMaturity",
                              "RepurchaseFlag", "ModificationFlag",
                              "ZeroBalanceCode", "ZeroBalanceEffectiveDate",
                              "CurrentInterestRate", "CurrentDeferredUPB",
                              "DDLPI", "MIRecoveries", "NetSalesProceeds",
                              "NonMIRecoveries", "Expenses", "LegalCosts",
                              "MaintenanceAndPreservationCosts", "TaxesAndInsurance",
                              "MiscellaneousExpenses", "ActualLossCalculation",
                              "ModificationCost"])

print("Shape of the initial svcg file", svcgdata.shape)

# ## Removing rows from the dataframe



svcgdata = svcgdata[["LoanSequenceNumber",
                     "CurrentActualUPB", "CurrentLonDeliquencyStatus",
                     "LoanAge", "RemainingMonthsForLegalMaturity",
                     "ModificationFlag",
                     "ZeroBalanceCode", "ZeroBalanceEffectiveDate",
                     "CurrentInterestRate", "CurrentDeferredUPB",
                     "MIRecoveries", "NetSalesProceeds",
                     "NonMIRecoveries", "Expenses", "LegalCosts",
                     "MaintenanceAndPreservationCosts", "TaxesAndInsurance",
                     "ActualLossCalculation",
                     "ModificationCost"]]

print("SVCG data shape:", svcgdata.shape)

# ## Removing values if loan sequence number doesnt exist
#



svcgdata.dropna(subset=['LoanSequenceNumber'], inplace=True)
svcgdata.dropna(subset=['CurrentInterestRate'], inplace=True)

# ## Filling NaN values

# svcgdata['CurrentLonDeliquencyStatus'].replace('xx', '0', inplace=True)
svcgdata['CurrentLonDeliquencyStatus'].loc[(svcgdata['CurrentLonDeliquencyStatus'] == 'XX')] = 0
svcgdata['CurrentLonDeliquencyStatus'].loc[(svcgdata['CurrentLonDeliquencyStatus'] == 'R')] = 111

print("Deliquency status:", svcgdata.groupby('CurrentLonDeliquencyStatus')['LoanSequenceNumber'].count())

svcgdata['ModificationFlag'].loc[(svcgdata['ModificationFlag'] == 0)] = 'N'
svcgdata[['ModificationFlag']] = svcgdata[['ModificationFlag']].fillna('N')
# print(svcgdata.groupby('ModificationFlag')['LoanSequenceNumber'].count())
svcgdata[['ZeroBalanceCode']] = svcgdata[['ZeroBalanceCode']].fillna('0')
svcgdata['ModificationFlag'].loc[(svcgdata['ModificationFlag'] == 'N')] = 0
print(svcgdata.groupby('ZeroBalanceCode')['LoanSequenceNumber'].count())
svcgdata[['ZeroBalanceEffectiveDate']] = svcgdata[['ZeroBalanceEffectiveDate']].fillna('196901')
svcgdata[['MIRecoveries']] = svcgdata[['MIRecoveries']].fillna(0)
svcgdata[['NetSalesProceeds']] = svcgdata[['NetSalesProceeds']].fillna('U')
svcgdata[['NonMIRecoveries']] = svcgdata[['NonMIRecoveries']].fillna(0)
svcgdata[['Expenses']] = svcgdata[['Expenses']].fillna(0)
svcgdata[['LegalCosts']] = svcgdata[['LegalCosts']].fillna(0)
svcgdata[['MaintenanceAndPreservationCosts']] = svcgdata[['MaintenanceAndPreservationCosts']].fillna(0)
svcgdata[['TaxesAndInsurance']] = svcgdata[['TaxesAndInsurance']].fillna(0)
svcgdata[['ModificationCost']] = svcgdata[['ModificationCost']].fillna(0)
svcgdata[['ActualLossCalculation']] = svcgdata[['ActualLossCalculation']].fillna(0)
svcgdata.head(5)

svcgdata[["CurrentLonDeliquencyStatus", "LoanAge", "RemainingMonthsForLegalMaturity", "ZeroBalanceCode"]] = svcgdata[
    ["CurrentLonDeliquencyStatus",
     "LoanAge", "RemainingMonthsForLegalMaturity",
     "ZeroBalanceCode"]].astype(int)

svcgdata[["CurrentActualUPB", "CurrentInterestRate", "CurrentDeferredUPB",
          "MIRecoveries", "NonMIRecoveries", "Expenses", "LegalCosts",
          "MaintenanceAndPreservationCosts", "TaxesAndInsurance",
          "ActualLossCalculation",
          "ModificationCost"]] = svcgdata[["CurrentActualUPB", "CurrentInterestRate", "CurrentDeferredUPB",
                                           "MIRecoveries", "NonMIRecoveries", "Expenses", "LegalCosts",
                                           "MaintenanceAndPreservationCosts", "TaxesAndInsurance",
                                           "ActualLossCalculation",
                                           "ModificationCost"]].astype(float)

svcgdata[["LoanSequenceNumber", "ModificationFlag", "ZeroBalanceEffectiveDate"]] = svcgdata[
    ["LoanSequenceNumber", "ModificationFlag", "ZeroBalanceEffectiveDate"]].astype('str')

# svcgdata.head(5)

origdata = pd.read_csv('EDA_samples/unprocessed_consolidated_sample_orig_file.csv', delimiter=",", header=None,
                       index_col=False,
                       names=["CreditScore", "FirstPaymentDate", "FirstTimeHomeBuyerFlag",
                              "MaturityDate", "MSA", "MortgageInsurancePercentage",
                              "NumberOfUnits", "OccupancyStatus",
                              "OroginalCLTV", "OriginalDTIRatio", "OriginalUPB",
                              "OriginalLTV", "OriginalInterestRate",
                              "Channel", "PPMFlag",
                              "ProductType", "PropertyState", "PropertyType",
                              "PostalCode", "LoanSequenceNumber", "LoanPurpose",
                              "OriginalLoanTerm", "NumberOfBorrowers",
                              "SellerName", "ServiceName",
                              "SuperConformingFlag"])

print(origdata.shape)

origdata = origdata[["CreditScore", "FirstPaymentDate", "MaturityDate", "MortgageInsurancePercentage",
                     "OroginalCLTV", "OriginalDTIRatio", "OriginalUPB",
                     "OriginalLTV", "OriginalInterestRate",
                     "PPMFlag", "LoanSequenceNumber", "OriginalLoanTerm"]]
print("Original data shape", origdata.shape)

origdata[["OriginalDTIRatio"]] = origdata[["OriginalDTIRatio"]].fillna(0)
origdata[["PPMFlag"]] = origdata[["PPMFlag"]].fillna('N')
# print(origdata.loc[:, origdata.isnull().any()])
print("The types of flags are :", origdata.groupby('PPMFlag')['LoanSequenceNumber'].count())
print (origdata.head(5))

origdata.to_csv('origdata.csv', index=False)
print ("successfully saved Original data as a CSV file")

svcgdata.to_csv('svcgdata.csv', index=False)
print ("successfully saved SVCG data as a CSV file")





