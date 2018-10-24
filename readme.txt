cd..
p:



conda install pandas 
conda install numpy 
conda install pymc3 
conda install matplotlib 
conda install seaborn 
conda install theano
conda install mkl=2017
conda install warnings
conda install -c conda-forge pymc3




    intercept1 = pm.Normal('Intercept1', 0, sd=20)
    b0 = pm.Normal('b0', 0, sd=20)
    b1 = pm.Normal('b1', 0, sd=20)
    b2 = pm.Normal('b2', 0, sd=20)
    b3 = pm.Normal('b3', 0, sd=20)
    b4 = pm.Normal('b4', 0, sd=20)
    b5 = pm.Normal('b5', 0, sd=20)
    b6 = pm.Normal('b6', 0, sd=20)
    b7 = pm.Normal('b7', 0, sd=20)
    b8 = pm.Normal('b8', 0, sd=20)  