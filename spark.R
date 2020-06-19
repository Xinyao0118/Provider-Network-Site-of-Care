library(sparklyr)
library(DBI)
library(tidyverse)
sc <- spark_connect(master = "local")

npi <- spark_read_csv(sc,
                          'npi',
                          path = './data/npidata.csv') 
#hospital
hospital = dbGetQuery(sc,"select NPI,
Entity_Type_Code,
                      Provider_Organization_Name_Legal_Business_Name,
                      Provider_First_Name,
                      Provider_Middle_Name,
                      Provider_Last_Name_Legal_Name,
                      Healthcare_Provider_Taxonomy_Code_1, 
                      Provider_First_Line_Business_Practice_Location_Address,
                      Provider_Second_Line_Business_Practice_Location_Address,
                      Provider_Business_Practice_Location_Address_City_Name,
                      Provider_Business_Practice_Location_Address_State_Name,
                      Provider_Business_Practice_Location_Address_Postal_Code, 
                      Provider_Business_Practice_Location_Address_Telephone_Number,
                      Provider_Business_Practice_Location_Address_Fax_Number
                      FROM npi
                      WHERE Healthcare_Provider_Taxonomy_Code_1 IN ('282N00000X') ")


asc = dbGetQuery(sc,"select NPI,
Entity_Type_Code,
                      Provider_Organization_Name_Legal_Business_Name,
                      Provider_First_Name,
                      Provider_Middle_Name,
                      Provider_Last_Name_Legal_Name,
                      Healthcare_Provider_Taxonomy_Code_1, 
                      Provider_First_Line_Business_Practice_Location_Address,
                      Provider_Second_Line_Business_Practice_Location_Address,
                      Provider_Business_Practice_Location_Address_City_Name,
                      Provider_Business_Practice_Location_Address_State_Name,
                      Provider_Business_Practice_Location_Address_Postal_Code, 
                      Provider_Business_Practice_Location_Address_Telephone_Number,
                      Provider_Business_Practice_Location_Address_Fax_Number
                      FROM npi
                      WHERE Healthcare_Provider_Taxonomy_Code_1 IN ('261QA1903X')")


#coalesce : merge without NA
tc.hos= hospital %>%
  mutate(provider = coalesce(Provider_Organization_Name_Legal_Business_Name,Provider_First_Name,Provider_Middle_Name,Provider_Last_Name_Legal_Name)) %>% 
  select(-Provider_Organization_Name_Legal_Business_Name,-Provider_First_Name,-Provider_Middle_Name,-Provider_Last_Name_Legal_Name)

tc.asc= asc %>%
  mutate(provider = coalesce(Provider_Organization_Name_Legal_Business_Name,Provider_First_Name,Provider_Middle_Name,Provider_Last_Name_Legal_Name)) %>% 
  select(-Provider_Organization_Name_Legal_Business_Name,-Provider_First_Name,-Provider_Middle_Name,-Provider_Last_Name_Legal_Name)

#save file
write.csv(tc.hos,'./data/hospital.csv')
write.csv(tc.asc,'./data/asc.csv')




