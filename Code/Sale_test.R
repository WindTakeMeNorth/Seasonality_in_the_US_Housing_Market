library(seastests)

df<-read_xlsx("data fsale_cust.xlsx",sheet = "Sheet2")
df$Month<-as.Date(df$Month)
df <- df[order(df$Month), ]
# Extract the month factor
df$mon <- factor(format(df$Month, "%m"))



model <- lm(df$`United States` ~ mon, data = df)
anova(model)


x_ts <- ts(df$`United States`, start = c(1991, 1), frequency = 12)

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
  P.value   = c("0.0002262304", "0.0001922127")
)


table1 <- nice_table(
  results_df[1:2, ],
  title = c("Table 4", "For Sale Seasonality Tests"),
  note = c(
    "For Sale data, 1991-2024."
  )
)

table1 <- width(table1, j = 1, width = 3)
table1 <- width(table1, j = 2, width = 3)
table1 <- width(table1, j = 3, width = 3)

save_as_image(table1, path = "SALE_table.svg")




??KNIT













# Ensure the data is formatted correctly
df <- df %>%
  mutate(
    Year = as.factor(year(Month)),   # Extract Year as a factor
    Month = as.factor(mon)           # Ensure Month is a factor
  )

# Perform Two-Way ANOVA
anova_two_way <- aov(`United States` ~ Month + Year, data = df)

# Display summary results
summary(anova_two_way)

# Load necessary libraries
library(dplyr)
library(broom)
library(knitr)
library(gt)
library(webshot2)  # Needed to save SVG output


anova_table <- broom::tidy(anova_two_way)
anova_table$p.value[1] <- "0.511"
anova_table$p.value[2] <-"<2e-16 ***"

# Rename columns for clarity
colnames(anova_table) <- c("Variable", "DF", "Sum Sq", "Mean Sq", "F Value", "P-Value")

# Create a nicely formatted table using nice_table
table1 <- nice_table(
  anova_table,
  title = c("Table 5", "For Sale 2-Way-ANOVA"),
  note = c("For Sale data, 1991-2024.",
           "* p < .05, ** p < .01, *** p < .001")
)

# Adjust column widths for better readability
table1 <- width(table1, j = 1, width = 2)  
table1 <- width(table1, j = 2, width = 2)  
table1 <- width(table1, j = 3, width = 3)  

# Adjust row heights for better display
table1 <- autofit(table1)
table1
# Save table as SVG
save_as_image(table1, path = "For_Sale_ANOVA_Table.svg")




bp_ts <- breakpoints(x_ts ~ 1)
summary(bp_ts)

# 手动创建一个 data.frame，列名可以自行修改
df_breakdates <- data.frame(
  m   = c("1",         "2",          "3",          "4",          "5"),
  breakdate1 = c(NA,        NA,         NA,          NA,     "1999(2)"),
  breakdate2 = c(NA,        NA,  "2004(1)",  "2004(2)",  "2004(2)"),
  breakdate3 = c("2009(2)", "2009(6)",  "2009(1)", "2009(2)",  "2009(2)"),
  breakdate4 = c(NA,        NA,         NA,         "2014(9)",  "2014(9)"),
  breakdate5 = c(NA,        "2017(9)",  "2017(10)",         "2019(9)",         "2019(9)"),
  stringsAsFactors = FALSE
)

table1 <- nice_table(
  df_breakdates,
  title = c("Table 6", "Optimal m+1 Partition (The Chow-Test)"),
  note = c("For Sale data, 1991-2024."))

table1

table1 <- width(table1, j = 1, width = 3.5)
table1 <- width(table1, j = 2, width = 1)
table1 <- width(table1, j = 3, width = 1)
table1 <- width(table1, j = 4, width = 1)
table1 <- width(table1, j = 4, width = 1)


save_as_image(table1, path = "Sales_Chow_Table.svg")
