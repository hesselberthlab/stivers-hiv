library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)
library(cowplot)
library(Cairo)

colnames <- c('chrom','pos','count','sample','strand')

input_tab <- read_tsv('snake/results-stivers-hiv/coverage/summary/combined.tab.gz',
                      col_names = colnames)

# from samtools idxstats <bam> | percent-align.py
norm.factors <- tibble(
          ~sample, ~num.align, ~norm.factor,
          'JS208', 136756192,  0.16227812193,
          'JS215', 41396132,   0.11249420598
          )

# from samtools idxstats <dechim.bam> | percent-align.py
# norm.factors <- tibble(
#           ~sample, ~num.align, ~norm.factor,
#           'JS208', 21869104,   0.162397653726,
#           'JS215', 4603896,    0.137028715784,
#           'dummy', na,         na
#           )

# with samtools view -c <raw bam>
# norm.factors <- tibble(
#           ~sample, ~num.align, ~norm.factor,
#           'JS208', 22192538, 0.16227812193,
#           'JS215', 4656825,  0.11249420598,
#           'dummy', na,       na
#           )

tab <- input_tab %>%
  mutate(pos = pos + 1) %>%
  left_join(norm.factors) %>%
  # cpm per 10k / norm.factor
  mutate(norm.count = (count / num.align * 10000) * norm.factor) %>%
  select(-num.align, -norm.factor)


raw_tab <- tab %>%
  select(-norm.count) %>%
  spread(sample, count) %>%
  mutate(FracU = (JS208 - JS215) / JS208,
         type = 'raw') %>%
  arrange(strand)

norm_tab <- tab %>%
  select(-count) %>%
  spread(sample, norm.count) %>%
  mutate(FracU = (JS208 - JS215) / JS208,
         type = 'norm') %>%
  arrange(strand)

combined <- bind_rows(raw_tab, norm_tab)

gp <- ggplot(aes(y = FracU, x = pos), data = combined)

gp + geom_line() + facet_grid(strand ~ type) + xlab('Position') + ylim(0,1) + theme_cowplot()

