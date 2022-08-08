# asl-preprocessing
Ghazaleh Ahmadzadeh 
# R script
```{r}
list.files(path = "/KIMEL/tigrlab/scratch/jwong/aslprep/output/aslprep", pattern = ".*desc-HavardOxford_mean_cbf.csv",
           full.names = TRUE, recursive = TRUE)
```

```{r}
library(purrr)
library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)
```

```{r}

cbf_data_HO <-
  list.files(path = "/KIMEL/tigrlab/scratch/jwong/aslprep/output/aslprep",
             pattern = ".*desc-HavardOxford_mean_cbf.csv",
             recursive = TRUE,
             full.names = TRUE) %>%
  map_df(function(x) read_csv(x) %>% 
           mutate(filename = gsub(".csv", "", basename(x)))) %>%
  select(filename, everything())

cbf_data_HO
```
```{r}
list.files(path = "/scratch/jwong/aslprep/aslprep_training/aslprep",
             pattern = ".*desc-_mean_cbf.csv",
             recursive = TRUE,
             full.names = TRUE)
```
```{r}
cbf_data_QA10 <-
  list.files(path = "/KIMEL/tigrlab/scratch/jwong/aslprep/output/aslprep",
             pattern = ".*desc-quality_control_cbf.csv",
             recursive = TRUE,
             full.names = TRUE) %>%
  map_df(function(x) read_csv(x) %>% 
           mutate(filename = gsub(".csv", "", basename(x)))) %>%
  select(filename, everything())

cbf_data_QA10
```

```{r}
demo <- read_csv(file= '/KIMEL/tigrlab/archive/data/TAY/metadata/tay_mri_demo.csv')
demo <- data.frame(lapply(demo, function(x) {
                 gsub("TAY01_CMH_", "sub-CMH", x)
              })) 
```
```{r}
data_final <-
data %>% 
  mutate(age_scan = as.numeric(age_scan),
         assigned_sex_at_birth = factor(assigned_sex_at_birth, levels= c("Male", "Female")))
```
```{r}
summary(data_final)
```
```{r}
data_final %>%                                        
  
# Specify group indicator, column, function
group_by(assigned_sex_at_birth)                       
summarise_at(vars(age_scan),
              list(name = mean))
```
```{r}
data_final <-
  data %>%
  mutate(
    assigned_sex_at_birth = recode(assigned_sex_at_birth, `Prefer not to answer` = "NA")
    )
```

```{r}
data_final %>% 
  group_by(assigned_sex_at_birth) %>% 
  summarise_each(funs(mean(., na.rm = TRUE)))
```
```{r}
data_final %>%
    filter(assigned_sex_at_birth == "Female") %>%
    summarise(sd = sd(age_scan, na.rm = T))
```


```{r}
library(readr)
sublist <- read_csv("/KIMEL/tigrlab/scratch/gahmadzadeh/sublist.txt", 
    col_names = FALSE)
```
```{r}
demo_filtered <- semi_join(demo, sublist, by= c("subject_id" = "X1"))
```
```{r}

```

```{r}
summary(demo_filtered)
```

```{r}
cbf_data_HO$subject_id <- substr(cbf_data_HO$filename, 1, 15)
cbf_data_QA10$subject_id <- substr(cbf_data_QA10$filename, 1, 15)
```


```{r}

data <- inner_join(x = demo_clean, y = cbf_data_QA10, by = "subject_id") %>%
inner_join(y = cbf_data_HO, by = "subject_id") 

```


```{r}
data <-data[-93,  ]
```
```{r}
data <-data[-64,  ]
```


```{r}
boxplot(GMmeanCBF~assigned_sex_at_birth,data=data_final,xlab= "Biological Sex", ylab= "Mean GM", par(cex.lab=1.5), par(cex.axis=1.5))
```
```{r}
t.test(GMmeanCBF ~ assigned_sex_at_birth, mu=0, alt="two.sided", conf=0.95, data=data_final)
```


```{r}
data %>% 
  summarise(age_sd = sd(age_scan))
```

tmp <- data_clean[c('age_scan')]

```{r}
tmp <- data_clean[c('age_scan')]
sapply(tmp, function(x) c( "Stand dev" = sd(x), 
                         "Mean"= mean(x,na.rm=TRUE),
                         "n" = length(x),
                         "Median" = median(x),
                         "CoeffofVariation" = sd(x)/mean(x,na.rm=TRUE),
                         "Minimum" = min(x),
                         "Maximun" = max(x),
                         "Upper Quantile" = quantile(x,1),
                         "LowerQuartile" = quantile(x,0)
)
)
```



```{r}
GM_CBF <-
  list.files(path = "/scratch/jwong/aslprep/aslprep_training/aslprep",
             pattern = ".*quality_control_cbf.csv",
             recursive = TRUE,
             full.names = TRUE) %>%
  map_df(function(x) read_csv(x) %>% 
           mutate(filename = gsub(".csv", "", basename(x)))) %>%
  select(filename, everything())

```

```{r}
GM_CBF1 %>%
    mutate(subject_id = glue("sub-{sub}")
```


```{r}
A<-GM_CBF1 %>%
    mutate(subject_id = gsub("CMH", "sub-CMH", sub))
```

```{r}
Final<- merge(data_clean,A,by="subject_id")
```


```{r}
ggplot(data = data, aes(x = age_scan, y = CingulateGyrusanteriordivision_L)) + geom_point() + geom_smooth(method = "lm")+ xlab("Age")+ theme(text = element_text(size = 15))
```

```
```{r}
data %>%
  pivot_longer(Amygdala_R: Amygdala_L,
                names_to = "region",
                values_to = "CBF") %>%
  ggplot(aes(x = age_scan, y = CBF)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  facet_grid(~region) + xlab("Age")+ theme(text = element_text(size = 15))
```
```{r}
data %>%
  pivot_longer(Hippocampus_R: Hippocampus_L,
                names_to = "region",
                values_to = "CBF") %>%
  ggplot(aes(x = age_scan, y = CBF)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  facet_grid(~region) + xlab ("Age") + theme(text = element_text(size = 15))
```
```{r}
data %>%
  pivot_longer(CingulateGyrusanteriordivision_R: CingulateGyrusanteriordivision_L,
                names_to = "region",
                values_to = "CBF") %>%
  ggplot(aes(x = age_scan, y = CBF)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  facet_grid(~region) + 
  xlab("Age") + theme(text = element_text(size = 15))
```

```{r}
ggplot(data = data_final, aes(x = age_scan, y = GMmeanCBF)) + geom_point() + geom_smooth(method = "lm") + facet_grid(~assigned_sex_at_birth) + xlab("Age") + ylab("Mean GM") + theme(text = element_text(size = 20)) 
```
```{r}
cor(data_final$age_scan , data_final$GMmeanCBF)
```



```{r}
ggplot(data = data, aes(x = assigned_sex_at_birth, y = GMmeanCBF))+ xlab("Age") + ylab("Mean GM CBF")+ geom_boxplot(width=0.5) + theme(text = element_text(size = 20))

