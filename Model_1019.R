#Model
model1<- function() {

    for (i in 1:length(total_hours2)) {
      total_hours2[i] ~ dnorm(pi[i], tau) #p: probability of child labour
      pi[i] <- alpha[1]+beta[1]*sex[i] + beta[2]*agec2[i] 
      + beta[3]*agecsq2[i]  + beta[4]*agerank2[i] + beta[5]*ruralurban2[i]
      + beta[6]*income2[i] + beta[7]*land2[i] 
      + beta[8]*numsibling2[i]
      + beta[9]*socialgroup0[i]
      + beta[10]*socialgroup1[i]
      + beta[11]*socialgroup2[i] 
      + beta[12]*socialgroup3[i]
      + beta[13]*socialgroup4[i]
      + beta[14]*socialgroup5[i]


      #siblingunequal[i] ~ dnorm(mu[i],tau)
      #mu[i] <- c[1]+c[2]*agec[i] + c[3]*agec2[i] 
      #+ c[4]*sex[i]  + c[5]*INCOME[i] + c[6]*land[i] 
      
      #genderunequal[i] ~ dnorm(mu2[i],tau2)
      #mu2[i] <- d[1]+d[2]*agec[i] + d[3]*agec2[i] 
      #+ d[4]*sex[i]  + d[5]*INCOME[i] + d[6]*land[i] 
      
      }
  
      
      #  categorical? GROUPS converstion? firstgendersiblings2 
      # probit logit cloglog
      
    
    
      #beta[7,k]*land[i] + + beta[8,k]*siblings2[i]
      #lambda[i] ~ dnorm(0, tau)
      #siblings2[i] <- alpha + delta*xINCOME[i] + lambda2[i]
      #lambda2[i] ~ dnorm(0, tau2)
    
  #for( i in 1 : 38103) {   
  #n[i] <- sum(y[i,])  } 

  alpha ~ dnorm(0.0, 1.0E-6)
  
  for (j in 1:14){
    beta[j] ~ dnorm(0.0, 1.0E-6)  }
  
  # for (k in 1:6){
  #  c[k] ~ dnorm(0.0, 1.0E-6) }
    
  # for (f in 1:6){
  #  d[f] ~ dnorm(0.0, 1.0E-6) }

  tau ~ dgamma(0.001, 0.001) 
  #tau2 ~ dgamma(0.001, 0.001)
  
  
  # priors
  #alpha ~ dnorm(0.0,1.0E-6)
  #delta  ~ dnorm(0.0,1.0E-6)
  #
  sigma <- 1/sqrt(tau)
  #tau2 ~ dgamma(0.001, 0.001) 
  #sigma2 <- 1/sqrt(tau2)}
}
  