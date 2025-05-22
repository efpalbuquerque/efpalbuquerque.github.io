library(tidyverse, quietly = TRUE)

# Define the path to your CSV folder
folder_path <- "Instacart Data/Instacart Data"

# List all CSV files with their full paths
csv_files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)

# Load each CSV into a tibble and store in a named list
data_list <- csv_files %>%
  set_names(~ tools::file_path_sans_ext(basename(.))) %>%
  map(read_csv)

# Check the names of the loaded datasets
names(data_list)

head(data_list)

data_list$orders <- data_list$orders %>% mutate(order_hour_of_day=as.double(order_hour_of_day))

plots <- list()

# examine the frequency of orders along the day
plots$hist_hour_of_day <- data_list$orders %>% 
    ggplot(aes(x=order_hour_of_day))+
    geom_histogram(bins=24)+
    theme_minimal()+
    labs(title = "Distribution of the 3.421.083 Orders Along the Day")

# examine the frequency of products in orders IN TRAIN DATA

product <- list()

product$freq <- data_list$order_products__train %>% 
                left_join(data_list$products, by="product_id") %>% 
                left_join(data_list$aisles, by="aisle_id") %>% 
                left_join(data_list$departments, by="department_id") %>% 
                    group_by(product_id, product_name, aisle_id, aisle, department) %>%
                    summarise(count=n()) %>% 
                    arrange(desc(count))

plots$top20products <- product$freq %>% 
    head(20) %>% 
    ggplot(aes(x=reorder(product_name,-count), y=count, fill=aisle))+
    geom_col()+
    theme_minimal()+
    labs(
        title = "Purchase Frequency of the Top 20 Products",
        subtitle = "Out of 49.688 Products, Produce Lead the Chart")+
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

product$rank <- product$freq %>%
  arrange(desc(count)) %>%
  ungroup() %>% 
  mutate(rank = row_number())

library(gridExtra)

plots$products_zipf <- grid.arrange(
product$rank %>% 
    ggplot(aes(x=rank, y=count))+
    geom_line()+
    theme_minimal()+
    labs(title = "Frequency vs Rank of products sold, Zipf?"),
tibble(x=1:40000) %>% 
    ggplot(aes(x=1:40000, y=18000/x))+
    geom_line()+
    labs(title="Textbook zipf. nth entry has value of 1/n")+
    theme_minimal(),
product$rank %>% 
    ggplot(aes(x=rank, y=count))+
    geom_line()+
    scale_x_log10()+
    scale_y_log10()+
    theme_minimal()+
    labs(title = "Frequency vs Rank, log log scale"),
tibble(x=1:40000) %>% 
    ggplot(aes(x=1:40000, y=18000/x))+
    geom_line()+
    scale_x_log10()+
    scale_y_log10()+
    labs(title="Textbook zipf. log of nth entry has value of log of 1/n")+
    theme_minimal())

product$cumulative <- product$freq %>%
  arrange(desc(count)) %>%
  ungroup() %>% 
  mutate(rank = row_number(),
         cum_count = cumsum(count),
         total = sum(count),
         cum_perc = cum_count / total)

plots$products_cumulative <- ggplot(product$cumulative, aes(x = rank, y = cum_perc)) +
  geom_line(color = "forestgreen") +
  scale_x_log10() +
  labs(x = "Product Rank", y = "Cumulative Proportion", title = "Cumulative Frequency Distribution") +
  theme_minimal()

#Now lets see the distribution of the number of products per order

library(gghighlight)

plots$order_size <- data_list$order_products__train %>% 
    group_by(order_id) %>% 
    summarise(products_p_order = n()) %>% 
    ungroup() %>% 
    group_by(products_p_order) %>% 
    summarise(frequency=n()) %>% 
    ungroup() %>% 
    arrange(desc(frequency)) %>% 
    mutate(rank=row_number(), weight=products_p_order*frequency, total_orders=sum(frequency), mean=sum(weight)/total_orders, weighted.mean(products_p_order, frequency)) %>% 
    ggplot(aes(x=rank, y=frequency)) +
    geom_col()+
    gghighlight(rank > weighted.mean(products_p_order, frequency) -.6 & rank < weighted.mean(products_p_order, frequency)+.4,
              unhighlighted_params = list(linewidth = 1, fill = alpha("#ffcc00b4", 0.9)))+
    theme_minimal()+
    labs(title="Distribution of the Number of Products per Order",
    subtitle= "mean highlighted",
    x="number of products per order")


# revealed preference 

# what is the expected order?


