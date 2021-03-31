library(rdrop2)
library(ggplot2)
library(car)
library(dplyr)
library(lubridate)
library(dummies)

# _____________________________________________________________________________
# Loading Required Data
# _____________________________________________________________________________

station.dat.4 <- read.csv("ev_workplace_charging_data_v4.csv")

# _____________________________________________________________________________
# DATA PREPARATION
# _____________________________________________________________________________

#Eliminating observations with no reported zipcode for distance calculations
station.dat.4.3<-station.dat.4[station.dat.4$reportedZip == 1,]

#Calculating total distance per user
station.dat.agg<-aggregate(station.dat.4.3$distance ~ station.dat.4.3$userId, data = station.dat.4.3, sum)
station.dat.agg$distance<-station.dat.agg$`station.dat.4.3$distance`

#Generate total sessions by userID
station.dat.4 <-
  station.dat.4 %>%
  dplyr::group_by(userId) %>%
  dplyr::mutate(totalSessions = length(unique(sessionId)))

#Correcting encoding year variable (changing 0014 -> 2014)
station.dat.4$created <- sub("0", "2", station.dat.4$created) 
station.dat.4$ended <- sub("0", "2", station.dat.4$ended) 

# _____________________________________________________________________________
# DESCRIPTIVE STATISTICS
# _____________________________________________________________________________

#CASUAL AND HABITUAL USERS

high_volume <- station.dat.4[station.dat.4$totalSessions >= 19,]
low_volume<-station.dat.4[station.dat.4$totalSessions<19,]

station.dat.4$habitualUser <- ifelse(station.dat.4$totalSessions>=19, 1, 0)

#Creating low and high aggregated datasets
station.dat.agglow<-tally(group_by(low_volume, userId))
station.dat.agghigh<-tally(group_by(high_volume, userId))

#Creating low and high datasets for non-free transactions
sub<-which(low_volume$dollars==0)
low_volume.2<-low_volume[-sub,]

sub<-which(high_volume$dollars==0)
high_volume.2<-high_volume[-sub,]

#Creating low and high dataset for observations with distances

low_volume.3<-low_volume[low_volume$reportedZip == 1,]
high_volume.3<-high_volume[high_volume$reportedZip == 1,]


#Low frequency users descriptive stats

#Create matrix to display descriptive statistics
table_3_low <- matrix(nrow = 5,ncol = 5, dimnames = list(c("Charge time (hours)",
                                                         "Total consumption (kWh)",
                                                         "Repeat transactions per user (count)",
                                                         "Session revenue ($)",
                                                         "Estimated daily commute distance - one way (miles)"),
                                                       c("M", "SD", "Min", "Max", "Active sessions")))


#3 datasets used in calculating descriptive stats:
#all observations, observations with cost > 0, and observations reporting zip code

#Calculating mean of each variable
table_3_low[,"M"] <- c(round(mean(low_volume$chargeTimeHrs),2),
                     round(mean(low_volume$kwhTotal),2),
                     round(mean(station.dat.agglow$n),2),
                     round(mean(low_volume.2$dollars),2),
                     round(mean(low_volume$distance[!is.na(low_volume$distance)]),2))

#Calculating standard deviation of each variable
table_3_low[,"SD"] <- c(round(sd(low_volume$chargeTimeHrs),2),
                      round(sd(low_volume$kwhTotal),2),
                      round(sd(station.dat.agglow$n),2),
                      round(sd(low_volume.2$dollars),2),
                      round(sd(low_volume$distance[!is.na(low_volume$distance)]),2))

#Calculating minimum of each variable
table_3_low[,"Min"] <- c(round(min(low_volume$chargeTimeHrs),2),
                       round(min(low_volume$kwhTotal),2),
                       round(min(station.dat.agglow$n),2),
                       round(min(low_volume.2$dollars),2),
                       round(min(low_volume$distance[!is.na(low_volume$distance)]),2))

#Calculating maximum of each variable
table_3_low[,"Max"] <- c(round(max(low_volume$chargeTimeHrs),2),
                       round(max(low_volume$kwhTotal),2),
                       round(max(station.dat.agglow$n),2),
                       round(max(low_volume.2$dollars),2),
                       round(max(low_volume$distance[!is.na(low_volume$distance)]),2))


#Calculating total sessions used in analysis for each variable
table_3_low[,"Active sessions"] <- c(nrow(low_volume),
                                   nrow(low_volume),
                                   nrow(low_volume),
                                   nrow(low_volume.2),
                                   nrow(low_volume.3))


table_3_low


#High frequency users descriptive stats

#Create matrix to display descriptive statistics
table_3_high <- matrix(nrow = 5,ncol = 5, dimnames = list(c("Charge time (hours)",
                                                          "Total consumption (kWh)",
                                                          "Repeat transactions per user (count)",
                                                          "Session revenue ($)",
                                                          "Estimated daily commute distance - one way (miles)"),
                                                        c("M", "SD", "Min", "Max", "Active sessions")))


#3 datasets used in calculating descriptive stats:
#all observations, observations with cost > 0, and observations reporting zip code

#Calculating mean of each variable
table_3_high[,"M"] <- c(round(mean(high_volume$chargeTimeHrs),2),
                      round(mean(high_volume$kwhTotal),2),
                      round(mean(station.dat.agghigh$n),2),
                      round(mean(high_volume.2$dollars),2),
                      round(mean(high_volume$distance[!is.na(high_volume$distance)]),2))

#Calculating standard deviation of each variable
table_3_high[,"SD"] <- c(round(sd(high_volume$chargeTimeHrs),2),
                       round(sd(high_volume$kwhTotal),2),
                       round(sd(station.dat.agghigh$n),2),
                       round(sd(high_volume.2$dollars),2),
                       round(sd(high_volume$distance[!is.na(high_volume$distance)]),2))

#Calculating minimum of each variable
table_3_high[,"Min"] <- c(round(min(high_volume$chargeTimeHrs),2),
                        round(min(high_volume$kwhTotal),2),
                        round(min(station.dat.agghigh$n),2),
                        round(min(high_volume.2$dollars),2),
                        round(min(high_volume$distance[!is.na(high_volume$distance)]),2))

#Calculating maximum of each variable
table_3_high[,"Max"] <- c(round(max(high_volume$chargeTimeHrs),2),
                        round(max(high_volume$kwhTotal),2),
                        round(max(station.dat.agghigh$n),2),
                        round(max(high_volume.2$dollars),2),
                        round(max(high_volume$distance[!is.na(high_volume$distance)]),2))

#Calculating total sessions used in analysis for each variable
table_3_high[,"Active sessions"] <- c(nrow(high_volume),
                                    nrow(high_volume),
                                    nrow(high_volume),
                                    nrow(high_volume.2),
                                    nrow(high_volume.3))


table_3_high

pvalues.frequency.volume<-matrix(nrow=5, ncol=1, dimnames = list(c("Charge time (hours)",
                                                            "Total consumption (kWh)",
                                                            "Repeat transactions per user (count)",
                                                            "Session revenue ($)",
                                                            "Estimated daily commute distance - one way (miles)"),
                                                          "p.value"))

pvalues.frequency.volume[,"p.value"] <- c(round(t.test(low_volume$chargeTimeHrs,high_volume$chargeTimeHrs)$p.value,2),
                                   round(t.test(low_volume$kwhTotal,high_volume$kwhTotal)$p.value,2),
                                   round(t.test(station.dat.agglow$n,station.dat.agghigh$n)$p.value,2),
                                   round(t.test(low_volume.2$dollars,high_volume.2$dollars)$p.value,2),
                                   round(t.test(low_volume.3$distance,high_volume.3$distance)$p.value,2))

pvalues.frequency.volume

#MANAGERS AND NON MANAGERS

#Creating manager and non manager datasets

managers <- station.dat.4[station.dat.4$managerVehicle==1,]
nonmanagers<-station.dat.4[station.dat.4$managerVehicle==0,]

#Creating manager and non manager aggregated datasets
station.dat.agg.man<-tally(group_by(managers, userId))
station.dat.agg.nonman<-tally(group_by(nonmanagers, userId))

#Creating low and high datasets for non-free transactions
sub<-which(managers$dollars==0)
managers.2<-managers[-sub,]

sub<-which(nonmanagers$dollars==0)
nonmanagers.2<-nonmanagers[-sub,]

#Creating low and high dataset for observations with distances

managers.3<-managers[managers$reportedZip == 1,]
nonmanagers.3<-nonmanagers[nonmanagers$reportedZip == 1,]



#Managers users descriptive stats

#Create matrix to display descriptive statistics
table_3_managers <- matrix(nrow = 5,ncol = 5, dimnames = list(c("Charge time (hours)",
                                                              "Total consumption (kWh)",
                                                              "Repeat transactions per user (count)",
                                                              "Session revenue ($)",
                                                              "Estimated daily commute distance - one way (miles)"),
                                                            c("M", "SD", "Min", "Max", "Active sessions")))


#3 datasets used in calculating descriptive stats:
#all observations, observations with cost > 0, and observations reporting zip code

#Calculating mean of each variable
table_3_managers[,"M"] <- c(round(mean(managers$chargeTimeHrs),2),
                          round(mean(managers$kwhTotal),2),
                          round(mean(station.dat.agg.man$n),2),
                          round(mean(managers.2$dollars),2),
                          round(mean(managers$distance[!is.na(managers$distance)]),2))

#Calculating standard deviation of each variable
table_3_managers[,"SD"] <- c(round(sd(managers$chargeTimeHrs),2),
                           round(sd(managers$kwhTotal),2),
                           round(sd(station.dat.agg.man$n),2),
                           round(sd(managers.2$dollars),2),
                           round(sd(managers$distance[!is.na(managers$distance)]),2))

#Calculating minimum of each variable
table_3_managers[,"Min"] <- c(round(min(managers$chargeTimeHrs),2),
                            round(min(managers$kwhTotal),2),
                            round(min(station.dat.agg.man$n),2),
                            round(min(managers.2$dollars),2),
                            round(min(managers$distance[!is.na(managers$distance)]),2))

#Calculating maximum of each variable
table_3_managers[,"Max"] <- c(round(max(managers$chargeTimeHrs),2),
                            round(max(managers$kwhTotal),2),
                            round(max(station.dat.agg.man$n),2),
                            round(max(managers.2$dollars),2),
                            round(max(managers$distance[!is.na(managers$distance)]),2))

#Calculating total sessions used in analysis for each variable
table_3_managers[,"Active sessions"] <- c(nrow(managers),
                                        nrow(managers),
                                        nrow(managers),
                                        nrow(managers.2),
                                        nrow(managers.3))


table_3_managers


#Non managers users descriptive stats

#Create matrix to display descriptive statistics
table_3_nonmanagers <- matrix(nrow = 5,ncol = 5, dimnames = list(c("Charge time (hours)",
                                                                 "Total consumption (kWh)",
                                                                 "Repeat transactions per user (count)",
                                                                 "Session revenue ($)",
                                                                 "Estimated daily commute distance - one way (miles)"),
                                                               c("M", "SD", "Min", "Max", "Active sessions")))


#Calculating mean of each variable
table_3_nonmanagers[,"M"] <- c(round(mean(nonmanagers$chargeTimeHrs),2),
                             round(mean(nonmanagers$kwhTotal),2),
                             round(mean(station.dat.agg.nonman$n),2),
                             round(mean(nonmanagers.2$dollars),2),
                             round(mean(nonmanagers$distance[!is.na(nonmanagers$distance)]),2))

#Calculating standard deviation of each variable
table_3_nonmanagers[,"SD"] <- c(round(sd(nonmanagers$chargeTimeHrs),2),
                              round(sd(nonmanagers$kwhTotal),2),
                              round(sd(station.dat.agg.nonman$n),2),
                              round(sd(nonmanagers.2$dollars),2),
                              round(sd(nonmanagers$distance[!is.na(nonmanagers$distance)]),2))

#Calculating minimum of each variable
table_3_nonmanagers[,"Min"] <- c(round(min(nonmanagers$chargeTimeHrs),2),
                               round(min(nonmanagers$kwhTotal),2),
                               round(min(station.dat.agg.nonman$n),2),
                               round(min(nonmanagers.2$dollars),2),
                               round(min(nonmanagers$distance[!is.na(nonmanagers$distance)]),2))

#Calculating maximum of each variable
table_3_nonmanagers[,"Max"] <- c(round(max(nonmanagers$chargeTimeHrs),2),
                               round(max(nonmanagers$kwhTotal),2),
                               round(max(station.dat.agg.nonman$n),2),
                               round(max(nonmanagers.2$dollars),2),
                               round(max(nonmanagers$distance[!is.na(nonmanagers$distance)]),2))

#Calculating total sessions used in analysis for each variable
table_3_nonmanagers[,"Active sessions"] <- c(nrow(nonmanagers),
                                           nrow(nonmanagers),
                                           nrow(nonmanagers),
                                           nrow(nonmanagers.2),
                                           nrow(nonmanagers.3))


table_3_nonmanagers




pvalues.frequency.employeetype<-matrix(nrow=5, ncol=1, dimnames = list(c("Charge time (hours)",
                                                             "Total consumption (kWh)",
                                                             "Repeat transactions per user (count)",
                                                             "Session revenue ($)",
                                                             "Estimated daily commute distance - one way (miles)"),
                                                           "p.value"))

pvalues.frequency.employeetype[,"p.value"] <- c(round(t.test(managers$chargeTimeHrs,nonmanagers$chargeTimeHrs)$p.value,2),
                                    round(t.test(managers$kwhTotal,nonmanagers$kwhTotal)$p.value,2),
                                    round(t.test(station.dat.agg.man$n,station.dat.agg.nonman$n)$p.value,2),
                                    round(t.test(managers.2$dollars,nonmanagers.2$dollars)$p.value,2),
                                    round(t.test(managers.3$distance,nonmanagers.3$distance)$p.value,2))

pvalues.frequency.employeetype

#EARLY AND LATE ADOPTERS


#Examine date-time variable to select first transactions per user
as.POSIXct(station.dat.4$ended)

#Creating dummy for early adopters
first.transaction <- as.data.frame(station.dat.4 %>% group_by(userId) %>% top_n(-1, ended))
first.transaction<-arrange(first.transaction, by_group=ended)
first.transaction$early<-0
first.transaction[1:21,]$early<-1

station.dat.4$earlyAdopter<-first.transaction$early[match(station.dat.4$userId,first.transaction$userId)]


#Creating early and late adopters datasets

early<-station.dat.4[station.dat.4$earlyAdopter==1,]
late<-station.dat.4[station.dat.4$earlyAdopter==0,]


#Creating early and late aggregated datasets

station.dat.agg.early<-tally(group_by(early, userId))
station.dat.agg.late<-tally(group_by(late, userId))

#Creating early and late datasets for non-free transactions
sub<-which(early$dollars==0)
early.2<-early[-sub,]

sub<-which(late$dollars==0)
late.2<-late[-sub,]

#Creating low and high dataset for observations with distances

early.3<-early[early$reportedZip == 1,]
late.3<-late[late$reportedZip == 1,]


#Early and late users descriptive stats

#Create matrix to display descriptive statistics
table_3_early <- matrix(nrow = 5,ncol = 5, dimnames = list(c("Charge time (hours)",
                                                           "Total consumption (kWh)",
                                                           "Repeat transactions per user (count)",
                                                           "Session revenue ($)",
                                                           "Estimated daily commute distance - one way (miles)"),
                                                         c("M", "SD", "Min", "Max", "Active sessions")))


#3 datasets used in calculating descriptive stats:
#all observations, observations with cost > 0, and observations reporting zip code

#Calculating mean of each variable
table_3_early[,"M"] <- c(round(mean(early$chargeTimeHrs),2),
                       round(mean(early$kwhTotal),2),
                       round(mean(station.dat.agg.early$n),2),
                       round(mean(early.2$dollars),2),
                       round(mean(early$distance[!is.na(early$distance)]),2))

#Calculating standard deviation of each variable
table_3_early[,"SD"] <- c(round(sd(early$chargeTimeHrs),2),
                        round(sd(early$kwhTotal),2),
                        round(sd(station.dat.agg.early$n),2),
                        round(sd(early.2$dollars),2),
                        round(sd(early$distance[!is.na(early$distance)]),2))

#Calculating minimum of each variable
table_3_early[,"Min"] <- c(round(min(early$chargeTimeHrs),2),
                         round(min(early$kwhTotal),2),
                         round(min(station.dat.agg.early$n),2),
                         round(min(early.2$dollars),2),
                         round(min(early$distance[!is.na(early$distance)]),2))

#Calculating maximum of each variable
table_3_early[,"Max"] <- c(round(max(early$chargeTimeHrs),2),
                         round(max(early$kwhTotal),2),
                         round(max(station.dat.agg.early$n),2),
                         round(max(early.2$dollars),2),
                         round(max(early$distance[!is.na(early$distance)]),2))

#Calculating total sessions used in analysis for each variable
table_3_early[,"Active sessions"] <- c(nrow(early),
                                     nrow(early),
                                     nrow(early),
                                     nrow(early.2),
                                     nrow(early.3))


table_3_early


#Non managers users descriptive stats

#Create matrix to display descriptive statistics
table_3_late <- matrix(nrow = 5,ncol = 5, dimnames = list(c("Charge time (hours)",
                                                          "Total consumption (kWh)",
                                                          "Repeat transactions per user (count)",
                                                          "Session revenue ($)",
                                                          "Estimated daily commute distance - one way (miles)"),
                                                        c("M", "SD", "Min", "Max", "Active sessions")))


#Calculating mean of each variable
table_3_late[,"M"] <- c(round(mean(late$chargeTimeHrs),2),
                      round(mean(late$kwhTotal),2),
                      round(mean(station.dat.agg.late$n),2),
                      round(mean(late.2$dollars),2),
                      round(mean(late$distance[!is.na(late$distance)]),2))

#Calculating standard deviation of each variable
table_3_late[,"SD"] <- c(round(sd(late$chargeTimeHrs),2),
                       round(sd(late$kwhTotal),2),
                       round(sd(station.dat.agg.late$n),2),
                       round(sd(late.2$dollars),2),
                       round(sd(late$distance[!is.na(late$distance)]),2))

#Calculating minimum of each variable
table_3_late[,"Min"] <- c(round(min(late$chargeTimeHrs),2),
                        round(min(late$kwhTotal),2),
                        round(min(station.dat.agg.late$n),2),
                        round(min(late.2$dollars),2),
                        round(min(late$distance[!is.na(late$distance)]),2))

#Calculating maximum of each variable
table_3_late[,"Max"] <- c(round(max(late$chargeTimeHrs),2),
                        round(max(late$kwhTotal),2),
                        round(max(station.dat.agg.late$n),2),
                        round(max(late.2$dollars),2),
                        round(max(late$distance[!is.na(late$distance)]),2))

#Calculating total sessions used in analysis for each variable
table_3_late[,"Active sessions"] <- c(nrow(late),
                                    nrow(late),
                                    nrow(late),
                                    nrow(late.2),
                                    nrow(late.3))


table_3_late




pvalues.frequency.adopter<-matrix(nrow=5, ncol=1, dimnames = list(c("Charge time (hours)",
                                                             "Total consumption (kWh)",
                                                             "Repeat transactions per user (count)",
                                                             "Session revenue ($)",
                                                             "Estimated daily commute distance - one way (miles)"),
                                                           "p.value"))

pvalues.frequency.adopter[,"p.value"] <- c(round(t.test(early$chargeTimeHrs,late$chargeTimeHrs)$p.value,2),
                                    round(t.test(early$kwhTotal,late$kwhTotal)$p.value,2),
                                    round(t.test(station.dat.agg.early$n,station.dat.agg.late$n)$p.value,2),
                                    round(t.test(early.2$dollars,late.2$dollars)$p.value,2),
                                    round(t.test(early.3$distance,late.3$distance)$p.value,2))

pvalues.frequency.adopter

# _____________________________________________________________________________
# DATA VALIDATION
# _____________________________________________________________________________

#Ensuring all observations comply with price scheme
check1<-which(station.dat.4$dollars==0 & station.dat.4$chargeTimeHrs >= 4)
check2<-which(station.dat.4$dollars > 0 & station.dat.4$chargeTimeHrs < 4)

#Ensuring all observations of kwh use are valid
check3<-which(station.dat.4$kwhTotal < 0)
check4<-which(station.dat.4$dollars < 0)
check5<-which(is.na(station.dat.4$kwhTotal))
check6<-which(is.na(station.dat.4$dollars))

# _____________________________________________________________________________
# Generating Figures
# _____________________________________________________________________________

#Generate count of transactons by user ID for histogram
station.dat.agg2<-tally(group_by(station.dat.4, userId))

figure_1a <- ggplot(station.dat.agg2, aes(x=n))+
  geom_histogram(color="black", fill="skyblue1", binwidth = 25, alpha = 0.6, boundary=0, closed="left")+
  labs(x="Charging sessions", y="Number of users")+
  theme(axis.line = element_line(colour = "black"),
        axis.text=element_text(size=18),
        axis.title=element_text(size=20),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.text.x= element_text(colour = "black"),
        axis.text.y= element_text(colour = "black"),
        axis.ticks.x = element_blank()) +
  scale_x_continuous(breaks = c(25,50,75,100,125,150,175,200), expand = c(0,0)) +
  scale_y_continuous(breaks = c(10, 20, 30, 40, 50), expand = c(0,0)) +
  theme(plot.margin=unit(c(0,1,0.1,0),"cm"))

figure_1b <- ggplot(station.dat.4, aes(x=chargeTimeHrs))+
  geom_histogram(color="black", fill="grey69", binwidth = 1, alpha = 0.6, boundary=0, closed="left")+
  labs(x="Charge duration (hours)", y="Number of sessions")+
  theme(axis.line = element_line(colour = "black"),
        axis.text=element_text(size=18),
        axis.title=element_text(size=20),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.text.x= element_text(colour = "black"),
        axis.text.y= element_text(colour = "black"),
        axis.ticks.x = element_blank()) +
  scale_x_continuous(breaks = c(1,2,3,4,5,6,7,8,9), expand = c(0,0)) +
  scale_y_continuous(breaks = c(250, 500, 750, 1000, 1250,1500), expand = c(0,0)) +
  theme(plot.margin=unit(c(0,1,0.1,0),"cm")) +
  coord_cartesian(xlim = c(0, 7))

figure_1a
figure_1b

grid.arrange(figure_1a, figure_1b, ncol=2)

figure_2 <- ggplot(station.dat.4, aes(x = chargeTimeHrs, y = kwhTotal)) +
  labs(x="Charge time (hours)", y="kWh Drawn")+    geom_point(
    fill="skyblue1",
    shape=22,
    alpha=0.7,
    size=3,
    stroke = 0.3) +
  coord_cartesian(xlim = c(0, 10), ylim = c(0,25)) +
  theme(axis.line = element_line(colour = "black"),
        axis.text=element_text(size=18),
        axis.title=element_text(size=20),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.text.x= element_text(colour = "black"),
        axis.text.y= element_text(colour = "black"),
        axis.ticks.x = element_blank()) +
  scale_x_continuous(breaks = c(2,4,6,8,10), expand = c(0,0)) +
  scale_y_continuous(breaks = c(5, 10, 15, 20), expand = c(0,0)) +
  theme(plot.margin=unit(c(0,1,0.1,0),"cm"))

figure_2




                  