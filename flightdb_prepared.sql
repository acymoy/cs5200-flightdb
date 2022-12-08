# Converting the stored procedures into prepared statements
USE flight_db;

PREPARE getAirlineFlights FROM 'CALL getAirlineFlights(?)';
PREPARE getFlight FROM 'CALL getFlight(?, ?)';
PREPARE getArrivalFlights FROM 'CALL getArrivalFlights(?)';
PREPARE addAircraft FROM 'CALL addAircraft(?, ?, ?, ?)';
PREPARE addAirplane FROM 'CALL addAirplane(?, ?, ?, ?)';
PREPARE addFlight FROM 'CALL addFlight(?, ?, ?, ?, ?, ?, ?, ?)';
PREPARE addPassenger FROM 'CALL addPassenger(?, ?, ?, ?)';
PREPARE addPassengerToFlight FROM 'CALL addPassengerToFlight(?, ?, ?)';


EXECUTE getAirlineFlights USING "American Airlines";