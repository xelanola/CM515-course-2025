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

Mind looks like:

<img src="webContent/Screenshot 2025-02-05 at 8.32.43 AM.png" width="600">



```r
# Another way of plotting
boxplot(Period_Life_Expectancy ~ Year, data = lifeExp)
```

⚠️ **Best Practices** Look at your data. What are you seeing? Are there points that don't make sense? Go back and look more closely at any "bumps", "outliers", "funky trends"

⚠️ **Best Practices** 

## Exporting Plot

To save a plot, we have two options:

  1. We can simply use the **Export** menu item on the top of the Plots panel. 

➡️ Export your plot as a .pdf...

<img src="webContent/Screen Shot 2023-01-25 at 8.48.24 AM.png" width="500">

➡️ Specify the width and height of the output image. Give it a name. Save it in a location that makes sense. You may need to play around with the width/height until the plot looks nice...

<img src="webContent/Screen Shot 2023-01-25 at 8.48.40 AM.png" width="500">

  2. We can use commands. 
  
Place the plotting commands between the `pdf()` command and the `dev.off()` command. 

  * `pdf()` will start "recording" what you plot into a specified file of specified dimensions.
  * `dev.off()` will "stop recording".
  * Sometimes we do need two dev.off() calls to return to the Rstudio plot output
  
➡️ Example: 

```r

pdf(file = "240131_Rplot_vacc.pdf", width = 8, height = 8 )

# Let's plot it!
plot(xVacc, yBoost)

# Let's add some labels
text(xVacc, yBoost, rownames(VaxByState),col='darkblue', pos = 4, cex = 0.8)

dev.off()

```

  * By default, your plot will save to the working directory. 
  * .pdf output can be modified as a vector graphic in Adobe Illustrator
  * Some text doesn't render properly - you'll need to edit plots
