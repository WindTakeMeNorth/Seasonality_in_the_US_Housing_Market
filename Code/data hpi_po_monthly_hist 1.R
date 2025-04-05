# R包加载
library(readxl)
library(ggplot2)
library(reshape2)

# 数据加载
df<-read_xlsx("data hpi_po_monthly_hist.xlsx")
df$Month<-as.Date(df$Month)
# 数据清洗
df$year<-format(df$Month,"%Y")
df$Month<-format(df$Month,"%m")
df1<-melt(df,id.vars = c("Month","year"))
df1<-df1[as.numeric(df1$year) %in% 2014:2024,]
# 绘图
for (i in unique(df1$variable)) {
  da<-df1[df1$variable==i,]
  label<-da[da$Month=="01",]
  ggplot(da,aes(x=Month,y=value,color=year))+
    geom_line(aes(group=year),linewidth=1,show.legend = FALSE)+
    geom_text(data=label,aes(x=1,y=value,label=year),family="serif",hjust=1.1,size=4,show.legend = FALSE)+
    theme_bw()+
    guides(color = guide_legend(ncol = 2))+
    theme(text = element_text(family = "serif"),
          axis.title = element_text(size=14),
          axis.text = element_text(size=12))->p
  ggsave(paste0("hpi_po_monthly/",i,".png"),plot = p,width = 9*3,height = 5.1*3,units = "cm")
}
