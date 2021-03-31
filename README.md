# Introduction
This file contains replication code for "Electric vehicle charging stations in the workplace with high-resolution data from casual and habitual users". The data preprocessing is done in R using the code contained in this repository. To access the data, we have provided a link to the Dataverse repository that houses it.

## Code Functionality and Structure

The code contained in workplace_ev_charging_package_v2.R assists in regenerating all figures and tables as well as generating variables totalSessions, habitualUser, and earlyAdopter. 

Tables comprising Table 3 are stored in R matrices using the following format: table_3_(relevant description). For example, the portion relevant to high-volume users is stored as table_3_high in the code.

Figures are named with the following convention for easy replication: figure_(figure number). For example, Figure 1 appears as figure_1 in the code. 

## Data Availability

Data necessary for the use of this code can be found publicly at the following address: https://doi.org/10.7910/DVN/QF1PMO

## Data Dictionary

What follows is the definition of each variable contained in the dataset, upon which the code is built. 

* sessionId: Identifies a specific EV charging session, where each row in the dataset represents a single session.
* userId: Identifies a specific electric vehicle owner. A user who charges multiple times can be identified throughout the dataset using this field. 
* stationId: Identifies a specific EV charging station which indicates where a given charging session occurred. 
* locationId: Identifies a given building or location, operated by the firm, where one or more EV chargers is available. 
* created: The timestamp at which a charging session was initialized, in YYYY-MM-DD HH:MM:SS format. 
* ended: The timestamp at which a charging session was terminated, in YYYY-MM-DD HH:MM:SS format. 
* chargeTimeHrs: The duration of a charging session measured in hours. 
* dollars: The amount charged for the charging session in dollars, per the price policy implemented by the firm. 
* kwhTotal: The total energy use for a given charging session, measured to the nearest hundredth of a kilowatt-hour. 
* Mon/Tue/Wed/Thu/Fri/Sat/Sun: Binary variables indicating the specific day of week on which a given transaction was logged.  
* facilityType: Maps a given transaction to the type of facility where it took place. Manufacturing facilities correspond to 1, office facilities to 2, research and development to 3, and other to 4. 
* managerVehicle: A binary variable indicating whether the vehicle associated with a given charging session is of the type generally owned by the firm’s managers as a result of a corporate incentive program (1 if manager vehicle, 0 if not).
* earlyAdopter: A binary variable indicating whether a given user was an early adopter or late adopter of the EV charging program (1 if early adopter, 0 if late adopter). Early adopters are defined as the first quartile of users to log a charging session, while late adopters are defined as the remaining users.  
* habitualUser: A binary variable indicating whether a user is a casual or habitual user of workplace charging (1 if habitual, 0 if casual). A habitual user is defined as someone who logged more than the median of 19 charging sessions over the course of the data collection period, while a casual user is someone who logged fewer than 19 sessions. 
* reportedZip: A binary variable indicating whether a user self-reported a zip code to the network operator. 
* platform: The type of device used to register a session. One of Android, iOS, or Web. 
* distance: The estimated distance in miles from the centroid of a user’s provided zip code to the exact position where the charging station is located. Not all users provided a zip code. 
* totalSessions: The count of total sessions logged by a given user over the course of the observation period.  

## License
This code and is made available under the Creative Commons CC BY license. Please visit this link for more information: https://creativecommons.org/licenses/by/4.0/
