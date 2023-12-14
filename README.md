# CS5200 Database Management: Flight Simulator
## Fall 2022

### Summary
This project contains a SQL database containing data for a system of airports, airplanes, pilots, and other related information pertaining to flights. There's also an accompanying Python CLI-based program that can perform operations on the database. 

### SQL Database
The SQL database is based mainly around a flight table, containing information about the airline, airports, pilots, passengers, airplane types/crafts, and employees/attendants. Each table contains the appropriate primary keys and dependencies. 

The database also contains certain procedures that cover CRUD operations:
Reading:
- Getting all flights
- Getting flights from a specific airline
- Searching for a flight by airline and number
- Getting arrival flights to an airport
- View passengers and flights for a passenger
Creating:
- Adding an aircraft
- Adding an airplane
- Adding a flight
- Adding a passenger
- Adding a passenger to a flight
Updating:
- Change departure/arrival time
Deleting:
- Deleting a flight
- Deleting an employee

These operations can only be performed depending on the level of access you have to the database, eg an administrator will be able to modify flights and employees, whereas a passenger would only be able to read the data. 

### The Application
The python CLI application acts as a front-end for the database to perform CRUD operations. It starts with requesting a login to determine the level of access, then gives the according permissions.

The application also sanitizes inputs for security purposes, so the user isn't able to inject scripts.

**To run the application, just run flightdb_app.py. Ensure that the database has been created, inserted into, and started for the app to be able to connect.**
