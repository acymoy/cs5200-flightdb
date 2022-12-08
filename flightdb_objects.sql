# ----------------- CREATION OF PROCEDURES AND FUNCTIONS -------------------------

# (procedures can make changes, functions cannot) (functions return a single value)
# VIEWS

# gets all the flights 
DROP PROCEDURE IF EXISTS getAllFlights;
DELIMITER :)
CREATE PROCEDURE getAllFlights()
	BEGIN
		SELECT CONCAT(airline, flight_num) AS flight_id, departs_from, departure_time, arrives_to, arrival_time FROM flight;
	END :)
DELIMITER ;

# gets flights from a specific airline
DROP PROCEDURE IF EXISTS getAirlineFlights;
DELIMITER :)
CREATE PROCEDURE getAirlineFlights(IN in_airline VARCHAR(45))
	BEGIN
		DECLARE in_airline_id CHAR(2);
        SELECT id INTO in_airline_id FROM airline WHERE name = in_airline;
        
		SELECT CONCAT(airline, flight_num) AS flight_id, departs_from, departure_time, arrives_to, arrival_time FROM flight 
			WHERE airline = in_airline_id;
	END :)
DELIMITER ;

# searches for a flight by airline and number
DROP PROCEDURE IF EXISTS getFlight;
DELIMITER :)
CREATE PROCEDURE getFlight(IN in_airline CHAR(2), IN in_flightnum INT)
	BEGIN
		SELECT CONCAT(airline, flight_num) AS flight_id, departs_from, departure_time, arrives_to, arrival_time FROM flight 
			WHERE airline = in_airline AND flight_num = in_flightnum;
	END :)
DELIMITER ;

# gets arrival flights to a specific airport
DROP PROCEDURE IF EXISTS getArrivalFlights;
DELIMITER :)
CREATE PROCEDURE getArrivalFlights(IN in_airport CHAR(3))
	BEGIN
		SELECT CONCAT(airline, flight_num) AS flight_id, departs_from, departure_time, arrives_to, arrival_time FROM flight
			WHERE arrives_to = in_airport;
	END :)
DELIMITER ; 

# CREATE 

# add an aircraft
DROP PROCEDURE IF EXISTS addAircraft;
DELIMITER :)
CREATE PROCEDURE addAircraft(IN manufacturer_name VARCHAR(10), IN model_name VARCHAR(10), IN num_seats INT, IN fly_range_amnt INT)
	BEGIN
		DECLARE EXIT HANDLER FOR 1062
			SELECT 'Invalid: duplicate entry,';
		DECLARE EXIT HANDLER FOR 1216
			SELECT 'Invalid: Foreign key mismatch.';
        
        INSERT INTO aircraft VALUES (model_name, manufacturer_name, num_seats, fly_range_amnt);
    END :)
DELIMITER ;

# add an airplane
DROP PROCEDURE IF EXISTS addAirplane;
DELIMITER :)
CREATE PROCEDURE addAirplane(IN in_airline_id CHAR(2), IN in_reg VARCHAR(10), IN in_reg_date DATE, IN in_model VARCHAR(20))
	BEGIN
		DECLARE EXIT HANDLER FOR 1062
			SELECT 'Invalid: duplicate entry.';
		DECLARE EXIT HANDLER FOR 1216
			SELECT 'Invalid: Foreign key mismatch.';
		
        INSERT INTO airplane VALUES (in_airline_id, in_reg, in_reg_date, in_model);
	END :)
DELIMITER ;

# add a flight
DROP PROCEDURE IF EXISTS addFlight;
DELIMITER :)
CREATE PROCEDURE addFlight(IN in_airline CHAR(2), IN in_depart CHAR(3), IN in_arrive CHAR(3), IN in_dep_time DATETIME, IN in_arr_time DATETIME, 
						   IN in_airplane VARCHAR(10), IN in_p1 INT, IN in_p2 INT)
	BEGIN
		DECLARE EXIT HANDLER FOR 1216
			SELECT 'Invalid: Foreign key mismatch.';
		DECLARE EXIT HANDLER FOR 1062
			SELECT 'Invalid: duplicate entry.';
		DECLARE EXIT HANDLER FOR 1452
			SELECT 'Invalid: Foreign key mismatch.';
            
		INSERT INTO flight (airline, departs_from, arrives_to, departure_time, arrival_time, airplane, pilot1, pilot2) 
			VALUES (in_airline, in_depart, in_arrive, in_dep_time, in_arr_time, in_airplane, in_p1, in_p2);
	END :)
DELIMITER ;

# add passenger
DROP PROCEDURE IF EXISTS addPassenger;
DELIMITER :)
CREATE PROCEDURE addPassenger(IN in_name VARCHAR(50), IN in_dob DATE, IN in_phone CHAR(12))
	BEGIN
		DECLARE EXIT HANDLER FOR 1062
			SELECT 'Invalid: duplicate entry.';
        INSERT INTO passenger (name, dob, phone) VALUES (in_name, in_dob, in_phone);
	END :)
DELIMITER ;


# add a passenger to flight -- in the program, should probably verify if there's an existing ssn with that customer
# if not, collect the customer data and add it accordingly (THIS HAPPENS ON THE FRONT END). 
# this procedure should just add them to the flight ASSUMING they're already there. should never be adding a new passenger.
DROP PROCEDURE IF EXISTS addPassengerToFlight;
DELIMITER :)
CREATE PROCEDURE addPassengerToFlight(IN in_pid INT, IN in_airline CHAR(2), IN in_flightnum INT)
	BEGIN
		INSERT INTO passengers_on_flight VALUES (in_pid, in_airline, in_flightnum);
    END :)
DELIMITER ;

# add trigger to update num_passengers in flight on passenger addition
DROP TRIGGER IF EXISTS update_flight_from_pof;
DELIMITER :)
CREATE TRIGGER update_flight_from_pof
	AFTER INSERT ON passengers_on_flight
    FOR EACH ROW
		BEGIN
			DECLARE new_num_passengers INT;
            
            SELECT COUNT(*) INTO new_num_passengers FROM passengers_on_flight WHERE airline = NEW.airline AND flight_num = NEW.flight_num;
            
            UPDATE flight SET num_passengers = new_num_passengers WHERE airline = NEW.airline AND flight_num = NEW.flight_num;
        END :)
DELIMITER ;

# UPDATING

# change departure time or arrival time for a flight
DROP PROCEDURE IF EXISTS changeDeparture;
DELIMITER :)
CREATE PROCEDURE changeDeparture(IN in_airline CHAR(2), IN in_flightnum INT, IN new_departure DATETIME)
	BEGIN
		UPDATE flight SET departure_time = new_departure WHERE airline = in_airline AND flight_num = in_flightnum;
	END :)
DELIMITER ;

DROP PROCEDURE IF EXISTS changeArrival;
DELIMITER :)
CREATE PROCEDURE changeArrival(IN in_airline CHAR(2), IN in_flightnum INT, IN new_arrival DATETIME)
	BEGIN
		UPDATE flight SET arrival_time = new_arrival WHERE airline = in_airline AND flight_num = in_flightnum;
	END :)
DELIMITER ;

# DELETE 

# delete flight
DROP PROCEDURE IF EXISTS cancelFlight;
DELIMITER :)
CREATE PROCEDURE cancelFlight(IN in_airline CHAR(2), IN in_flightnum INT)
	BEGIN
		DELETE FROM flight WHERE airline = in_airline AND flight_num = in_flightnum;
	END :)
DELIMITER ;

# delete employee
DROP PROCEDURE IF EXISTS removeEmployee;
DELIMITER :)
CREATE PROCEDURE removeEmployee(IN in_eid INT)
	BEGIN
		DELETE FROM employee WHERE employee_id = in_eid;
	END :)
DELIMITER ;

