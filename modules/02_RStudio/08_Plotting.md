# Plotting Data 


The following is an example of what you can do with your data. This is just a simple demonstration. You'll build these skills progressively over the next weeks.



```r
# Calculate the mean Lifespan per year across all countries
lifeExp_byYear <- lifeExp %>%
  group_by(Year) %>%
  summarise(mean = mean(Period_Life_Expectancy, rm.na = TRUE) )
  
# Plot the LifeSpan for each year
plot(lifeExp_byYear, 
     ylim = c(0,80),
     main = "Period of Life Expectancy (in years) at birth, in a give year",
     ylab = "Life Expectancy (yr)", 
     xlab = "Year", 
     col = "grey", 
     pch=20 )

# Smooth the plot
lo10 <- loess(mean ~ Year, data=lifeExp_byYear, span=0.10)
smoothed10 <- predict(lo10) 

# Add the smoothed trendline
points(lifeExp_byYear$Year, 
       smoothed10, 
       col = "darkorange", 
       type = "l", 
       lwd = 2)

```

Compare your plot with the one generated in [Our World in Data](https://ourworldindata.org/data-insights/global-average-life-expectancy-has-more-than-doubled-since-1900)


