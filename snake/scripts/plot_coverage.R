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
# norm.factors <- tibble(
#           ~sample, ~num.align, ~norm.factor,
#           'JS208', 136756192,  0.16227812193,
#           'JS215', 41396132,   0.11249420598
#           )
# normalize to perc align in the lane
norm.factors <- tibble(
          ~sample, ~num.align, ~norm.factor,
          'JS208', 136756192,  1,
          'JS215', 41396132,   1.8
          )

# from samtools idxstats <dechim.bam> | percent-align.py
# norm.factors <- tibble(
#           ~sample, ~num.align, ~norm.factor,
#           'JS208', 21869104,   0.162397653726,
#           'JS215', 4603896,    0.137028715784
#           )

# with samtools view -c <raw bam>
# norm.factors <- tibble(
#           ~sample, ~num.align, ~norm.factor,
#           'JS208', 22192538, 0.16227812193,
#           'JS215', 4656825,  0.11249420598
#           )

tab <- input_tab %>%
  mutate(pos = pos + 1) %>%
  left_join(norm.factors) %>%
  # cpm per 10k / norm.factor
  mutate(norm.count = (count * norm.factor)) %>%
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

fracu.gp <- ggplot(aes(y = FracU, x = pos),
                   data = norm_tab)

fracu.gp.pos <- ggplot(aes(y = FracU, x = pos / 1000),
                       data = subset(norm_tab, strand == 'pos'))

fracu.gp.plot <- fracu.gp.pos +
  geom_line() +
  xlab('Position (kb)') +
  ylim(0,1) +
  scale_x_discrete(expand=c(0,-1)) +
  theme_cowplot()

# coverage.gp = ggplot(ae)
coverage.plot <- ggplot(aes(x = pos / 1000, y = norm.count / 10000, color = sample), data = tab)
coverage.plot <- coverage.plot + geom_line() +
  xlab('Position (kb)') +
  ylab(expression(paste("Normalized coverage (CPM x10"^"4)"))) +
  scale_color_brewer(palette="Set1") +
  theme(legend.position="none") +
  scale_x_discrete(expand=c(0,-1))

write_tsv(tab, 'coverage.tab.gz')
write_tsv(norm_tab, 'fracu.tab.gz')

save_plot('coverage.png', coverage.plot)
save_plot('fracu.png', fracu.gp.plot)
