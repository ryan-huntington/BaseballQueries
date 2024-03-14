# CSI 3335 Group Project

#### Project setup:
Open the project in a preferred text editor (vscode, atom, etc)

Do ```python -m venv venv``` to setup virtual environment
```venv\Scripts\activate``` from the Windows command line to enter the virtual environment

Then do ```pip install -r requirements.txt``` to install all necessary libraries

**Change config.py to match local database credentials**

#### Running the project:
From the sql folder, copy the batting2022.csv, people2022.csv, teams2022.csv, and GLAR.sql files into your local MariaDB folder. 

In your local MariaDB instance run the following commands: 
```CREATE DATABASE GLAR;```
```USE GLAR```
```\. GLAR.SQL```

This will create a new database with all of the changes to the baseball database. A full list of our changes can be found below.

After installing all dependencies and setting up our database, you should be able to do ```py main.py``` or ```python main.py``` to run the web app locally!

#### What we did:
The data for the 2022 teams table was added.

The data for the 2022 batting season was added to the batting table.

The data for the 2022 pitching season was added to the pitching table.

The new players in the 2022 season were added to the people table.

The results of the 2022 postseason were added to the seriespost table.

All ID column names that were the same were renamed to be the table's first character (plus another character if it had the first character as another table)
```_pk```. 

Bug fixed: The batting, pitching, and fielding tables were combined with their post season tables. If a statistic is from the post season, then it has a round and the stint is set to NULL. If a statistic is from the regular season, then it has a stint value and the round column is NULL.

Users can sign up and view information about a selected team in a specific year.
(NOTE: User and Log table are created automatically by Flask when the flask app runs)

There is an admin user that can see information about all users such as what teams they are viewing. 

**Admin login - username: admin, password: 123**

#### Packages use:

Flask==2.2.2      
Flask-Login==0.6.2
Flask-SQLAlchemy==3.0.2
Flask-WTF==1.0.1
numpy==1.23.4
pandas==1.5.1
PyMySQL==1.0.2
Werkzeug==2.2.2