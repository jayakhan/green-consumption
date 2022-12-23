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

![Alt text](22_assets/novelty.jpg?raw=true "Novelty Seeking Behavior")
![Alt text](22_assets/social_media.jpg?raw=true "Preference for Social Media")

Third, we looked at interactions among these predictors. Since we were also interested in age and education, we included these variables too in the interactions. We noticed a strong interaction between newspaper and magazine, newspaper and social influence, newspaper and novelty seeking, newspaper and education, magazine and social media, magazine and social influence, magazine and novelty seeking, magazine and education, social influence and education, and social media and education. 

![Alt text](22_assets/int1.jpg?raw=true "Social Influence vs Preference for Newspaper ")
![Alt text](22_assets/int2.jpg?raw=true "Preference for Social Media vs Education")

Last, we mean centered continuous variables in the dataset for smooth interpretation of the model coefficients.

### 3. Model Building
We started with fitting a proportional odds model using all predictors but no interactions. Then we ran multiple deviance tests, one at a time, to compare this model with a similar model but without a one specific predictor. From these tests, we found novelty seeking, social influence, number of households, ethnicity, newspaper, radio, and social media as statistically significant predictors. We then fitted second model using these significant predictors, along with age and education, but without interaction. Running a chi-square anova test on both models returned large p-value (0.60), indicating insignificance of additional predictors in the first model.

To test the significance of interactions, we then fitted third model using all predictors from second model and interactions among them. To select only the statistically significant interactions, we then ran both stepwise and forward aic test on third model. When compared the model returned by aic test (along with age and education variables) and second model (best model so far) via chi-square anova test, we found low p-value (0.01). This indicated the significance of interactions in third model. This allowed us to finalize the third model.

In addition to proportional odds model, we tried fitting a multinomial model using the same steps and approach used in building proportional odds model. Even though the accuracy of both proportional odds and multinomial models were same (68%), we went with proportional odds model because we wanted to incorporate low residuals and smooth interpretation in the final model. Consequently, we went with below proportional odds model as our final model:

![Alt text](22_assets/model.jpg?raw=true "Regression Equation")

### 4. Model Assessment
After fitting the model, we first validated the predicted probabilities for observed groups using the model. For instance, for two females with similar characteristics but different ethnicity, female with Malaysian ethnicity tend to have low probability of exhibiting high green consumption behavior than the one with non-Malaysian ethnicity. 

Second, we checked the binned plot residuals against numerical variables, which are centered data for control seeking behavior. The points are all scattered randomly within the bands, except for one or two points. Since there was no trend in the residuals, linearity assumption was met.

![Alt text](22_assets/assess1.jpg?raw=true "Raw Residuals")

Last, we checked for multi-collinearity which showed VIF scores for all explanatory predictors below 10 (~1). Overall accuracy of the model is 68%. Area under the curve for all three levels are – low (85%), medium (74.7%), and high (57.2%).

![Alt text](22_assets/roc.jpg?raw=true "Area under the curve")

### 5. Results
The model shows that preference for newspaper, preference for radio, preference for social media, novelty seeking behavior, number of households, ethnicity, social influence, and interaction between social influence and newspaper and between social influence and radio are all significant with p-value less than 5%.

From the model, we noticed that individuals who prefer newspaper to other media channels tend to have 2.17 times the odds of exhibiting high green consumption (vs. low or medium) compared to individuals who do not prefer newspaper (provided there is an effect of social influence on newspaper media consumption). On the contrary, preference for radio has a reversible effect on exhibiting high green consumption, i.e., individuals who prefer radio over other media channels are less likely to exhibit high green consumption. 

Model also shows an interaction of social media with novelty seeking behavior, but it is not significant at 5% level. Interestingly, it gets significant at 10% level, which allows us to answer the influence of social media on green consumption. At the 90% confidence interval, for someone who prefers social media and seeks novelty in its products tend to have odds of exhibiting high green consumption (vs. low or medium) in the range of 2.02 to 2.76 (on odds ratio scale: exp (0.103) + exp (-0.095), exp (0.569) + exp (-0.006)) times compared to someone who doesn’t not prefer social media and doesn’t seek novelty.

To answer second inferential questions, we couldn’t leverage age and education predictor because of its low p-value, which we identified looking at inclusion of 0 in their confidence interval both at 90 and 95% levels. Other interesting explanatory variables we discovered are ethnicity and number of households. For someone who is of non-Malaysian ethnicity tend to have 1.83 times the odds of exhibiting high green consumption (vs. low or medium) compared to someone who is of Malaysian ethnicity. Additionally, individuals who have more than 6 number of households have just 0.4 times the odds of exhibiting the high green consumption (vs. low or medium) compared to individuals who have 1-2 number of households.





