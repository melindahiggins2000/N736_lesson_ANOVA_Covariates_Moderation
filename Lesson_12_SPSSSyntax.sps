* Encoding: UTF-8.
* ==================================.
* LESSON 12 SYNTAX
* Simple Linear Regression
* And ANOVA
* last updated 10/14/2018
* by Melinda Higgins, PhD
* ==================================.

* This SYNTAX assumes you are working with
* The HELP Dataset "helpmkh.sav"

GET 
  FILE='C:\MyGithub\N736Fall2017_lesson12\helpmkh.sav'. 
DATASET NAME DataSet1 WINDOW=FRONT.

FREQUENCIES VARIABLES=indtot 
  /NTILES=4 
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN 
  /HISTOGRAM 
  /ORDER=ANALYSIS.

* try some transformations.

COMPUTE sqrt_50indtot=sqrt(50-indtot). 
EXECUTE. 
COMPUTE indtot_bl4=indtot ** 4. 
EXECUTE. 

* compare resulting variables.

FREQUENCIES VARIABLES=indtot sqrt_50indtot indtot_bl4
  /NTILES=4 
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN 
  /HISTOGRAM 
  /ORDER=ANALYSIS.

EXAMINE VARIABLES=indtot sqrt_50indtot indtot_bl4 
  /PLOT BOXPLOT HISTOGRAM NPPLOT 
  /COMPARE GROUPS 
  /STATISTICS DESCRIPTIVES 
  /CINTERVAL 95 
  /MISSING LISTWISE 
  /NOTOTAL.

* compare "linearity" of resulting
* transformed indtot.

GRAPH 
  /SCATTERPLOT(BIVAR)=cesd WITH indtot 
  /MISSING=LISTWISE.

GRAPH 
  /SCATTERPLOT(BIVAR)=cesd WITH sqrt_50indtot 
  /MISSING=LISTWISE.

GRAPH 
  /SCATTERPLOT(BIVAR)=cesd WITH indtot_bl4 
  /MISSING=LISTWISE.

* look at correlations
* notice non-parametric correlations
* for the transformed variables.

CORRELATIONS 
  /VARIABLES=cesd indtot sqrt_50indtot indtot_bl4
  /PRINT=TWOTAIL NOSIG 
  /MISSING=PAIRWISE.
NONPAR CORR 
  /VARIABLES=cesd indtot sqrt_50indtot indtot_bl4 
  /PRINT=BOTH TWOTAIL NOSIG 
  /MISSING=PAIRWISE.

* simple linear regression.

REGRESSION 
  /DESCRIPTIVES MEAN STDDEV CORR SIG N 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL CHANGE ZPP 
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT indtot 
  /METHOD=ENTER cesd 
  /PARTIALPLOT ALL 
  /RESIDUALS DURBIN HISTOGRAM(ZRESID) NORMPROB(ZRESID) 
  /CASEWISE PLOT(ZRESID) OUTLIERS(3) 
  /SAVE MAHAL COOK LEVER DFBETA DFFIT.

* look at fit statistics

FREQUENCIES VARIABLES=MAH_1 COO_1 LEV_1 DFF_1 DFB0_1 DFB1_1 
  /NTILES=4 
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN 
  /HISTOGRAM 
  /ORDER=ANALYSIS.

* look at a few plots.

GRAPH 
  /SCATTERPLOT(BIVAR)=indtot WITH MAH_1 
  /MISSING=LISTWISE.

GRAPH 
  /SCATTERPLOT(BIVAR)=indtot WITH COO_1 
  /MISSING=LISTWISE.

* run other 2 models with transformed variables.

REGRESSION 
  /DESCRIPTIVES MEAN STDDEV CORR SIG N 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) R ANOVA 
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT sqrt_50indtot 
  /METHOD=ENTER cesd 
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).

REGRESSION 
  /DESCRIPTIVES MEAN STDDEV CORR SIG N 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) R ANOVA 
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT indtot_bl4 
  /METHOD=ENTER cesd 
  /RESIDUALS HISTOGRAM(ZRESID) NORMPROB(ZRESID).

* look at PSS_fr.

FREQUENCIES VARIABLES=pss_fr 
  /NTILES=4 
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN 
  /HISTOGRAM 
  /ORDER=ANALYSIS.

* association of PSS_fr with indtot.

CORRELATIONS 
  /VARIABLES=indtot pss_fr 
  /PRINT=TWOTAIL NOSIG 
  /MISSING=PAIRWISE.
NONPAR CORR 
  /VARIABLES=indtot pss_fr 
  /PRINT=BOTH TWOTAIL NOSIG 
  /MISSING=PAIRWISE.

* break into 3 ordinal categories.
* Visual Binning. 
*pss_fr. 

RECODE  pss_fr (MISSING=COPY) (LO THRU 4=1) (LO THRU 9=2) (LO THRU HI=3) (ELSE=SYSMIS) INTO 
    pss_fr3grp. 
VARIABLE LABELS  pss_fr3grp 'Perceived Social Support - friends (Binned)'. 
FORMATS  pss_fr3grp (F5.0). 
VALUE LABELS  pss_fr3grp 1 'PSS-fr low' 2 'PSS-fr moderate' 3 'PSS-fr high'. 
VARIABLE LEVEL  pss_fr3grp (ORDINAL). 
EXECUTE. 

* plot of indtot by 3 groups of PSS_fr.

GRAPH 
  /ERRORBAR(CI 95)=indtot BY pss_fr3grp.

* ANOVA.

ONEWAY indtot BY pss_fr3grp 
  /STATISTICS DESCRIPTIVES EFFECTS HOMOGENEITY BROWNFORSYTHE WELCH 
  /PLOT MEANS 
  /MISSING ANALYSIS 
  /POSTHOC=LSD SIDAK ALPHA(0.05).








