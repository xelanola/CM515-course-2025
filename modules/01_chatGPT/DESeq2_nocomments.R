if (!require("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
BiocManager::install
if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")

BiocManager::install("DESeq2")


BiocManager::install("apeglm")

install.packages("corrplot")

install.packages("pheatmap")

install.packages("RColorBrewer")

install.packages("tidyverse")




library(DESeq2)
library(corrplot)
library(RColorBrewer)
library(pheatmap)
library(apeglm)


sessionInfo()



getwd()





getwd()
countsData <- read.table(file = "../01_input/231130_counts.txt", header = FALSE, row.names = 1, skip = 2) # 



head(countsData)
dim(countsData)
class(countsData)

metadata1 <- read.table(file = "../01_input/metadata_gomezOrte.txt", header = FALSE) 
metadata1


colnames(metadata1) <- c("fasta1", "fasta2", "names1", "names2", "food", "temp", "rep")
metadata1



head(countsData)

as.vector(metadata1$names2)



colnames(countsData) <- c("chr", "start", "stop", "strand", "length", as.vector(metadata1$names2))







head(countsData)
dim(countsData)

countColNum <- dim(countsData)[2]

head(countsData[,6:countColNum])
dim(countsData[,6:countColNum])



cts <- as.matrix(countsData[,6:countColNum])
head(cts)


class(metadata1)
metadata1
rownames(metadata1)<- metadata1$names2
metadata1

coldata <- metadata1[,c("food", "temp", "rep")]
coldata$food <- as.factor(coldata$food)
coldata$temp <- as.factor(coldata$temp)
coldata$rep <- as.factor(coldata$rep)
str(coldata)




rownames(coldata)
colnames(cts)

all(rownames(coldata) == colnames(cts))



dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design = ~ food + temp)



keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

dim(dds)

str(dds)

dds$treatment <- factor(dds$food, levels = c("Ecoli","Bsubtilis"))
dds$time <- factor(dds$temp, levels = c("15", "20", "25"))



dds <- DESeq(dds)



class(dds)
str(dds)
dim(dds)
plotDispEsts(dds)


dds$sizeFactor



head(counts(dds, normalized = TRUE))
head(counts(dds, normalized = FALSE))


rld <- rlog(dds, blind=FALSE)  

sampleDists <- dist(t(assay(rld))) 


sampleDistMatrix <- as.matrix(sampleDists) 
rownames(sampleDistMatrix) <- colnames(rld) 
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255) 

par(mfrow=c(1,1))
p <- pheatmap(sampleDistMatrix,
              clustering_distance_rows=sampleDists,
              clustering_distance_cols=sampleDists,
              col=colors) # Plot the heatmap



pdf("../03_output/corr_matrix_plots.pdf", height = 6, width = 7)
par(mfrow=c(1,1))
p

dev.off() 
dev.off() 






res_EcolVBsubt <- results(dds,
                            lfcThreshold = 0.5,
                            alpha = 0.1,
                            contrast=c("food", "Ecoli", "Bsubtilis"))
summary(res_EcolVBsubt)




par(mfrow=c(1,1))
plotMA(res_EcolVBsubt, main="E.coli v. B. subtilus \nunshrunken", ylim = c(-7,7), 
       ylab = "log fold change (ratio of normalized E.coli / B.subtilis)",
       xlab = "means of normalized counts")





plotCounts(dds, gene=which(rownames(res_EcolVBsubt) == "WBGene00018393"), intgroup="treatment")
plotCounts(dds, gene=which(rownames(res_EcolVBsubt) == "WBGene00018393"), intgroup=c("treatment", "time"))






resultsNames(dds)

res_EcolVBsubt

significantLFC <- rbind(subset(res_EcolVBsubt, padj < 0.1 & log2FoldChange > 0.5  ), subset(res_EcolVBsubt, padj < 0.1 & log2FoldChange < -0.5 )) 

significant_points_to_plot <-res_EcolVBsubt[which(rownames(res_EcolVBsubt) %in% rownames(significantLFC)),] 

maxedout <- subset(res_EcolVBsubt, padj < 10e-100)

par(mfrow=c(1,1)) 

plot(res_EcolVBsubt$log2FoldChange, -log10(res_EcolVBsubt$padj),
     main="Volcano plot", xlab="Effect size: log2(fold-change)", ylab="-log10(adjusted p-value)", pch=20, cex = 0.4, ylim = c(0, 100), xlim = c(-6,6), col = "#00000030")

points(maxedout$log2FoldChange, rep(102, length(maxedout$log2FoldChange)), 
       pch=17, cex = 0.4, ylim = c(0, 100), col = "red")

points(significant_points_to_plot$log2FoldChange, -log10(significant_points_to_plot$padj),
       pch=20, cex = 0.4, ylim = c(0, 100), col = "#FF000030")

abline(v=0, col = "blue")
abline(v=0.5, col = "blue", lty = "dashed")
abline(v=-0.5, col = "blue", lty = "dashed")
abline(h=-log10(0.1), col = "blue", lty = "dashed")

pdf("../03_output/volcanoplot.pdf", width = 6, height = 6)

par(mfrow=c(1,1)) 

plot(res_EcolVBsubt$log2FoldChange, -log10(res_EcolVBsubt$padj),
     main="Volcano plot", xlab="Effect size: log2(fold-change)", ylab="-log10(adjusted p-value)", pch=20, cex = 0.4, ylim = c(0, 100), xlim = c(-6,6), col = "#00000030")

points(maxedout$log2FoldChange, rep(102, length(maxedout$log2FoldChange)), 
       pch=17, cex = 0.4, ylim = c(0, 100), col = "red")

points(significant_points_to_plot$log2FoldChange, -log10(significant_points_to_plot$padj),
       pch=20, cex = 0.4, ylim = c(0, 100), col = "#FF000030")


abline(v=0, col = "blue")
abline(v=0.5, col = "blue", lty = "dashed")
abline(v=-0.5, col = "blue", lty = "dashed")
abline(h=-log10(0.1), col = "blue", lty = "dashed")


dev.off() 
dev.off()




res_EcolVBsubt


summary(res_EcolVBsubt)
head(res_EcolVBsubt)


Up_in_e.coli <- subset(res_EcolVBsubt, padj < 0.1 & log2FoldChange > 0.5)
Up_in_e.coli <- Up_in_e.coli[order(Up_in_e.coli$padj),] 

head(Up_in_e.coli) 
dim(Up_in_e.coli)

Down_in_e.coli <- subset(res_EcolVBsubt, padj < 0.1 & log2FoldChange < -0.5)
Down_in_e.coli <- Down_in_e.coli[order(Down_in_e.coli$padj),]

head(Down_in_e.coli)
dim(Down_in_e.coli)

write(rownames(Up_in_e.coli), file = "../03_output/Genes Up in E.coli.txt", sep = "\n")
write(rownames(Down_in_e.coli), file = "../03_output/Genes Down in E.coli.txt", sep = "\n")
write(rownames(res_EcolVBsubt), file = "../03_output/all_present_genes.txt", sep = "\n") 





res_20v15_2 <- results(dds,
                       lfcThreshold = 0.5,
                       alpha = 0.1,
                       contrast=c("temp", "20", "15"))

res_25v15_2 <- results(dds,
                       lfcThreshold = 0.5,
                       alpha = 0.1,
                       contrast=c("temp", "25", "15"))

res_25v20_2 <- results(dds,
                       lfcThreshold = 0.5,
                       alpha = 0.1,
                       contrast=c("temp", "25", "20"))

sign_food <- subset(res_EcolVBsubt_2, padj < 0.1)
dim(subset(res_EcolVBsubt_2, padj < 0.1))

sign_20v15 <- subset(res_20v15_2, padj < 0.1)
sign_25v15 <- subset(res_25v15_2, padj < 0.1)
sign_25v20 <- subset(res_25v20_2, padj < 0.1)

changing_genes <- rbind(sign_food, sign_20v15, sign_25v15, sign_25v20)

dim(changing_genes)
length(unique(rownames(changing_genes)))
rdl_all <- assay(rlog(dds, blind=FALSE))

changing_lrt_rdl <- subset(rdl_all, rownames(rdl_all) %in% rownames(changing_genes))
dim(changing_lrt_rdl)
head(changing_lrt_rdl)

class(changing_lrt_rdl)

p <- pheatmap(changing_lrt_rdl, 
              scale="row", 
              color = colorRampPalette(c("blue", "white", "red"), space = "Lab")(100),
              cluster_rows=TRUE, 
              cluster_cols=TRUE, 
              clustering_distance_rows = "euclidean", 
              clustering_method = "complete",
              show_rownames = FALSE)

p
help(pheatmap)

pdf("../03_output/clustered_genes.pdf", width = 6, height = 8)

p

dev.off()
dev.off()








resultsNames(dds)

resLFC_EcolVBsubt <- lfcShrink(dds, coef="food_Ecoli_vs_Bsubtilis", res = res_EcolVBsubt)

summary(resLFC_EcolVBsubt)







par(mfrow=c(1,2))
plotMA(res_EcolVBsubt, main="E.coli v. B. subtilus \nunshrunken", ylim = c(-7,7), 
       ylab = "log fold change (ratio of normalized E.coli / B.subtilis)",
       xlab = "means of normalized counts")

plotMA(resLFC_EcolVBsubt, main="E.coli v. B. subtilus \nshrunken", ylim = c(-7,7), 
       ylab = "log fold change (ratio of normalized E.coli / B.subtilis)",
       xlab = "means of normalized counts")



pdf("../03_output/MAplots.pdf", height = 6, width = 11)

par(mfrow=c(1,2)) # This changes how many plot panels you can generate
plotMA(res_EcolVBsubt, main="E.coli v. B. subtilus \nunshrunken", ylim = c(-7,7), 
       ylab = "log fold change (ratio of normalized E.coli / B.subtilis)",
       xlab = "means of normalized counts")

plotMA(resLFC_EcolVBsubt, main="E.coli v. B. subtilus \nshrunken", ylim = c(-7,7), 
       ylab = "log fold change (ratio of normalized E.coli / B.subtilis)",
       xlab = "means of normalized counts")


dev.off() 
dev.off() #Note: sometimes you need 2x dev.off() lines of code to really truly escape out of the .pdf printer













sessionInfo()

citation()

