install.packages("R2jags", lib="P:/R/win-library/3.5")
install.packages("readstata13")
install.packages("dplyr", dependencies=TRUE)
install.packages("superdiag", dependencies = TRUE)
install.packages("tidyverse")

library("R2jags", lib.loc="P:/R/win-library/3.5")
library("dplyr")
library("lattice")
library("readstata13")
library(superdiag)
library("tidyverse")

install.packages("devtools")
library(devtools)
install_github("easyGgplot2", "kassambara")
library(easyGgplot2)



#data
data <- read.dta13("E:/PhD 1st year/2-3 Paper2/R/practice1017_3.dta")
#newdata <- subset(data, data$RO5_2 < 21 & data$RO5_1 > 4)
#a_data <- data.frame(newdata)
#data2 <- reshape(data=a_data, varying=list(c("RO3_1", "RO3_2"), c("RO5_1", "RO5_2"), c("CL_1", "CL_2"), c("workinghours_1", "workinghours_2")),  v.names = c("SEX", "AGE", "CL", "workinghours"), timevar="wave", sep="_", idvar="IDPERSON", direction="long")

#samppling
sample <- data %>% group_by(age2)
sample2 <- sample_frac(sample, 0.05)


#graph

#g1 <- ggplot(data2, aes(x=AGE, y=CL, fill=SEX)) +
#  geom_bar(stat="identity") + facet_grid('wave') + theme_bw() 
#g2 <- g1 + scale_x_continuous(name="Age", limits=c(0, 20))
#g2



#g1 <- ggplot(data=data2, aes(x=wave, y=CL, group=IDPERSON))+geom_line(alpha=.3)
#g2 <- g1 + stat_summary(fun.y=mean, geom='line', lwd=1.5, linetype=5)
#g3 <- g2 + scale_x_discrete(breaks = 1:2, name="Wave") + scale_y_continuous("Working Hours")
#g4 <- g3+ theme_bw()
#g4



#ggplot2.histogram(data=data2, xName='CL',
#  groupName='wave', legendPosition="top",
#                  faceting=TRUE, facetingVarNames="wave",
#                facetingDirection="horizontal")






# y <-  function() { for (i in 1:51556) { for (k in 1:3) { y[i,k] <- equals(childlabour_bi[i],k) } }}


#newdata <- subset(data, data$xRO5<=15 & data$RO5<18, select=c("siblings2", "childlabour_bi","agec","agec2","sex","INCOME","land", "xINCOME") )

#parameter
params <- c("alpha", "beta","tau","sigma")

#practice
#jags.fit2 <- jags(data=sample2, inits=NULL, params, n.chains=2, n.iter=10000, n.burnin = 1000, n.thin=5, DIC=TRUE, model.file = model2, jags.module = c("glm", "dic"))


#jags parallel
jags.fit1 <- jags.parallel(data=data, inits=NULL, params, model.file=model1,  n.chains = 2,  n.thin=5,  n.iter=80000, n.burnin = 10000, DIC=TRUE, jags.module = c("glm", "dic"))


#print
print(jags.fit1)
print(jags.fit2)
print(jags.fit3)
print(jags.fit4)
traceplot(jags.fit1)

jagsfit1.mcmc <- as.mcmc(jags.fit1) 
library(lattice)
densityplot(jagsfit1.mcmc)
plot(jagsfit1.mcmc)

install.packages("mcmcplots")
library(mcmcplots)
traplot(jags.fit1,c("sigma"))
traplot(jags.fit1)

