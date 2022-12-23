# Encouraging Sustainibilty in Consumerism
Exploring factors that influence green consumption behaviour among consumers.
 
**Target Industry:** Consumer

## Abstract
This project is inspired by an idea of encouraging sustainability in consumerism. The analysis leverages the dataset of a [journal](https://www.sciencedirect.com/science/article/pii/S2352340920311963) published in 2020 on Elsevier Publications. The dataset used in the analysis is derived from the results of the questionnaire distributed to individuals, aged 18 years and above, in the high populated areas of Malaysia. We used this dataset to answer below questions via our analysis.

1. Do people who consume more media content tend to exhibit high green consumption behaviour?
2. Does the green consumption behaviour differ by age and education?
3. Are there any other factors that explain the effect on green consumption behaviour?

## Project Development Plan 
Project is developed in four parts:

### 1. Data Cleaning
After all data cleaning operations, we were left with total 375 observations and 18 variables – `preference for newspaper, preference for magazine, preference for television, preference for radio, preference for social media, gender, age, marital status, education, ethnicity, number of households, personal income, occupation, work category, social influence, consumer novelty seeking, and green consumption behavior.`

### 2. Exploratory Data Analysis
First, we changed the data type of all demographic variables into factor variables. Then we leveraged column of green consumption that contained the sum of the results of all 13 items on green consumption from questionnaire and divided it into three levels – `Low, Medium, and High`. Reponses’ results from minimum value to 44 is defined as low green consumption, 45 to 55 is defined as medium green consumption, and 56 to maximum value is defined as high green consumption. We added these newly defined values into a new column and then factored them into ordered levels (low < medium < high). After this operation, we were left with 111 observations in low level, 208 observations in medium level, and 56 observations in high level.

Second, we checked for the relationship between all predictors and outcome variable. From the exploratory data analysis, we noticed a varying trend across green consumption levels for preference for newspaper, preference for magazine, preference for social media, social influence, and novelty seeking behavior. 

Third, we looked at interactions among these predictors. Since we were also interested in age and education, we included these variables too in the interactions. We noticed a strong interaction between newspaper and magazine, newspaper and social influence, newspaper and novelty seeking, newspaper and education, magazine and social media, magazine and social influence, magazine and novelty seeking, magazine and education, social influence and education, and social media and education. 

Last, we mean centered continuous variables in the dataset for smooth interpretation of the model coefficients.







