library(reshape2)
library(readxl)
library(ggplot2)
# 数据读取
df<-read_xlsx("pricereg_cust.xlsx")
df$year<-substr(df$Quarter,1,4)
df$Quarter<-substr(df$Quarter,5,6)

# 数据清洗
df1<-na.omit(melt(df,id.vars=c("Quarter","year")))

# 绘图
for(i in unique(df1$variable)){
  da<-df1[df1$variable==i,]
  label<-da[da$Quarter=="Q1",]
  
  ggplot(da,aes(x=Quarter,y=value/1000,color=year))+
    geom_line(aes(group=year),linewidth=1,show.legend = FALSE)+
    geom_text(data=label,aes(x=1,y=value/1000,label=year),family="serif",hjust=1.1,size=4,show.legend = FALSE)+
    scale_y_continuous(name = "Median Sales Price of New Houses Sold (×1000)")+
    theme_bw()+
    theme(text = element_text(family = "serif"),
          axis.title = element_text(size=14),
          axis.text = element_text(size=12))->p
  ggsave(paste0("procereg cust/",i,".png"),plot = p,width = 4.6*3,height = 4.6*3,units = "cm")
}