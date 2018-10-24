# MLM PRESENTATION

install.packages("lattice")
install.packages("dplyr")
install.packages("foreign")
install.packages("lme4")
install.packages("ggplot2")
install.packages("mice")
install.packages("HLMdiag")
install.packages("GGally")
install.packages("gmodels")
install.packages("texreg")
install.packages("xtable")
install.packages("MuMIn")
install.packages("sjPlot")

#install packages

library("lattice")
library("dplyr")
library("foreign")
library("lme4")
library("ggplot2")
library("mice")
library("HLMdiag")
library("GGally")
library("gmodels")
library(haven)
library("texreg")
library("xtable")
library("MuMIn")
library("sjPlot")
#run packages 

data2 <- read_dta("E:/PhD 1st year/2-3 Paper2/R/practice1022.dta")
newdata1 <- subset(data2, agerank2!=1)
data_full <- tbl_df(newdata1)

newdata2 <- subset(data2, data2$total_hours2>=43)
data_full2 <- tbl_df(newdata2)
#make data a dplyr object


lm0 <- lmer(total_hours2 ~ 1 + (1 | DISTRICT) + (1 | STATEID), weights=WT, data = data_full)
lm1 <- lmer(total_hours2 ~ 1 + sex + agec2 + agecsq2 + agerank2 + ruralurban2 + income2 + land2 + numsibling2 + factor(socialgroup) + femheadedhh2 + (1 |DISTRICT) + (1 | STATEID), weights=WT, data = data_full)
lm2 <- lmer(total_hours2 ~ 1 + sex + agec2 + agecsq2 + agerank2 + ruralurban2 + income2 + land2 + numsibling2 + factor(socialgroup) + femheadedhh2 + firstworkinghours + xfirstworkinghours + (1 |DISTRICT) + (1 | STATEID) , weights=WT, data = data_full)
lm3 <- lmer(total_hours2 ~ 1 + sex + agec2 + agecsq2 + agerank2 + ruralurban2 + income2 + land2 + numsibling2 + factor(socialgroup) + femheadedhh2 + firstworkinghours + xfirstworkinghours + firstgender + (1 |DISTRICT) + (1 | STATEID), weights = WT, data = data_full)
lm4 <- lmer(total_hours2 ~ 1 + sex + agec2 + agecsq2 + agerank2 + ruralurban2 + income2 + land2 + numsibling2 + factor(socialgroup) + femheadedhh2 + firstworkinghours + xfirstworkinghours  + firstgender + firstworkinghours*firstgender + (1|DISTRICT) + (1| STATEID), weights=WT, data = data_full)

r.squaredGLMM(lm0)
r.squaredGLMM(lm1)
r.squaredGLMM(lm2)
r.squaredGLMM(lm3)
r.squaredGLMM(lm4)

library("lme4")
install.packages("languageR")
library("languageR")
pvals.fnc(lm4)

texreg(list(lm1, lm2, lm3, lm4, lm5))
qqmath(ranef(lm4, condVar = TRUE))