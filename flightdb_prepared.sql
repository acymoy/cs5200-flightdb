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
PREPARE getFlighPassengers FROM 'CALL getFlightPassengers(?, ?)';
PREPARE getPassengerFlights FROM 'CALL getPassengerFlights(?)';


EXECUTE getAirlineFlights USING "American Airlines";
