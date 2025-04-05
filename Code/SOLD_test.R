df<-read_xlsx("data sold_cust.xlsx",na="(NA)",sheet = "Sheet2")
df$Month<-as.Date(df$Month)

# 数据划分
df1<-melt(df,id.vars = "Month")
df1 <- df1[df1$variable == "United States",]

df1$variable == "United States"



x_ts <- ts(df1$value, start = c(1963, 1), frequency = 12)

isSeasonal(x_ts, test = "seasdum", freq = 12)
isSeasonal(x_ts, test = "kw", freq = 12)
x_ts_decompose <- decompose(x_ts)
plot(x_ts_decompose)

fit <- seas(x_ts)
summary(fit)
plot(fit)
monthplot(fit)

kw(x_ts, freq = 12)
seasdum(x_ts, freq = 12, autoarima = FALSE)


res_kw     <- kw(x_ts, freq = 12)
res_seasdum <- seasdum(x_ts, freq = 12, autoarima = FALSE)
results_df <- data.frame(
  Test      = c("Parametric F-Test", "Nonparametric Kruskal-Wallis"),
  Statistic = c(res_seasdum$stat, res_kw$stat),
  P.value   = c(res_seasdum$Pval, res_kw$Pval)
)

kable(results_df, digits = 100, caption = "Seasonality Test Results")
results_df <- data.frame(
  Test      = c("Parametric F-Test", "Nonparametric Kruskal-Wallis"),
  Statistic = c(res_seasdum$stat, res_kw$stat),
  P.value   = c("0.000000e+00", "0.000000e+00")
)


table1 <- nice_table(
  results_df[1:2, ],
  title = c("Table 7", "Sold Seasonality Tests"),
  note = c(
    "Sold data, 1963-2024."
  )
)

table1
table1 <- width(table1, j = 1, width = 3)
table1 <- width(table1, j = 2, width = 3)
table1 <- width(table1, j = 3, width = 3)


table1# 3) Now save as SVG
save_as_image(table1, path = "Sold_table.svg")


fit <- seas(x_ts)
summary(fit)
plot(fit)


svg("Sold_X-13-ARIMA.svg", width = 10, height = 6)
monthplot(fit)
dev.off()





df1$mon <- factor(format(df1$Month, "%m"))
# Ensure the data is formatted correctly
df1 <- df1 %>%
  mutate(
    Year = as.factor(year(Month)),   # Extract Year as a factor
    Month = as.factor(mon)           # Ensure Month is a factor
  )

# Perform Two-Way ANOVA
anova_two_way <- aov(value ~ Month + Year, data = df1)

# Display summary results
summary(anova_two_way)

anova_table <- broom::tidy(anova_two_way)
anova_table$p.value[1] <- "<2e-16 ***"
anova_table$p.value[2] <-"<2e-16 ***"

# Rename columns for clarity
colnames(anova_table) <- c("Variable", "DF", "Sum Sq", "Mean Sq", "F Value", "P-Value")

# Create a nicely formatted table using nice_table
table1 <- nice_table(
  anova_table,
  title = c("Table 8", "Sold 2-Way-ANOVA"),
  note = c("Sold data, 1963-2024.",
           "* p < .05, ** p < .01, *** p < .001")
)

# Adjust column widths for better readability
table1 <- width(table1, j = 1, width = 2)  
table1 <- width(table1, j = 2, width = 2)  
table1 <- width(table1, j = 3, width = 3)  

# Save table as SVG
save_as_image(table1, path = "Sold_ANOVA_Table.svg")








seq(337,742)
df1$value





x_ts <- ts(df1$value[seq(337,742)], start = c(1991, 1), frequency = 12)
x_ts <- ts(df1$value, start = c(1963, 1), frequency = 12)
bp_ts <- breakpoints(x_ts ~ 1)
summary(bp_ts)

#####################没修改没修改没修改没修改没修改没修改没修改
df_breakdates <- data.frame(
  m   = c("1",    "2",      "3",      "4",      "5"),
  breakdate1 = c(NA, NA,  NA,   "1998(6)",   "1999(2)"),
  breakdate2 = c(NA,     "2002(11)"   ,   "2002(3)",   "2003(6)",   "2004(2)"),
  breakdate3 = c(NA,        NA,          NA,   NA,   "2009(2)"),
  breakdate4 = c(NA,        NA,      "2014(9)", "2014(9)",   "2014(9)"),
  breakdate5 = c("2018(3)", "2019(9)"    ,  "2019(9)", "2019(9)",          "2019(9)"),
  stringsAsFactors = FALSE
)
#####################没修改没修改没修改没修改没修改没修改没修改