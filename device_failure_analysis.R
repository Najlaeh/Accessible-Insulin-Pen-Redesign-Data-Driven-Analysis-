## Research Question:
# What are the most common reasons medical devices fail, and how might these failures impact users?

## Objective:
# To analyze patterns in device failures and propose design improvements that reduce negative user impact.

library(dplyr)

# Loading & Storing Device Dataset from Faulty Medical Devices - Global Dataset 

data_events <- read.csv("Faulty Medical Devices - Global Dataset/events-1681209680.csv")

# counts how often each reason appears in the dataset and sorts them from most to least frequent.

top_reason <- data_events %>%

# Viewing all variable names

colnames(data_events)

# counts how often each determined cause occurs and sorts them from most to least frequent

data_events %>%
  count(determined_cause, sort = TRUE)

# Cleaning data set to keep and later manipulate/analyze from datasheet

device_causes_clean <- data_events %>%
  select(device_id, determined_cause) %>%
  filter(!is.na(determined_cause) & determined_cause != "")

# Shows only the rows from the variables kept from previous line

device_causes_clean %>%
  head()

# creates a cleaned dataset with only device_id and valid determined_cause values, removing missing, empty, and non-informative categories (like “Other” or “Pending”).

device_causes_clean <- data_events %>%
  select(device_id, determined_cause) %>%
  filter(!is.na(determined_cause) &
           determined_cause != "" &
           !determined_cause %in% c("Other",
                                    "Under Investigation by firm",
                                    "Unknown/Undetermined by firm",
                                    "Pending"))

# counts how often each cleaned determined cause appears and sorts them from most to least frequent

device_causes_clean %>%
  count(determined_cause, sort = TRUE)

# creates a new variable (cause_simple) that groups detailed causes into broader categories like software, design, process, labeling, and material issues for easier analysis.

device_causes_clean <- device_causes_clean %>%
  mutate(cause_simple = case_when(
    str_detect(determined_cause, "Software") ~ "Software Issue",
    str_detect(determined_cause, "Device Design|Component design") ~ "Design Issue",
    str_detect(determined_cause, "Process") ~ "Process Issue",
    str_detect(determined_cause, "Labeling") ~ "Labeling Issue",
    str_detect(determined_cause, "Material|Component") ~ "Material Issue",
    TRUE ~ "Other"
  ))

# Counts how often each simplified cause category appears and ranks them from most to least common.

device_causes_clean %>%
  count(cause_simple, sort = TRUE)

# This suggests that the design, material, and process issues are the three main categories that comprise the most common causes of medical device failure.

## User Impact

# Design issues in medical devices can make it difficult for patients and can lead to patient harm. The causes can be patients experiences injuries from device malfunctioning, reduced accessibility with complex and non-intuitive interfaces. Overall poor product design can make it difficult for patients to rely on these devices independently. 

# Material issues can cause unpredictable device failures like reactions if the materials are not properly biocompatible which could lead to device degradation leading to premature failure. This can lead to interruptions in use and may require users to frequently replace or repair devices.

# Process issues in manufacturing or production can result in inconsistent device performance, inaccurate readings, devices failing in critical moments. This may reduce reliability and create uncertainty for users who depend on these devices for daily tasks, or provoke psychological stress and fear of future device failure. 

## Key Problem & Proposed solution
# Based on the analysis, I redesigned a reusable insulin pen to address grip and handling difficulties. The goal was to improve ease of use for people with limited motor control. The pen’s contoured shape creates a natural grip, improving stability during cap removal and injection. The cap uses a magnetic closure, and both the cap and body feature a textured silicone surface to prevent slipping. Inspired by adaptive writing grips and accessibility-focused makeup, the design prioritizes stability. These changes aim to improve usability and support independent use, while keeping the internal mechanism compatible with existing designs.

## Conclusion
# Medical device failures are often design-related, specifically affecting how users interact with devices. This is a major hurdle for people with motor impairments. Focusing on grip and handling, I redesigned a reusable insulin pen to show how changes to shape, material, and interaction make a device easier to use. There are trade-offs, like a larger size and higher material cost, but these are balanced by better stability. This project shows how data can identify real problems and turn them into accessible design solutions.
