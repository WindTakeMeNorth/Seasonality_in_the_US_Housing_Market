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


################ Sheet2 ####################
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

# 数据划分
df1<-melt(df,id.vars = "Month")

# 绘图
ggplot(df1,aes(x=Month,y=value,color=variable))+
  geom_line(aes(group=variable),size=1)+
  scale_x_date(breaks = seq(as.Date("1990-01-01"),
                                  as.Date("2025-01-01"),
                                  by="5 years"),
                     date_labels = "%Y")+
  scale_y_continuous(name = "New Privately-Owned Houses For Sale (×1000)",
                     breaks = seq(0,600,by=100),
                     sec.axis = sec_axis(~./30,name = "Months' Supply"))+
  theme_bw()+
  guides(color=guide_legend(nrow = 1))+
  theme(text = element_text(family = "serif"),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12),
        legend.position = "top",
        legend.background = element_blank(),
        legend.title = element_blank(),
        legend.text = element_text(size=12))->p3
p3
ggsave("p3.svg",plot = p3,width = 8.03*3,height = 4.19*3,units = "cm") # 保存图片

df <- df[order(df$Month), ]
# Extract the month factor
df$mon <- factor(format(df$Month, "%m"))

# Fit a linear model: price ~ month
model <- lm(USA ~ mon, data = df)

# Run ANOVA
anova(model)


x_ts <- ts(df$`United States`, start = c(1991, 1), frequency = 12)
isSeasonal(x_ts, test = "seasdum", freq = NA)

