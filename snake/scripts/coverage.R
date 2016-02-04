library(ggplot2)
library(Cairo)
library(dplyr)
library(readr)
library(tidyr)

raw_coverage_tab <- snakemake@input[[1]]
idx_tab <- snakemake@input[[2]]

tab <- readr::read_tsv(raw_coverage_tab,
                       col_name = c('chrom', 'pos', 'count')

tab_hiv <- filter(tab, chrom == 'HIV')

tab_tidy <- tab_hiv %>% spread(sample.name)

tab_tidy <- mutate(FracU = (JS208 - JS215) / JS208)

gp <- ggplot(data = tab_tidy,
       aes(x = pos, y = count.norm,
           color=factor(treatment))) +
        theme_bw() +
        geom_point(size = 0.5, alpha = 0.5) +
        theme(strip.text.y = element_text(size = 7, angle=360))+
        theme(legend.position = 'bottom') +
        scale_color_brewer(palette="Set1") +
        xlab("Position (bp)") +
        ylab(expression(paste("Normalized coverage (CPM x10"^"4)")))+
        ggtitle("Uracil Excision-seq / Lockdown HIV enrichment in MDM day 7") 

pdf.filename <- paste(output.dir, '/', 'coverage.pdf',)
png.filename <- paste(output.dir, '/', 'coverage.png',)

ggsave(filename = pdf.filename, plot = gp, 
    height = 8.5, width = 11, device = CairoPDF)
ggsave(filename = png.filename, plot = gp, 
    height = 8.5, width = 11, device = CairoPNG)
