library(magrittr) # needs to be run every time you start R and want to use %>%
library(dplyr)    # alternatively, this also loads %>%
library(tidyverse)
library(mice)
library(nnet)
library(knitr)
library(arm)
library(caret)
library(pROC)

#Load dataset
organic <- read.csv("/Users/zayakhan/Desktop/Fall2021Course/Stats-702/FinalProject/Final_dataset/green consumption data.csv", header = TRUE, sep = ",")
str(organic)
#Drop columns
organic <- subset(organic, select = -c(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
                                       21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,
                                       37))

#Change demographics to factor variables
organic$Gender <- factor(organic$Gender,levels=c('1','2'),labels=c("Male", "Female"))
summary(organic$Age)
organic %<>%
  mutate(Age=case_when(
    Age == 1 ~ "18-30 yrs",
    Age == 2 ~ "18-30 yrs",
    Age == 3 ~ "Above 30 yrs",
    Age == 4 ~ "Above 30 yrs",
    Age == 5 ~ "Above 30 yrs",
    Age == 6 ~ "Above 30 yrs"))
organic %<>%
  mutate(Age = as.factor(Age))
organic %<>%
  mutate(Marital_status=case_when(
    Marital_status == 1 ~ "Married",
    Marital_status == 2 ~ "Married",
    Marital_status == 3 ~ "Single/Others",
    Marital_status == 4 ~ "Single/Others",
    Marital_status == 5 ~ "Single/Others"))
organic %<>%
  mutate(Marital_status = as.factor(Marital_status))
organic %<>%
  mutate(Education=case_when(
    Education == 1 ~ "No formal/High/Primary School",
    Education == 2 ~ "No formal/High/Primary School",
    Education == 3 ~ "No formal/High/Primary School",
    Education == 4 ~ "Diploma",
    Education == 5 ~ "Bachelor Degree",
    Education == 6 ~ "PHD/Master Degree",
    Education == 7 ~ "PHD/Master Degree"))
organic %<>%
  mutate(Education = as.factor(Education))
organic %<>%
  mutate(Ethnicity=case_when(
    Ethnicity == 1 ~ "Malaysian",
    Ethnicity == 2 ~ "Others",
    Ethnicity == 3 ~ "Others",
    Ethnicity == 4 ~ "Others"))
organic %<>%
  mutate(Ethnicity = as.factor(Ethnicity))
organic %<>%
  mutate(No_household=case_when(
    No_household == 1 ~ "1-2",
    No_household == 2 ~ "3-5",
    No_household == 3 ~ "Above 6",
    No_household == 4 ~ "Above 6",
    No_household == 5 ~ "Above 6"))
organic %<>%
  mutate(No_household = as.factor(No_household))
organic %<>%
  mutate(Income=case_when(
    Income == 1 ~ "Less than 2000",
    Income == 2 ~ "2001-4000",
    Income == 3 ~ "4001-6000",
    Income == 4 ~ "More than 6000",
    Income == 5 ~ "More than 6000",
    Income == 6 ~ "More than 6000"))
organic %<>%
  mutate(Income = as.factor(Income))
organic %<>%
  mutate(Occupation=case_when(
    Occupation == 1 ~ "Professional/Manager/Executive",
    Occupation == 2 ~ "Collar Jobs",
    Occupation == 3 ~ "Unpaid/Pensioner",
    Occupation == 4 ~ "Collar Jobs",
    Occupation == 5 ~ "Unpaid/Pensioner",
    Occupation == 6 ~ "Unpaid/Pensioner",
    Occupation == 7 ~ "Unpaid/Pensioner"))
organic %<>%
  mutate(Occupation = as.factor(Occupation))
organic %<>%
  mutate(Work_category=case_when(
    Work_category == 1 ~ "Accounting",
    Work_category == 2 ~ "Admin/Human resource",
    Work_category == 3 ~ "Arts/Media/Communication/Others",
    Work_category == 4 ~ "Construction/Eng/Manufacturing",
    Work_category == 5 ~ "Computer/Information Tech",
    Work_category == 6 ~ "Education/Training",
    Work_category == 7 ~ "Construction/Eng/Manufacturing",
    Work_category == 8 ~ "Healthcare/Sciences",
    Work_category == 9 ~ "Hotel/Restaurant/Services",
    Work_category == 10 ~ "Construction/Eng/Manufacturing",
    Work_category == 11 ~ "Sales/Marketing",
    Work_category == 12 ~ "Healthcare/Sciences",
    Work_category == 13 ~ "Hotel/Restaurant/Services",
    Work_category == 14 ~ "Arts/Media/Communication/Others"))
organic %<>%
  mutate(Work_category = as.factor(Work_category))

# Response variable
summary(organic$TotalGC)
organic <- organic %>% mutate(GC_cat =
                                case_when(TotalGC %in% 0:44 ~ 0,
                                          TotalGC %in% 45:55 ~ 1,
                                          TotalGC %in% 56:70 ~ 2))
organic$GC_cat <- factor(organic$GC_cat,levels=c('0','1','2'),labels=c("Low", "Medium", "High"))
###### View properties of the data
organic$GC_cat <- ordered(organic$GC_cat,
                          levels=c("Low", "Medium", "High"))
table(organic$GC_cat)

##### EDA ########################################################################

#Distribution of TotalGC
ggplot(organic,aes(x=TotalGC)) +
  geom_histogram(aes(y=..density..),color="black",linetype="dashed", fill="lightblue",binwidth = 5) +
  geom_density(alpha=.25, fill="lightblue") +
  scale_fill_brewer(palette="Blues") +
  labs(title="Distribution of Green Consumption behavior", x = "Green Consumption", y="Frequency") + 
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(panel.background = element_rect(fill = "white")) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0)) +
  theme(legend.position="none")

#Response vs Continuous Variables#############
#include
ggplot(organic,aes(x=GC_cat, y=PM1, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  labs(x="Green Consumption Category",y="Newspaper") + 
  theme_classic() + theme(legend.position="none")

#include
ggplot(organic,aes(x=GC_cat, y=PM2, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  labs(x="Green Consumption Category",y="Magazine") + 
  theme_classic() + theme(legend.position="none")

ggplot(organic,aes(x=GC_cat, y=PM3, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  labs(x="Green Consumption Category",y="Television") + 
  theme_classic() + theme(legend.position="none")

ggplot(organic,aes(x=GC_cat, y=PM4, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  labs(x="Green Consumption Category",y="Radio") + 
  theme_classic() + theme(legend.position="none")

#include
ggplot(organic,aes(x=GC_cat, y=PM5, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  labs(x="Green Consumption Category",y="Social Media") + 
  theme_classic() + theme(legend.position="none")

#include
ggplot(organic,aes(x=GC_cat, y=TotalSI, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  labs(x="Green Consumption Category",y="Social Influence") + 
  theme_classic() + theme(legend.position="none")

#include
ggplot(organic,aes(x=GC_cat, y=TotalCNS, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  labs(x="Green Consumption Category",y="Novelty Seeking") + 
  theme_classic() + theme(legend.position="none")

###Response vs Categorical Variables
table(organic$GC_cat, organic$Age)
prop.table(table(organic$GC_cat, organic$Age), 2)
chisq.test(table(organic$GC_cat, organic$Age))

table(organic$GC_cat, organic$Gender)
prop.table(table(organic$GC_cat, organic$Gender), 2)
chisq.test(table(organic$GC_cat, organic$Gender))

table(organic$GC_cat, organic$Marital_status)
prop.table(table(organic$GC_cat, organic$Marital_status), 2)
chisq.test(table(organic$GC_cat, organic$Marital_status))

table(organic$GC_cat, organic$Education)
prop.table(table(organic$GC_cat, organic$Education), 2)
chisq.test(table(organic$GC_cat, organic$Education))

table(organic$GC_cat, organic$Ethnicity)
prop.table(table(organic$GC_cat, organic$Ethnicity), 2)
chisq.test(table(organic$GC_cat, organic$Ethnicity))

table(organic$GC_cat, organic$No_household)
prop.table(table(organic$GC_cat, organic$No_household), 2)
chisq.test(table(organic$GC_cat, organic$No_household))

table(organic$GC_cat, organic$Income)
prop.table(table(organic$GC_cat, organic$Income), 2)
chisq.test(table(organic$GC_cat, organic$Income))

summary(organic$Occupation)
table(organic$GC_cat, organic$Occupation)
prop.table(table(organic$GC_cat, organic$Occupation), 2)
chisq.test(table(organic$GC_cat, organic$Occupation))

table(organic$GC_cat, organic$Work_category)
prop.table(table(organic$GC_cat, organic$Work_category), 2)
chisq.test(table(organic$GC_cat, organic$Work_category))

#########Interactions###############################
#PM1 + PM2 + PM5+ TotalSI + TotalCNS are sigificant from EDA

#may be
ggplot(organic,aes(x=PM1, y=PM2)) +
  geom_point() +
  geom_smooth(method="lm",col="red3") + theme_classic() +
  labs(x="Newspaper",y="Magazine") +
  facet_wrap( ~ GC_cat) + 
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

ggplot(organic,aes(x=PM1, y=PM5)) +
  geom_point() +
  geom_smooth(method="lm",col="red3") + theme_classic() +
  labs(x="Newspaper",y="Magazine") +
  facet_wrap( ~ GC_cat) + 
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

#include
ggplot(organic,aes(x=PM1, y=TotalSI)) +
  geom_point() +
  geom_smooth(method="lm",col="red3") + theme_classic() +
  labs(x="Newspaper",y="Social Influence") +
  facet_wrap( ~ GC_cat) + 
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

#include
ggplot(organic,aes(x=PM1, y=TotalCNS)) +
  geom_point() +
  geom_smooth(method="lm",col="red3") + theme_classic() +
  labs(x="Newspaper",y="Novelty Seeking") +
  facet_wrap( ~ GC_cat) + 
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

ggplot(organic,aes(x=GC_cat, y=PM1, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  theme_classic() + theme(legend.position="none") +
  facet_wrap( ~ Age) +
  labs(title="GC vs Newspaper by Age groups",x="GC",y="Newspaper") +
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

#include
ggplot(organic,aes(x=GC_cat, y=PM1, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  theme_classic() + theme(legend.position="none") +
  facet_wrap( ~ Education) +
  labs(title="GC vs Newspaper by Age groups",x="GC",y="Newspaper") +
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

#may be
ggplot(organic,aes(x=PM2, y=PM5)) +
  geom_point() +
  geom_smooth(method="lm",col="red3") + theme_classic() +
  labs(x="Magazine",y="Social Influence") +
  facet_wrap( ~ GC_cat) + 
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

#include
ggplot(organic,aes(x=PM2, y=TotalSI)) +
  geom_point() +
  geom_smooth(method="lm",col="red3") + theme_classic() +
  labs(x="Magazine",y="Social Influence") +
  facet_wrap( ~ GC_cat) + 
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

#include
ggplot(organic,aes(x=PM2, y=TotalCNS)) +
  geom_point() +
  geom_smooth(method="lm",col="red3") + theme_classic() +
  labs(x="Magazine",y="Novelty Seeking") +
  facet_wrap( ~ GC_cat) + 
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))


ggplot(organic,aes(x=GC_cat, y=PM2, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  labs(x="Green Consumption Category",y="Newspaper") + 
  theme_classic() + theme(legend.position="none") +
  facet_wrap( ~ Age) +
  labs(title="GC vs Magazine by Age",x="GC",y="Magazine") +
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

#include
ggplot(organic,aes(x=GC_cat, y=PM2, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  labs(x="Green Consumption Category",y="Newspaper") + 
  theme_classic() + theme(legend.position="none") +
  facet_wrap( ~ Education) +
  labs(title="GC vs Magazine by Age",x="GC",y="Magazine") +
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

ggplot(organic,aes(x=PM5, y=TotalSI)) +
  geom_point() +
  geom_smooth(method="lm",col="red3") + theme_classic() +
  labs(x="Magazine",y="Social Influence") +
  facet_wrap( ~ GC_cat) + 
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

#include
ggplot(organic,aes(x=PM5, y=TotalCNS)) +
  geom_point() +
  geom_smooth(method="lm",col="red3") + theme_classic() +
  labs(x="Magazine",y="Novelty Seeking") +
  facet_wrap( ~ GC_cat) + 
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))


ggplot(organic,aes(x=GC_cat, y=PM5, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  labs(x="Green Consumption Category",y="Newspaper") + 
  theme_classic() + theme(legend.position="none") +
  facet_wrap( ~ Age) +
  labs(title="GC vs Magazine by Age",x="GC",y="Magazine") +
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

#include
ggplot(organic,aes(x=GC_cat, y=PM5, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  labs(x="Green Consumption Category",y="Newspaper") + 
  theme_classic() + theme(legend.position="none") +
  facet_wrap( ~ Education) +
  labs(title="GC vs Magazine by Age",x="GC",y="Magazine") +
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

ggplot(organic,aes(x=TotalSI, y=TotalCNS)) +
  geom_point() +
  geom_smooth(method="lm",col="red3") + theme_classic() +
  labs(x="Social Influence",y="Novelty Seeking") +
  facet_wrap( ~ GC_cat) + 
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

ggplot(organic,aes(x=GC_cat, y=TotalSI, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  theme_classic() + theme(legend.position="none") +
  facet_wrap( ~ Age) +
  labs(title="GC vs Social Media by Age",x="GC",y="Social Influence") +
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

#include
ggplot(organic,aes(x=GC_cat, y=TotalSI, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  theme_classic() + theme(legend.position="none") +
  facet_wrap( ~ Education) +
  labs(title="GC vs Social Media by Age",x="GC",y="Social Influence") +
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

ggplot(organic,aes(x=GC_cat, y=TotalCNS, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  theme_classic() + theme(legend.position="none") +
  facet_wrap( ~ Age) +
  labs(title="GC vs Social Media by Age",x="GC",y="Novelty") +
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

ggplot(organic,aes(x=GC_cat, y=TotalCNS, fill=GC_cat)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Greens") +
  theme_classic() + theme(legend.position="none") +
  facet_wrap( ~ Education) +
  labs(title="GC vs Social Media by Age",x="GC",y="Novelty") +
  theme(plot.title = element_text(size=20, face="bold", hjust = 0.5)) +
  theme(axis.title.y = element_text(size = rel(1.5), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.5), angle = 0))

#may be
for (i in c("Low", "Medium", "High")) {
  table(organic[organic$GC_cat == i,c("Age", "Education")])
  prob_table <-apply(table(organic[organic$GC_cat == i,c("Age", "Education")])/sum(table(organic[,c("Age", "Education")])),
                     2,function(x) x/sum(x))
  print(i)
  print(prob_table)
}

####Center all continuous variables for model
organic$TotalSI <- organic$TotalSI - mean(organic$TotalSI)
organic$TotalEC <- organic$TotalEC - mean(organic$TotalEC)
organic$TotalCNS <- organic$TotalCNS - mean(organic$TotalCNS)
organic$PM1 <- organic$PM1 - mean(organic$PM1)
organic$PM2 <- organic$PM2 - mean(organic$PM2)
organic$PM3 <- organic$PM3 - mean(organic$PM3)
organic$PM4 <- organic$PM4 - mean(organic$PM4)
organic$PM5 <- organic$PM5 - mean(organic$PM5)





################Model development########################
model1 <- multinom(GC_cat ~ Age + Gender + Marital_status + Education +
                     Ethnicity + No_household + Income + TotalSI +
                     TotalCNS + PM1 + PM2 +
                     PM3 + PM4 + PM5, data=organic)
summary(model1)
exp(coef(model1))

confint(model1)
exp(confint(model1))

######Variables selection in model###################################
model_noAge <- multinom(GC_cat ~ Gender + Marital_status + Education +
                          Ethnicity + No_household + Income + TotalSI +
                          TotalCNS + PM1 + PM2 +
                          PM3 + PM4 + PM5, data=organic)
anova(model1, model_noAge, test = "Chisq")

model_nogender <- multinom(GC_cat ~ Age + Marital_status + Education +
                             Ethnicity + No_household + Income + TotalSI +
                             TotalCNS + PM1 + PM2 +
                             PM3 + PM4 + PM5, data=organic)
anova(model1, model_nogender, test = "Chisq")

model_nomarital <- multinom(GC_cat ~ Age + Gender + Education +
                              Ethnicity + No_household + Income + TotalSI +
                              TotalCNS + PM1 + PM2 +
                              PM3 + PM4 + PM5, data=organic)
anova(model1, model_nomarital, test = "Chisq")

model_noEduc <- multinom(GC_cat ~ Age + Gender + Marital_status +
                           Ethnicity + No_household + Income + TotalSI +
                           TotalCNS + PM1 + PM2 +
                           PM3 + PM4 + PM5, data=organic)
anova(model1, model_noEduc, test = "Chisq")

model_noEthnicity <- multinom(GC_cat ~ Age + Gender + Marital_status + Education +
                                No_household + Income + TotalSI +
                                TotalCNS + PM1 + PM2 +
                                PM3 + PM4 + PM5, data=organic)
anova(model1, model_noEthnicity, test = "Chisq")
#===>Significant

model_noHosue <- multinom(GC_cat ~ Age + Gender + Marital_status + Education +
                            Ethnicity + Income + TotalSI +
                            TotalCNS + PM1 + PM2 +
                            PM3 + PM4 + PM5, data=organic)
anova(model1, model_noHosue, test = "Chisq")
#===>Significant

model_noIncome <- multinom(GC_cat ~ Age + Gender + Marital_status + Education +
                             Ethnicity + No_household + TotalSI +
                             TotalCNS + PM1 + PM2 +
                             PM3 + PM4 + PM5, data=organic)
anova(model1, model_noIncome, test = "Chisq")

model_noSI <- multinom(GC_cat ~ Age + Gender + Marital_status + Education +
                         Ethnicity + No_household + Income +
                         TotalCNS + PM1 + PM2 +
                         PM3 + PM4 + PM5, data=organic)
anova(model1, model_noSI, test = "Chisq")
#significant

model_noCNS <- multinom(GC_cat ~ Age + Gender + Marital_status + Education +
                          Ethnicity + No_household + Income + TotalSI +
                          PM1 + PM2 +
                          PM3 + PM4 + PM5, data=organic)
anova(model1, model_noCNS, test = "Chisq")
#=>Significant

model_noPM1 <- multinom(GC_cat ~ Age + Gender + Marital_status + Education +
                          Ethnicity + No_household + Income + TotalSI +
                          TotalCNS + PM2 +
                          PM3 + PM4 + PM5, data=organic)
anova(model1, model_noPM1, test = "Chisq")

model_noPM2 <- multinom(GC_cat ~ Age + Gender + Marital_status + Education +
                          Ethnicity + No_household + Income + TotalSI +
                          TotalCNS + PM1 +
                          PM3 + PM4 + PM5, data=organic)
anova(model1, model_noPM2, test = "Chisq")

model_noPM3 <- multinom(GC_cat ~ Age + Gender + Marital_status + Education +
                          Ethnicity + No_household + Income + TotalSI +
                          TotalCNS + PM1 + PM2 +
                          PM4 + PM5, data=organic)
anova(model1, model_noPM3, test = "Chisq")

model_noPM4 <- multinom(GC_cat ~ Age + Gender + Marital_status + Education +
                          Ethnicity + No_household + Income + TotalSI +
                          TotalCNS + PM1 + PM2 +
                          PM3 + PM5, data=organic)
anova(model1, model_noPM4, test = "Chisq")
#significant

model_noPM5 <- multinom(GC_cat ~ Age + Gender + Marital_status + Education +
                          Ethnicity + No_household + Income + TotalSI +
                          TotalCNS + PM1 + PM2 +
                          PM3 + PM4, data=organic)
anova(model1, model_noPM5, test = "Chisq")
#significant

#Ethnicity, No_household, TotalSI, TotalCNS, PM4, PM5
#####################################################

####Build Model using chi-square tests################
model_dev <- multinom(formula = GC_cat ~ Age + Education + TotalCNS + No_household + 
                        Ethnicity + TotalSI + PM4 + PM5, data = organic)
anova(model1, model_dev, test="Chisq")
#=>model_dev is better

model_chiint <- multinom(GC_cat ~ Age + Education + TotalCNS + No_household + 
                           Ethnicity + TotalSI + PM4 + PM5 + Age:Education +
                           Age:TotalCNS + Age:No_household + Age:Ethnicity +
                           Age:TotalSI + Age:PM4 + Age:PM5 +
                           Education:TotalCNS + Education:No_household +
                           Education:Ethnicity + Education:TotalSI +
                           Education:PM4 + Education:PM5 + TotalCNS:No_household +
                           TotalCNS:Ethnicity + TotalCNS:TotalSI + TotalCNS:PM4 +
                           TotalCNS:PM5 + No_household:Ethnicity + No_household:TotalSI +
                           No_household:PM4 + No_household:PM5 +
                           Ethnicity:TotalSI + Ethnicity:PM4 + Ethnicity:PM5 +
                           TotalSI:PM4 + TotalSI:PM5 + PM4:PM5, data = organic)

# AIC
NullModel <- multinom(GC_cat~1,data=organic) 
FullModel <- model_chiint
aic <- step(NullModel, scope = formula(FullModel),direction="both",trace=0) 
aic$call 

results1 <- multinom(formula = GC_cat ~ Age + Education + TotalCNS + No_household + Ethnicity + 
                       PM5 + PM4 + TotalCNS:PM5 + No_household:PM5 + TotalCNS:PM4, data = organic)

anova(model_dev, results1, test = "Chisq")
#less p-value, results1 is better

#test for interactions from EDA
model_eda <- multinom(formula = GC_cat ~ Age + Education + TotalCNS + No_household + 
                        Ethnicity + TotalSI + PM4 + PM5 + Age:Education +
                        Age:TotalCNS + Age:No_household + Age:Ethnicity +
                        Age:TotalSI + Age:PM4 + Age:PM5 +
                        Education:TotalCNS + Education:No_household +
                        Education:Ethnicity + Education:TotalSI +
                        Education:PM4 + Education:PM5 + TotalCNS:No_household +
                        TotalCNS:Ethnicity + TotalCNS:TotalSI + TotalCNS:PM4 +
                        TotalCNS:PM5 + No_household:Ethnicity + No_household:TotalSI +
                        No_household:PM4 + No_household:PM5 +
                        Ethnicity:TotalSI + Ethnicity:PM4 + Ethnicity:PM5 +
                        TotalSI:PM4 + TotalSI:PM5 + PM4:PM5 + PM1:PM2 + 
                        PM2:PM5 + PM2:TotalSI + PM2:TotalCNS + PM2:Education, data=organic)

NullModel <- multinom(GC_cat~1,data=organic) 
FullModel <- model_eda
aic <- step(NullModel, scope = formula(FullModel),direction="forward",trace=0) 
aic$call 

result2 <- multinom(formula = GC_cat ~ Age + Education + TotalCNS + No_household + Ethnicity + 
                      PM5 + PM4 + TotalCNS:PM5 + No_household:PM5 + TotalCNS:PM4, data = organic)
anova(results1, result2, test = "Chisq")
#large p-value
#results1 is the final model

final <- results1
confint(final)

output <- summary(final)
z_value <- output$coefficients/output$standard.errors
p_value <- (1 - pnorm(abs(z_value), 0, 1))*2 
#we are using two-tailed z test, that is, a normal approximation
full_summary1 <- lapply(c("Medium","High"),function(x) rbind(output$coefficients[as.character(x),],
                                                             output$standard.errors[as.character(x),],
                                                             z_value[as.character(x),],
                                                             p_value[as.character(x),]))
kable(lapply(full_summary1,function(x) {rownames(x) <- c("Coefficients","Std. Errors","z_value","p_value"); x}))




###### Predictions
#predicted probabilities for cases in the model
predprobs <- fitted(final) 
#look at first five rows just to see what results
predprobs[1:5,]

#let's get predicted probabilities for someone at average values of continuous predictors and in site 1
newdata <- organic[1:2,]
newdata$TotalSI <- 0
newdata$TotalEC <- 0
newdata$TotalCNS <- 0
newdata$Ethnicity[1] <- "Malaysian"
newdata$Ethnicity[2] <- "Others"
newdata$PM1 <- 3
newdata$PM2 <- 0
newdata$PM3 <- 0
newdata$PM4 <- 4
newdata$PM5 <- 5
newdata$Education <- "PHD/Master Degree"
newdata

predict(final, newdata, type = "probs")
#Low     Medium       High
#1 0.21469046 0.75371707 0.03159248
#2 0.09390183 0.07836696 0.82773121

newdata <- organic[1:2,]
newdata$Ethnicity <- "Others"
newdata$Gender <- "Male"
newdata$TotalSI <- 0
newdata$TotalEC <- 0
newdata$TotalPBC <- 0
newdata$TotalCNS <- 0
newdata$PM1 <- 0
newdata$PM2 <- 0
newdata$PM5[1] <- 1
newdata$PM5[2] <- 5
newdata

predict(final, newdata, type = "probs")
#         Low     Medium       High

#1 0.18474284 0.73337791 0.08187925
#2 0.03509655 0.03311982 0.93178363

###############Residual Diagnostics#######################
rawresid1 <- (organic$GC_cat == "Low") -  predprobs[,1]
rawresid2 <- (organic$GC_cat == "Medium") -  predprobs[,2]
rawresid3 <- (organic$GC_cat == "High") -  predprobs[,3]

par(mfcol = c(2,2))
binnedplot(organic$TotalSI, rawresid1, xlab = "Social Influence", ylab = "Raw residuals", main = "Binned plot: Green Consumption = Low")
binnedplot(organic$TotalSI, rawresid2, xlab = "Social Influence", ylab = "Raw residuals", main = "Binned plot: Green Consumption = Medium")
binnedplot(organic$TotalSI, rawresid3, xlab = "Social Influence", ylab = "Raw residuals", main = "Binned plot: Green Consumption = High")

par(mfcol = c(1,1,1,1))
par(mar=c(1,1,1,1))

binnedplot(organic$TotalCNS, rawresid1, xlab = "Total CNS", ylab = "Raw residuals", main = "Binned plot: Green Consumption = Low")
binnedplot(organic$TotalCNS, rawresid2, xlab = "Total CNS", ylab = "Raw residuals", main = "Binned plot: Green Consumption = Medium")
binnedplot(organic$TotalCNS, rawresid3, xlab = "Total CNS", ylab = "Raw residuals", main = "Binned plot: Green Consumption = High")


#Residuals for Factor Variables
tapply(rawresid1, organic$Ethnicity, mean)
tapply(rawresid2, organic$Ethnicity, mean)
tapply(rawresid3, organic$Ethnicity, mean)

tapply(rawresid1, organic$No_household, mean)
tapply(rawresid2, organic$No_household, mean)
tapply(rawresid3, organic$No_household, mean)


## Accuracy
pred_classes <- predict(final)
Conf_mat <- confusionMatrix(as.factor(pred_classes),as.factor(organic$GC_cat))
Conf_mat$table
Conf_mat$overall["Accuracy"];
Conf_mat$byClass[,c("Sensitivity","Specificity")]

## Individual ROC curves for the different levels
#here we basically treat each level as a standalone level
par(mfcol = c(2,2))
roc((organic$GC_cat=="Low"),predprobs[,1],plot=T,print.thres="best",legacy.axes=T,print.auc =T,
    col="#FFC000",percent=T,main="Low")
roc((organic$GC_cat=="Medium"),predprobs[,2],plot=T,print.thres="best",legacy.axes=T,print.auc =T,
    col="#ED7D31",percent=T,main="Medium")
roc((organic$GC_cat=="High"),predprobs[,2],plot=T,print.thres="best",legacy.axes=T,print.auc =T,
    col="#70AD47",percent=T,main="High")




#For every unit scale increase in the usage on social media, the odds of 
#exhibiting medium GCB versus low GCB are exp (0.268 + -0.090) = 1.19 times higher 
#for someone who increases his/her 
#novelty seeking behaviour by a scale.


#For someone who is of non-Malaysian ethnicty, 
#the odds of exhibiting medium GCB versus low GCB are exp(0.1228765) = 1.13 times higher (95% CI: 6.3 to 55.0) 
#than the corresponding odds for someone who is of Malaysian ethnicity

library(car)
vif(final)
