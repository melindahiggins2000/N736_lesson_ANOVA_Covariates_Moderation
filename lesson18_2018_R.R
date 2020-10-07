# =====================================
# N736: LESSON 18 - Analysis of Covariance (ANCOVA)
# and interactions - testing moderators
#
# dated 11/02/2018
# Melinda Higgins, PhD.
#
# =====================================

library(tidyverse)
library(haven)

help1 <- haven::read_spss("helpmkh.sav")

# =====================================
# select the variables we want for 
# this lesson: 
# DV: mcs
# IV: female
# CV: pcs
#
# let's also recode female to male
# by flipping the 0,1
# and let's also compute the interaction
# terms between pcs and female
# and between pcs and male
# =====================================

help2 <- help1 %>%
  select(mcs, pcs, female) %>%
  mutate(male = as.numeric((female==0)),
         pcs_x_female = pcs * female,
         pcs_x_male = pcs * male)

# regression approach - females=1
lm1 <- lm(mcs ~ female, data=help2)
summary(lm1)
coef(lm1)

# save model stats
summary.lm1 <- summary(lm1)

# look at model stats and other output
summary.lm1$r.squared
summary.lm1$adj.r.squared
hist(summary.lm1$residuals)

# regression approach - males=1
lm1m <- lm(mcs ~ male, data=help2)
summary(lm1m)
coef(lm1m)

# ANOVA approach
aov1 <- aov(mcs ~ female, data=help2)
summary(aov1)
coef(aov1)

# steps of regression
lm2 <- lm(mcs ~ pcs, data=help2)
summary(lm2)
lm3 <- lm(mcs ~ pcs + female, data=help2)
summary(lm3)

# compare models
anova(lm2,lm3)

# r2 change
summary(lm3)$r.squared - summary(lm2)$r.squared

# run as ANCOVA
aov2 <- aov(mcs ~ pcs + female, data=help2)
summary(aov2)
coef(aov2)

# get type III SS
library(car)
car::Anova(aov2, type=3)

# add interaction effects
# test if gender moderates the 
# association between pcs and mcs
lm4 <- lm(mcs ~ pcs + female + pcs_x_female, data=help2)
summary(lm4)

# can also compute interaction on fly
# using the : notation in R
lm5 <- lm(mcs ~ pcs + female + pcs:female, data=help2)
summary(lm5)

# to get p-values of r2 change
# works for "nested" models
anova(lm2,lm3,lm4)

# r2 change
summary(lm3)$r.squared - summary(lm2)$r.squared
summary(lm4)$r.squared - summary(lm3)$r.squared

# other ways to get "effects" plots and terms

# create "factor" class type for female
# this is so the effects package
# function will work correctly
help2$female.f <- factor(help2$female,
                         levels = c(0,1),
                         labels = c("male","female"))

# options with olsrr
library(olsrr)
m1 <- lm(mcs ~ pcs * female.f, data=help2)
summary(m1)
ols_regress(m1)

library(effects)
plot(allEffects(m1))

# another way to get
# the interaction plot
plot(effect("pcs:female.f", m1, 
            xlevels=list()),
     multiline=TRUE, ylab="mcs", rug=FALSE)

# install sjPlot package
# library(devtools)
# devtools::install_github("strengejacke/sjPlot")

# another option to sjPlot package
library(sjPlot)

# learn more at http://www.strengejacke.de/sjPlot/reference/plot_model.html
# put female as second term to get
# interaction plot with lines by gender
m3f <- lm(mcs ~ pcs * female, data=help2)
plot_model(m3f, type="int",
           show.ci=TRUE,
           facet.grid=TRUE)

