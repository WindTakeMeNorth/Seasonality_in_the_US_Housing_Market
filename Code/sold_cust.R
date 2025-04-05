library(readxl)
library(ggplot2)
library(reshape2)

# 数据读取
df<-read_xlsx("data sold_cust.xlsx",na="(NA)",sheet = "Sheet1")

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
  scale_y_continuous(breaks = seq(0,1200,by=200))+
  theme_bw()+
  labs(x="Year",y="New Privately-Owned Houses Sold (×1000)")+
  theme(text = element_text(family = "serif"),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12),
        legend.position = c(0.1,0.75),
        legend.background = element_blank(),
        legend.title = element_text(size=13),
        legend.text = element_text(size=12))
p1 # 查看图片
ggsave("p5.png",plot = p1,width = 8.03*3,height = 4.19*3,units = "cm") # 保存图片

################# sheet 2
# 数据读取
df<-read_xlsx("data sold_cust.xlsx",na="(NA)",sheet = "Sheet2")
df$Month<-as.Date(df$Month)

df$year<-format(df$Month,"%Y")
df$year<-as.factor(df$year)
df$Month<-format(df$Month,"%m")

# 数据清洗
df1<-na.omit(melt(df,id.vars=c("Month","year")))

# 绘图
# 总的
p2<-ggplot(df1,aes(x=Month,y=value,fill = variable))+
  geom_point(shape=21,size=1.5)+
  geom_line(aes(group = variable,color=variable),linewidth=1,alpha=0.7)+
  scale_fill_manual(name="Group",values = c("#D95F02","#7570B3","#E7298A","#66A61E","#A6761D"))+
  scale_color_manual(name="Group",values = c("#D95F02","#7570B3","#E7298A","#66A61E","#A6761D"))+
  # scale_x_continuous(breaks = seq(1960,2025,by=5))+
  # scale_y_continuous(breaks = seq(0,1200,by=200))+
  facet_wrap(year~.)+
  theme_bw()+
  labs(x="Year",y="New Privately-Owned Houses Sold (×1000)")+
  theme(text = element_text(family = "serif"))
p2 # 查看图片
ggsave("p6.png",plot = p2,width = 16*3,height = 9.3*3,units = "cm") # 保存图片


################ Sheet3 ####################
# 设置工作路径
setwd("E:/R-language/202502/250219-科研绘图-双y轴/")

# 数据读取
df<-read_xlsx("data sold_cust.xlsx",na="(NA)",sheet = "Sheet3")
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
  scale_y_continuous(name = "Seasonal Indexes Used to Adjust Housing Units Sold and For Sale")+
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
ggsave("p7.svg",plot = p3,width = 12.6*3,height = 4.67*3,units = "cm") # 保存图片
