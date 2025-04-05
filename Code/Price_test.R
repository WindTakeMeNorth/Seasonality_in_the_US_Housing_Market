library(seastests)

df<-read_xlsx("price_cust.xlsx" ,sheet = "Monthly",col_types = c("date", "numeric", "numeric"))
df$Month <- df$Period
df$price <- df$`Median sales price`
df$Month<-as.Date(df$Month)
df$mon <- factor(format(df$Month, "%m"))
df <- head(df, -9)


model <- lm(price ~ mon, data = df)
model
anova(model)


aovtest = aov(price ~ mon,
              data = df)
knitr::kable(broom::tidy(aovtest),
             caption = "Traditional ANOVA Test")



start_year  <- 1963
start_month <- 1
x_ts <- ts(df$price, 
           start = c(start_year, start_month), 
           frequency = 12)
isSeasonal(x_ts, test = "kw", freq = 12)

x_ts_decompose <- decompose(x_ts)
plot(x_ts_decompose)


fit <- seas(x_ts)
summary(fit)
plot(fit)

monthplot(fit)

