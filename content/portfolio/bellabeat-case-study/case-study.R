# USES PIPE OPERATOR AVAILABLE IN BASE R v4.1+ ####

#
## LOAD PACKAGES ####
#
if(!require("pacman")) {
  install.packages("pacman")
}

pacman::p_load("pacman", "tidyverse", "janitor", "rio", "RColorBrewer")
options(scipen=9999)

#
## LOAD THE DATA ####
#
sleep_data <- import("sleepDay_merged.csv")
activity_data <- import("dailyActivity_merged.csv")
station_data <- import("activity-data.csv")

#
## EXAMINE THE DATA ####
#
head(sleep_data)
head(activity_data)
colnames(sleep_data)
colnames(activity_data)

#
## TIDY THE DATA ####
#
sleep_data <- clean_names(sleep_data)
activity_data <- clean_names(activity_data)
station_data <- clean_names(station_data)

# Clean date information from datetime to date only
activity_data <- activity_data |>
  mutate(day = as.Date(mdy(activity_date), '%D'), .keep = "unused") |>
  mutate(id = as.character(id), .keep = "unused") |>
  select(id, day, total_steps, total_distance, tracker_distance, 
         logged_activities_distance, very_active_distance, 
         moderately_active_distance, light_active_distance, 
         sedentary_active_distance, very_active_minutes, 
         fairly_active_minutes, lightly_active_minutes, 
         sedentary_minutes, calories)

sleep_data <- sleep_data |>
  mutate(day = as.Date(mdy_hms(sleep_day), '%D'), .keep = "unused") |>
  mutate(id = as.character(id), .keep = "unused") |>
  select(id, day, total_sleep_records, total_minutes_asleep, 
         total_time_in_bed)

sleep_data |>
  remove_empty(c("rows", "cols"))
activity_data |>
  remove_empty(c("rows", "cols"))

# There are no duplicate values for day, step total, and id
activity_data |>
  get_dupes(day, total_steps, id)

# There are duplicate values for id, day, total sleep records, 
#  total minutes asleep, and total time in bed
sleep_data |>
  get_dupes(id, day, total_sleep_records, total_minutes_asleep
            , total_time_in_bed)
sleep_data <- sleep_data %>%
  distinct()

# Verify there are no more duplicate values
duplicated(sleep_data)

#
# LOOK FOR TRENDS IN DATA ####
#
summary(activity_data)
summary(sleep_data)
summary(station_data)
sleep_join <- activity_data |>
  full_join(sleep_data, by = c("id", "day"))

# No column has a one-to-one relationship with each other
sleep_data |>
  get_one_to_one()
activity_data |>
  get_one_to_one()
sleep_join |>
  get_one_to_one()

p1 <- ggplot(sleep_join, aes(x = id, y = total_steps, fill = day)) + 
  geom_bar(stat = "identity") + 
  scale_colour_brewer(palette = "Set2") + 
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Total Steps By User", subtitle = "From Fitbit dataset", 
       y = "Total Steps", x = NULL)
ggsave("analysis-1.png", plot = p1, width = 8, height = 5)

# 
p2 <- ggplot(sleep_join, aes(y = total_minutes_asleep, x = id)) + 
  geom_boxplot() + 
  labs(x = NULL, y = "Time Asleep (minutes)", 
       title = "Time Asleep By User",
       subtitle = "From Fitbit dataset") + 
  theme(axis.text.x = element_text(angle = 90))
ggsave("analysis-2.png", plot = p2, width = 8, height = 5)

# Examine sleep 
p3 <- ggplot(sleep_join, aes(x = id, y = total_distance)) +
  geom_boxplot() + 
  ylim(c(0, 18)) + 
  labs(x = NULL, y = "Distance", 
       title = "Total Distance By User", 
       subtitle = "From Fitbit dataset") + 
  theme(axis.text.x = element_text(angle = 90))
ggsave("analysis-3.png", plot = p3, width = 8, height = 5)

p4 <- ggplot(sleep_join, aes(x = day, y = total_minutes_asleep)) + 
  geom_col(aes(col = id)) + 
  labs(x = NULL, y = "Time Asleep (minutes)", 
       title = "Total Time Asleep By Date", 
       subtitle = "From Fitbit dataset") + 
  theme(axis.text.x = element_text(angle = 90), 
        legend.position = "none")
ggsave("analysis-4.png", plot = p4, width = 8, height = 5)

# Examine very active activity distance compared to minutes
p5 <- ggplot(sleep_join, aes(y = very_active_distance, x = very_active_minutes)) + 
  geom_point() +
  geom_smooth(method = "loess", formula = y ~ x) +
  labs(x = "Very Active (minutes)", y = "Very Active Distance", 
       title = "Time Very Active Compared To Distance Very Active",
       subtitle = "From Fitbit dataset")
ggsave("analysis-5.png", plot = p5, width = 8, height = 5)

# Examine very active mintues compared to sedentary minutes
p6 <- ggplot(station_data, aes(y = total_very_active_minutes, 
                               x = total_sedentary_minutes)) +
  geom_point() + 
  geom_smooth(formula = y ~ x) + 
  ylim(c(-500, 3000)) + 
  labs(y = "Time Very Active (minutes)", x = "Time Sedentary (minutes)", 
       title = "Time Sedentary Compared To Time Very Active",
       subtitle = "From Fitbit dataset")
ggsave("analysis-6.png", plot = p6, width = 8, height = 5)

ggplot(sleep_join, aes(x = total_distance, y = calories)) + 
  geom_point(col = "blue") + 
  labs(x = "Distance", y = "Calories", 
       title = "Distance Compared To Calories", 
       subtitle = "From Fitbit dataset") + 
  theme(legend.position = "none")
ggsave("analysis-7.png", width = 8, height = 5)

ggplot(activity_data, aes(x = sedentary_minutes, y = calories)) + 
  geom_point() + 
  labs(x = "Time Sedentary (minutes)", y = "Calories", 
       title = "Time Sedentary Compared To Calories", 
       subtitle = "From Fitbit dataset")
ggsave("analysis-8.png", width = 8, height = 5)

#
## CLEAN UP ENVIRONMENT ####
#
rm(list = ls())
p_unload(all)
graphics.off()
cat("\014")
