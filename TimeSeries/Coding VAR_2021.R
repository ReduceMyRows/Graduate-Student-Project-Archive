#This code walks through the full estimation and evaluation of a Vector Autoregression (VAR) in a chronological sequence. It first loads simulated two-variable time series data and visually inspects and summarizes it, then tests whether each series is stationary by checking its integration order, since VAR models require stationary variables. It next demonstrates model misspecification by estimating a single distributed lag regression for one variable, implicitly (and incorrectly) treating the system as partially exogenous rather than jointly endogenous. After illustrating this issue, it properly estimates a VAR(2) system using the vars package, which jointly models both variables and captures their dynamic feedback structure. The script then applies the VAR framework to macroeconomic data, selecting lag length via AIC and incorporating exogenous controls to test dynamic relationships among monetary policy, inflation, and the output gap. Finally, it computes and plots impulse response functions (IRFs) to test how shocks to one variable affects the system over time, thereby evaluating the stability and properties of the estimated VAR.

#Load Packages
#require(pacman)
#New Packages alert!
pacman::p_load(tidyverse, ggplot2, tsbox, broom,
               forecast, urca, vars, patchwork,knitr)
root <- root_directory
load(paste0(root_directory,'/Data Sets/var_example.Rda'))
summary(series)
plot(series)

#our model is a 2 row equation of
## y_1,t = [ -0.3 -0.4 ] (y_1,t-1) + [-0.1 0.01] (y_1,t-2) + (e_1t)
## y_2,t = [  0.6  0.5 ] (y_2,t-1) + [-0.2 0.05] (y_2,t-2) + (e_2t)
#is it stationary?
var_data <- as.data.frame(series)
var_data$time <- 1:202
colnames(var_data) <- c('series_one','series_two','time')
s1_plot <- ggplot(var_data) + theme_bw(base_size = 18) +
  geom_line(aes(x = time, y = series_one), size = 1.25) +
  xlab('Time') + ylab('Series 1 Outcome')
s2_plot <- ggplot(var_data) + theme_bw(base_size = 18) +
  geom_line(aes(x = time, y = series_one), size = 1.25) +
  xlab('Time') + ylab('Series 2 Outcome')
(s1_plot | s2_plot)
intord(var_data$series_one)
intord(var_data$series_two)

#variables aren't exogenous so the model is mispecified
s1_lagmat <- embed(var_data$series_one,3)
s2_lagmat <- embed(var_data$series_two,3)
dist_lag_model <- lm(s1_lagmat[,1]~s1_lagmat[,2:3] + s2_lagmat[,2:3])

#equivelant to assume the DGP is 
#2 row equation of
## y_1,t = [ -0.3  0.0 ] (y_1,t-1) + [-0.1 0.00] (y_1,t-2) + (e_1t)
## y_2,t = [  0.0  0.5 ] (y_2,t-1) + [ 0.0 0.05] (y_2,t-2) + (e_2t)
summary(dist_lag_model)

#Putting a VAR together, Here is the syntax:
# VAR(y, p = 1, type = c("const", "trend", "both", "none"),
# season = NULL, exogen = NULL, lag.max = NULL,
# ic = c("AIC", "HQ", "SC", "FPE"))
## Y is matrix o endogenous variables
## p is order of lags
## type is if you want to include A constant or trend

#VARs are pretty simple in R!
first_var <- VAR(var_data[,1:2], p = 2, type = 'none')
#...
#...
#...
#... but the results are huge so let's switch to R to look at this.
  
##Loading some data to view VAR
new_var_data <- read.csv(paste0(root_directory,'/Data Sets/ffrate.csv'))
#We know this data, we used it before:
attach(new_var_data)
endogenous_variables <- cbind(diff(FFR),
                              GAP[2:nrow(new_var_data)],
                              INFL[2:nrow(new_var_data)])
colnames(endogenous_variables) <- c('dFFR','GAP','INFL')
exogenous_variables <- cbind(INFL_EXP[2:nrow(new_var_data)],
                             SPREAD[2:nrow(new_var_data)])
colnames(exogenous_variables) <- c('INFL_EXP','SPREAD')
detach(new_var_data)
summary(endogenous_variables)
summary(exogenous_variables)
second_var <- VAR(endogenous_variables, type = 'none', lag.max = 4,
                  ic = 'AIC', exogen = exogenous_variables,
                  season = 12)
third_var <- VAR(endogenous_variables, type = 'none', lag.max = 2,
                 ic = 'AIC', exogen = exogenous_variables)
#Again, the output is huge, let's look at this in R!


##Impulse Response Function (IRF)
pacman::p_load(tidyverse,ggplot2,forecast,tseries,patchwork,knitr,broom) 
load(file = paste0(root, '/Data Sets/irf_example.Rda'))
series_x <- fortify(model_one[,1])
series_y <- fortify(model_two[,2])
series_join <- merge(series_x,series_y,by = 'x')
colnames(series_join) <- c('Time','Series_X','Series_Y')
ggplot(series_join) + theme_bw(base_size = 18) +
  geom_line(aes(x = Time, y = Series_X), size = 1.25, color = 'red') +
  geom_line(aes(x = Time, y = Series_Y), size = 1.25, color = 'black') +
  ylab('Outcome') + xlab('Time')

var_model_one <- VAR(series_join[,2:3], p = 1, type = 'none')
summary(var_model_one$varresult$Series_X)
summary(var_model_one$varresult$Series_Y)

#recovering the Plot of IRF
#Syntax
# irf(x, impulse = NULL, response = NULL, n.ahead = 10,
# ortho = TRUE, cumulative = FALSE, boot = TRUE, ci = 0.95,
# runs = 100, seed = NULL, ...)
##x is the modeling data
##impulse and response specify which variables you want to shock, and view the response of
##if you want to shock the second series, you put series_2 in the impulse, and series_1 in the response, looking at the response on series_1
##n.ahead is how many steps ahead you want
##
plot(irf(x = var_model_one, impulse = 'Series_X',n.ahead = 20,
         ortho = F, runs = 1000))


#This plot shows the impulse response of the federal funds rate (ffr) to a one-standard-deviation shock in inflation (infx). The solid black line is the estimated response over time, and the red dashed lines are the 95% bootstrap confidence intervals. Key takeaways:
##Initial response: The policy rate rises following an inflation shock, indicating a contractionary monetary policy reaction.
##Peak effect: The response peaks around periods 4–6, suggesting a delayed but strong policy adjustment.
##Persistence: The effect remains positive for many periods, indicating persistence in the monetary response.
##Statistical significance: For most of the horizon, the lower confidence band stays above zero, implying the response is statistically significant at the 5% level. Around periods 8–10, the lower band approaches zero, suggesting weaker significance in that window.
##Stability: The response gradually declines and does not explode, consistent with a stable VAR system.
##Economically, this suggests that a positive inflation shock leads to a sustained increase in the policy rate, consistent with a systematic monetary reaction function.

