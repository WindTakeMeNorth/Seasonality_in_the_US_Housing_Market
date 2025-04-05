library(svglite)
library(readxl)
library(ggplot2)
library(reshape2)

# 数据加载
df<-read_xlsx("data hpi_po_monthly_hist.xlsx")
df$Month<-as.Date(df$Month)
# 数据清洗
df1<-melt(df,id.vars = "Month")

# 绘图
ggplot(df1,aes(x=Month,y=value,color=variable))+
  geom_line(aes(group=variable))+
  scale_x_date(breaks = seq(as.Date("1990-01-01"),as.Date("2025-01-01"),by="5 years"),date_labels = "%Y",
               limits = as.Date(c("1990-01-01",NA)))+
  scale_y_continuous(name = "HPI",breaks = seq(0,600,by=100))+
  theme_bw()+
  guides(color = guide_legend(ncol = 2))+
  theme(legend.position = c(0.2,0.6),
        legend.background = element_blank(),
        legend.title = element_blank(),
        text = element_text(family = "serif"),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12))->p
p
ggsave("p4.svg", p, width = 8.17*3, height = 3.76*3, units = "cm")