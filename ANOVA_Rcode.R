# ===================================
# Lesson N736 - ANOVA
#
# by Melinda Higgins, PhD
# updated 10/07/2020
# ===================================

library(tidyverse)

load("help.Rdata")

# create subset
# select cesd - continuous "outcome"
# racegrp - categorical "factor"
# female - binary dichotomous coded 0, 1 numerical
#          where 0=male and 1=female

h1 <- helpdata %>%
  select(cesd, racegrp, female)

# simple plot by group
plot(cesd ~ racegrp, data=h1)

# ggplot2 approach
ggplot(h1, aes(racegrp, cesd)) +
  geom_boxplot()

# use lm() to "fit" a one-way ANOVA model
mod1 <- lm(cesd ~ racegrp, data=h1)

# summary() gives you the model
# coefficients - using default comparisons
# dummy variable coding on the fly
summary(mod1)

# anova() gives you the overall 
# group test
anova(mod1)

# another approach
aov1 <- aov(cesd ~ racegrp, data=h1)

# this gives you the main anova table
# for the group effect test
summary(aov1)

# check homogenity of variances
bartlett.test(cesd ~ racegrp, data=h1)

# another test for homogenity using car package
library(car)
leveneTest(cesd ~ racegrp, data = h1)

# if homogeity of variance fails
# anove with no assumption
# var.equal=FALSE by default
# which runs Welch's test
oneway.test(cesd ~ racegrp, data = h1)

# assuming equal variances
oneway.test(cesd ~ racegrp, data = h1,
            var.equal=TRUE)

# posthoc pairwise tests
TukeyHSD(aov1)

# another way to get pairwise group comparison
# load the emmeans package
library(emmeans)
emmeans(mod1, specs = pairwise ~ racegrp)

# see more at http://www.sthda.com/english/wiki/one-way-anova-test-in-r 


