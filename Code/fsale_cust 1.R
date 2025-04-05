library(readxl)
library(ggplot2)
library(reshape2)

# 数据读取
df<-read_xlsx("data fsale_cust.xlsx",na="(NA)",sheet = "Sheet1")

# 数据清洗
df1<-na.omit(melt(df,id.vars="Year"))

# 绘图
# 总的
p1<-ggplot(df1,aes(x=Year,y=value,fill = variable))+
  geom_point(shape=21,size=1.5)+
  geom_line(aes(group = variable,color=variable),linewidth=1,alpha=0.7)+
  scale_fill_manual(name="Group",values = c("#D95F02","#7570B3","#E7298A","#66A61E","#A6761D"))+
  scale_color_manual(name="Group",values = c("#D95F02","#7570B3","#E7298A","#66A61E","#A6761D"))+
  scale_x_continuous(breaks = seq(1960,2025,by=5))+
  scale_y_continuous(breaks = seq(0,600,by=100))+
  theme_bw()+
  labs(x="Year",y="New Privately-Owned Houses For Sale (×1000)")+
  theme(text = element_text(family = "serif"),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12),
        legend.position = c(0.1,0.75),
        legend.background = element_blank(),
        legend.title = element_text(size=13),
        legend.text = element_text(size=12))
p1 # 查看图片
ggsave("p1.png",plot = p1,width = 8.03*3,height = 4.19*3,units = "cm") # 保存图片

# 没有United States
df2<-df1[df1$variable!="United States",] # 去掉数据中的United States
p2<-ggplot(df2,aes(x=Year,y=value,fill = variable))+
  geom_point(shape=21,size=1.5)+
  geom_line(aes(group = variable,color=variable),linewidth=1,alpha=0.7)+
  scale_fill_manual(name="Group",values = c("#7570B3","#E7298A","#66A61E","#A6761D"))+
  scale_color_manual(name="Group",values = c("#7570B3","#E7298A","#66A61E","#A6761D"))+
  scale_x_continuous(breaks = seq(1960,2025,by=5))+
  scale_y_continuous(breaks = seq(0,600,by=50))+
  theme_bw()+
  labs(x="Year",y="New Privately-Owned Houses For Sale (×1000)")+
  theme(text = element_text(family = "serif"),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12),
        legend.position = c(0.3,0.9),
        legend.background = element_blank(),
        legend.direction = "horizontal",
        legend.title = element_text(size=13),
        legend.text = element_text(size=12))
p2
ggsave("p2.png",plot = p2,width = 8.03*3,height = 4.19*3,units = "cm") # 保存图片


################ Sheet2 季度 ####################
# 设置工作路径
setwd("E:/R-language/202502/250219-科研绘图-双y轴/")

# R包安装
library(readxl)
library(ggplot2)
library(reshape2)

# 数据读取
df<-read_xlsx("data fsale_cust.xlsx",sheet = "Sheet2")
df$`Months' Supply`<-df$`Months' Supply`*30
df$Month<-as.Date(df$Month)
df$year<-format(df$Month,"%Y")
df$Month<-format(df$Month,"%m")

# 数据划分
df1<-melt(df,id.vars = c("Month","year"))

# 年份筛选
df1<-df1[df1$year %in% 2014:2024,]

# 绘图
for (i in unique(df1$variable)) {
  da<-df1[df1$variable==i,]
  label<-da[da$Month=="01",]
  
  ggplot(da,aes(x=Month,y=value,color=year))+
    geom_line(aes(group=year),linewidth=1,show.legend = FALSE)+
    geom_text(data=label,aes(x=1,y=value,label=year),family="serif",hjust=1.1,size=4,show.legend = FALSE)+
    scale_y_continuous(name = "New Privately-Owned Houses For Sale (×1000)")+
    theme_bw()+
    theme(text = element_text(family = "serif"),
          axis.title = element_text(size=14),
          axis.text = element_text(size=12))->p
  ggsave(paste0("fsale_cust/",i,".png"),plot = p,width = 9*3,height = 5.1*3,units = "cm")
}

anova_result <- aov(USA_NSA ~ factor(Month), data = data_price)
summary(anova_result)  # Check for seasonality significance

# --- 2️⃣ Nonparametric Kruskal-Wallis Test ---
kruskal_result <- kruskal.test(USA_NSA ~ factor(Month), data = data_price)
print(kruskal_result)  # Test for seasonality without assuming normality

# --- 3️⃣ Two-Way ANOVA (Moving Seasonality Test) ---
anova_two_way <- aov(USA_NSA ~ factor(Month) + factor(Year), data = data_price)
summary(anova_two_way)  # Checks for both seasonal & yearly effects