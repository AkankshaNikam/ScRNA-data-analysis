getwd()
#Setting the directory
setwd("C:/Users/hp/Downloads/gse147507_rawreadcounts_human.tsv")
#Reading the data in R and storing in variable data
data <- read.table("gse147507_rawreadcounts_human.tsv", sep="\t", header=T)
dim(data)

#converting 1st column into rownames
data2 <- data.frame(data[,-1], row.names=data[,1])

#renaming columns
colnames(data2use) <- c("NHBE_Mock1","NHBE_Mock2","NHBE_Mock3","NHBE_CoV1","NHBE_CoV2","NHBE_CoV3","A549_Mock1","A549_Mock2","A549_Mock3","A549_CoV1","A549_CoV2","A549_CoV3","A549_ACE2_Mock1","A549_ACE2_Mock2","A549_ACE2_Mock3" ,"A549_ACE2_CoV1","A549_ACE2_CoV2","A549_ACE2_CoV3","Calu3_Mock1","Calu3_Mock2","Calu3_Mock3","Calu3_CoV1","Calu3_CoV2","Calu3_CoV3","HealthyLungBiopsy2","HealthyLungBiopsy1","COVID19Lung2", "COVID19Lung1")
a2 <- data.matrix(data2use)

#Plotting a bar graph
barplot(a2, las=2,cex.names =0.6, col=rgb(0.2,0.4,0.6,0.6))
abline(h=1, lwd=1, lty=2)
library(limma)
library(edgeR)

#Copy of data, Just in case if needed to cross check
data2use <- data2


# TMM Normalization
#Creating a factorlist based on the group of samples.
group_list <- factor(x = c(rep("1",3), rep("2",3), rep("3",3), rep("4",3), rep("5",3), rep("6",3), rep("7",3),rep("8",3),rep("9",2), rep("10",2)))
dg <- DGEList(counts = data2use, group = group_list)
tmm <- calcNormFactors(dg, method="TMM")
tmm$samples
tmm$counts
norm_counts_TMM <- cpm(tmm)
write.table(norm_counts_TMM, file="TMM_norm.csv", sep=",", row.names=TRUE)

#RLE Normalization

DG1 <- DGEList(counts = data2use, group = group_list)
DG1 <- calcNormFactors(DG1, method="RLE")
DG1$samples
norm_counts_RLE_diff <- cpm(DG1, normalized.lib.sizes=TRUE)
write.table(norm_counts_RLE_diff, file="RLE_norm.csv", sep=",", row.names=TRUE)

#UQ Normalization

DG2 <- DGEList(counts = data2use, group = group_list)
DG2 <- calcNormFactors(DG2, method="upperquartile")
DG2$samples
norm_counts_UQ_diff <- cpm(DG2)
write.table(norm_counts_UQ_diff, file="UQ_norm.csv", sep=",", row.names=TRUE)

#MDS Plot
#Plotting based on BCV distance method using the TMM normalized data
plotMDS(dg, method="bcv", col=as.numeric(dg$samples$group))
title("MDS Plot")
