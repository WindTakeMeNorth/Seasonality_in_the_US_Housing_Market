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

################# sheet 2 月份
# 数据读取
df<-read_xlsx("data sold_cust.xlsx",na="(NA)",sheet = "Sheet2")
df$Month<-as.Date(df$Month)

df$year<-format(df$Month,"%Y")
df$Month<-format(df$Month,"%m")

# 数据清洗
df1<-na.omit(melt(df,id.vars=c("Month","year")))

# 绘图
for(i in unique(df1$variable)){
  da<-df1[df1$variable==i,]
  label<-da[da$Month=="01",]
  
  ggplot(da,aes(x=Month,y=value,color=year))+
    geom_line(aes(group=year),linewidth=1,show.legend = FALSE)+
    geom_text(data=label,aes(x=1,y=value,label=year),family="serif",hjust=1.1,size=4,show.legend = FALSE)+
    scale_y_continuous(name = "New Privately-Owned Houses Sold (×1000)")+
    theme_bw()+
    theme(text = element_text(family = "serif"),
          axis.title = element_text(size=14),
          axis.text = element_text(size=12))->p
  ggsave(paste0("sold_cust/",i,".png"),plot = p,width = 9*3,height = 5.1*3,units = "cm")
}


################ Sheet3 ####################
# 设置工作路径
setwd("E:/R-language/202502/250219-科研绘图-双y轴/")

# 数据读取
df<-read_xlsx("data sold_cust.xlsx",na="(NA)",sheet = "Sheet3")
df$Month<-as.Date(df$Month)

df$year<-format(df$Month,"%Y")
df$Month<-format(df$Month,"%m")

# 数据清洗
df1<-na.omit(melt(df,id.vars=c("Month","year")))

# 绘图
for(i in unique(df1$variable)){
  da<-df1[df1$variable==i,]
  label<-da[da$Month=="01",]
  
  ggplot(da,aes(x=Month,y=value,color=year))+
    geom_line(aes(group=year),linewidth=1,show.legend = FALSE)+
    geom_text(data=label,aes(x=1,y=value,label=year),family="serif",hjust=1.1,size=4,show.legend = FALSE)+
    scale_y_continuous(name = "New Privately-Owned Houses Sold (×1000)")+
    theme_bw()+
    theme(text = element_text(family = "serif"),
          axis.title = element_text(size=14),
          axis.text = element_text(size=12))->p
  ggsave(paste0("sold_cust/",i,"-sheet3.svg"),plot = p,width = 9*3,height = 5.1*3,units = "cm")
}
