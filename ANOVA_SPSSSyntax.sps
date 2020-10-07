* Encoding: UTF-8.
* ==================================.
* LESSON on ANOVA
* last updated 10/07/2020
* by Melinda Higgins, PhD
* ==================================.

* This SYNTAX assumes you are working with
* The HELP Dataset "helpmkh.sav"

GET 
  FILE='C:\MyGithub\N736_lesson_ANOVA_Covariates_Moderation\helpmkh.sav'. 
DATASET NAME DataSet1 WINDOW=FRONT.

FREQUENCIES VARIABLES=cesd racegrp female
  /NTILES=4 
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN 
  /HISTOGRAM 
  /ORDER=ANALYSIS.

* plot of cesd by racegrp.

GRAPH 
  /ERRORBAR(CI 95)=cesd BY racegrp.

* also look at error bars using standard deviation.

GRAPH
  /ERRORBAR(STDDEV 1)=cesd BY racegrp.

* ANOVA.
* /analyze/compare means/one-way anova.

ONEWAY cesd BY racegrp 
  /STATISTICS DESCRIPTIVES EFFECTS HOMOGENEITY BROWNFORSYTHE WELCH 
  /PLOT MEANS 
  /MISSING ANALYSIS 
  /POSTHOC=LSD SIDAK ALPHA(0.05).

* WE GET AN ERROR - need to convert
* racegrp into a numerically coded "factor".

AUTORECODE VARIABLES=racegrp 
  /INTO racenum
  /PRINT.

ONEWAY cesd BY racenum 
  /STATISTICS DESCRIPTIVES EFFECTS HOMOGENEITY BROWNFORSYTHE WELCH 
  /PLOT MEANS 
  /MISSING ANALYSIS 
  /POSTHOC=LSD SIDAK ALPHA(0.05).

* another approach
* /analyze/general linear model/univariate.
* this works with the "string" racegrp variable.

UNIANOVA cesd BY racegrp
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /POSTHOC=racegrp(BONFERRONI SIDAK) 
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(racegrp) 
  /PRINT=ETASQ DESCRIPTIVE PARAMETER HOMOGENEITY
  /CRITERIA=ALPHA(.05)
  /DESIGN=racegrp.

* another way to get ANOVA
*/analyze/compare means/means.
* this also works.

MEANS TABLES=cesd BY racegrp
  /CELLS=MEAN COUNT STDDEV
  /STATISTICS ANOVA LINEARITY.

* and can use GLM
* /analyze/generalized linear models/generalized linear models.

* Generalized Linear Models.
GENLIN cesd BY racegrp (ORDER=ASCENDING)
  /MODEL racegrp INTERCEPT=YES
 DISTRIBUTION=NORMAL LINK=IDENTITY
  /CRITERIA SCALE=MLE COVB=MODEL PCONVERGE=1E-006(ABSOLUTE) SINGULAR=1E-012 ANALYSISTYPE=3(WALD) 
    CILEVEL=95 CITYPE=WALD LIKELIHOOD=FULL
  /EMMEANS TABLES=racegrp SCALE=ORIGINAL COMPARE=racegrp CONTRAST=PAIRWISE PADJUST=LSD
  /MISSING CLASSMISSING=EXCLUDE
  /PRINT CPS DESCRIPTIVES MODELINFO FIT SUMMARY SOLUTION.




