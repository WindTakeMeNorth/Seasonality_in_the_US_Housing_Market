df<-read_xlsx("data hpi_po_monthly_hist.xlsx")
df$Month<-as.Date(df$Month)
df1<-melt(df,id.vars = "Month")

df1$Month <- as.Date(df1$Month)
df1$mon <- factor(format(df1$Month, "%m"))
df1 <- df1[df1$variable == "USA (NSA)",]




# Load necessary libraries
library(seasonal)
library(dplyr)
library(tidyr)
library(ggplot2)

# List of region columns to analyze (NSA data only)
regions <- c("East North Central (NSA)", "East South Central (NSA)", 
             "Middle Atlantic (NSA)", "Mountain (NSA)", "New England (NSA)",
             "Pacific (NSA)","South Atlantic (NSA)", "West North Central (NSA)", 
             "West South Central (NSA)", "USA (NSA)")

# Create an empty list to store results
seasonal_strength <- list()

# Apply X-13-ARIMA to each region
for (region in regions) {
  ts_data <- ts(df[[region]], start = c(1991, 1), frequency = 12)  # Convert to time series
  x13_result <- seas(ts_data)  # Apply X-13-ARIMA
  
  # Extract the seasonal component manually
  seasonally_adjusted <- final(x13_result)  # Seasonally adjusted series
  seasonal_comp <- ts_data - seasonally_adjusted  # Extract seasonality
  
  # Store the average absolute seasonal variation
  seasonal_strength[[region]] <- mean(abs(seasonal_comp), na.rm = TRUE)
}

# Convert results to a dataframe
seasonality_df <- data.frame(
  Region = names(seasonal_strength),
  Seasonality_Index = unlist(seasonal_strength)
)

# Print seasonality comparison
print(seasonality_df)
final(x13_result)
seasonal_comp
seasonal_strength



ggplot(seasonality_df, aes(x = reorder(Region, -Seasonality_Index), y = Seasonality_Index)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "Comparison of Seasonality Strength Across Regions",
       x = "Region", y = "Average Seasonal Variation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
















library(ggplot2)
library(dplyr)
library(maps)
library(gridExtra) 
library(grid)

# --------------------------
# 1. 准备数据和地图 (和你之前的一样)
# --------------------------
seasonality_df <- data.frame(
  Region = c("East North Central (NSA)", "East South Central (NSA)",
             "Middle Atlantic (NSA)", "Mountain (NSA)",
             "New England (NSA)", "Pacific (NSA)",
             "South Atlantic (NSA)", "West North Central (NSA)",
             "West South Central (NSA)", "USA (NSA)"),
  Seasonality_Index = c(1.744875, 1.035082, 1.300863, 1.688859,
                        1.622212, 1.486393, 1.107698, 1.688155,
                        1.110925, 1.408190),
  stringsAsFactors = FALSE
)

# 建立 state_region 映射表（州 -> 分区）
state_region <- data.frame(
  state = tolower(state.name),
  division = NA,
  stringsAsFactors = FALSE
)

state_region$division[state_region$state %in% tolower(c("Illinois", "Indiana", "Michigan", "Ohio", "Wisconsin"))] <- "East North Central (NSA)"
state_region$division[state_region$state %in% tolower(c("Iowa", "Kansas", "Minnesota", "Missouri", "Nebraska", "North Dakota", "South Dakota"))] <- "West North Central (NSA)"
state_region$division[state_region$state %in% tolower(c("Connecticut", "Maine", "Massachusetts", "New Hampshire", "Rhode Island", "Vermont"))] <- "New England (NSA)"
state_region$division[state_region$state %in% tolower(c("New Jersey", "New York", "Pennsylvania"))] <- "Middle Atlantic (NSA)"
state_region$division[state_region$state %in% tolower(c("Delaware", "Florida", "Georgia", "Maryland", "North Carolina", "South Carolina", "Virginia", "West Virginia"))] <- "South Atlantic (NSA)"
state_region$division[state_region$state %in% tolower(c("Alabama", "Kentucky", "Mississippi", "Tennessee"))] <- "East South Central (NSA)"
state_region$division[state_region$state %in% tolower(c("Arkansas", "Louisiana", "Oklahoma", "Texas"))] <- "West South Central (NSA)"
state_region$division[state_region$state %in% tolower(c("Arizona", "Colorado", "Idaho", "Montana", "Nevada", "New Mexico", "Utah", "Wyoming"))] <- "Mountain (NSA)"
state_region$division[state_region$state %in% tolower(c("California", "Alaska", "Hawaii", "Oregon", "Washington"))] <- "Pacific (NSA)"

state_region <- dplyr::filter(state_region, !is.na(division))

states_map <- map_data("state")
states_map <- dplyr::left_join(states_map, state_region, by = c("region" = "state"))
states_map <- dplyr::left_join(
  states_map,
  dplyr::filter(seasonality_df, Region != "USA (NSA)"),
  by = c("division" = "Region")
)

# --------------------------
# 2. 先画好地图
# --------------------------
map_plot <- ggplot(states_map, aes(x = long, y = lat, group = group, fill = Seasonality_Index)) +
  geom_polygon(color = "black") +
  coord_fixed(1.3) +
  # 这里用美国国旗常见的蓝色：#002868
  scale_fill_gradient(low = "white", high = "#002868") +
  labs(title = "US Regional Seasonality Index", fill = "Seasonality Index") +
  theme_minimal()

# --------------------------
# 3. 生成一个简洁的表格
# --------------------------
# 如果只想展示 9 行(去掉 "USA (NSA)")，且让 Region 当作行名:
label_df <- seasonality_df %>%
  filter(Region != "USA (NSA)") %>%
  select(Region, Seasonality_Index)

# 把 Region 设为行名，这样表格更窄
row.names(label_df) <- label_df$Region
label_df$Region <- NULL

# 现在 label_df 只有一列 (Seasonality_Index)，行名是分区
# 查看 label_df:
#                        Seasonality_Index
# East North Central (NSA)         1.744875
# East South Central (NSA)         1.035082
# ...

# 生成 tableGrob，调整字体和边距让它更紧凑
table_plot <- tableGrob(
  label_df,
  theme = ttheme_minimal(
    base_size = 9,                  # 调整字体大小
    padding = unit(c(2, 2), "mm")   # 单元格内边距
  )
)

# --------------------------
# 4. 使用 grid.arrange 并排展示
# --------------------------
final_plot <- grid.arrange(
  map_plot, 
  table_plot,
  ncol = 2,
  widths = c(3, 1)  # 调整地图和表格的相对宽度比例
)


ggsave(
  filename = "map.svg",  # name of the output file
  plot = final_plot,         # the plot object you want to save
  device = "svg",            # specify SVG format
  width = 12,                # width in inches (adjust as needed)
  height = 6                ) # height in inches (adjust as needed)
















































library(dplyr)
library(tidyr)

# ----- 1) Pivot from wide to long -----
df_long <- df %>%
  pivot_longer(
    cols = -Month,
    names_to = c("Region", "Adjustment"),
    names_pattern = "(.*) \\((.*)\\)", 
    # Explanation: 
    #  (.*)      = capture region name (e.g. "East North Central")
    #  \\(.*\\)  = capture what's inside parentheses (e.g. "NSA" or "SA")
    values_to = "Index"
  )
# Now df_long has columns: Month, Region, Adjustment, Index
# e.g. "East North Central" / "NSA" / 101.23

# ----- 2) Pivot from long back to 'wider' so we get columns NSA, SA side by side -----
df_wide <- df_long %>%
  pivot_wider(
    names_from = "Adjustment",   # "NSA" or "SA"
    values_from = "Index"        # numeric values
  )

# Rename to more descriptive columns
df_wide <- df_wide %>%
  rename(
    Price_NSA = NSA,
    Price_SA  = SA
  )
# Now df_wide has columns: Month, Region, Price_NSA, Price_SA
# Each row = one Month + one Region, plus the NSA and SA values.

# ----- 3) (Optional) Create a "Seasonality" measure -----
# One approach: difference between NSA and SA
# You might define it differently, e.g. ratio, or a pre-calculated factor.
df_wide <- df_wide %>%
  mutate(Seasonality = Price_NSA - Price_SA)

# Make sure Region is a factor
# Make sure Region is a factor
df_wide$Region <- as.factor(df_wide$Region)

# Relevel so that "USA" is the reference level
df_wide$Region <- relevel(df_wide$Region, ref = "USA")

# Now fit the interaction model with USA as the baseline
model_interact <- lm(Price_NSA ~ Seasonality * Region, data = df_wide)
summary(model_interact)
anova_model <- Anova(model_interact, type = "III")

anova_model

anova_df <- as.data.frame(anova_model)

# 1) Convert ANOVA result to data frame
anova_model <- Anova(model_interact, type = "III")
anova_df <- as.data.frame(anova_model)

# 2) Move row names into a 'Term' column
anova_df$Term <- rownames(anova_df)
rownames(anova_df) <- NULL

# 3) Rename columns for clarity
colnames(anova_df) <- c("Sum Sq", "Df", "F value", "Pr(>F)", "Term")
anova_df <- anova_df[, c("Term", "Sum Sq", "Df", "F value", "Pr(>F)")]

# 4) Create a column for significance stars
anova_df$Signif <- ifelse(anova_df$`Pr(>F)` < 0.001, "***",
                          ifelse(anova_df$`Pr(>F)` < 0.01, "**",
                                 ifelse(anova_df$`Pr(>F)` < 0.05, "*", "")))

# 5) Format p-values to keep scientific notation for very small ones
anova_df$FormattedP <- ifelse(
  anova_df$`Pr(>F)` < 2.2e-16,
  "< 2.2e-16",  # or whatever threshold text you'd like
  format(anova_df$`Pr(>F)`, scientific = TRUE, digits = 3)
)

# 6) Merge formatted p-value with significance stars
anova_df$`Pr(>F)` <- paste(anova_df$FormattedP, anova_df$Signif)

# 7) Remove temporary columns
anova_df <- anova_df[, ! names(anova_df) %in% c("Signif", "FormattedP")]

anova_df$`Pr(>F)`[5] <- NA

# 8) Now pass anova_df into your table function
regression_table <- nice_table(
  anova_df,
  title = c("Table 10", "Type III ANOVA"),
  note  = "Data source: HPI data 1991-2024\nSignif. codes: 0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05"
)

# (Optional) Adjust widths if needed
regression_table <- width(regression_table, j = 1, width = 2)
regression_table <- width(regression_table, j = 2:5, width = 1.8)

regression_table


# 8) Save as an SVG file
save_as_image(regression_table, path = "GEO_ANOVA_Table.svg")













# Adjusted R code to clearly include stars next to p-values

# Convert your regression model into a tidy dataframe
model_df <- tidy(model_interact)

# Rename columns for clarity
names(model_df) <- c("Term", "Estimate", "Std. Error", "t-value", "p-value")

# Add stars based on significance levels
model_df$Signif <- ifelse(model_df$`p-value` < .001, "***",
                          ifelse(model_df$`p-value` < .01, "**",
                                 ifelse(model_df$`p-value` < .05, "*", "")))

# Merge stars with p-value column
model_df$`p-value` <- paste0(round(model_df$`p-value`, 3), " ", model_df$Signif)

# Drop Signif column
model_df <- model_df[, -which(names(model_df) == "Signif")]

# Create the final table with stars clearly shown next to p-values
# Keep only the interaction terms (which contain a colon ':')
model_df_interactions <- subset(model_df, grepl(":", Term))

# Then create your table from the filtered data frame
regression_table <- nice_table(model_df_interactions,
                               title = c("Table 9","Regression Model Summary"),
                               note = "Data source: HPI data, 1991-2024
                               \n* p < .05, ** p < .01, *** p < .001")

# Adjust column widths
regression_table <- width(regression_table, j = 1, width = 3)
regression_table <- width(regression_table, j = 2:5, width = 1.6)

regression_table
save_as_image(regression_table, path = "GEO_RM_Table.svg")

















