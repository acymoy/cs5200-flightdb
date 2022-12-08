# -------------------------- CREATION OF FLIGHTS DATABASE --------------------------
DROP DATABASE flight_db;

CREATE DATABASE IF NOT EXISTS flight_db;
USE flight_db;

# airports list
CREATE TABLE IF NOT EXISTS airport (
	airport_id CHAR(3) PRIMARY KEY, 
    airport_name VARCHAR(100),
    zip VARCHAR(5));
    
# airlines
CREATE TABLE IF NOT EXISTS airline (
	id CHAR(2) PRIMARY KEY,
    name VARCHAR(45));
    
# aircraft manufacturers
CREATE TABLE IF NOT EXISTS manufacturer (
	name VARCHAR(10) PRIMARY KEY);
    
# models
CREATE TABLE IF NOT EXISTS aircraft (
	aircraft_model VARCHAR(10) PRIMARY KEY,
    manufacturer VARCHAR(10),
    seats INT,
    fly_range INT,
    CONSTRAINT aircraft_manufacturer_fk FOREIGN KEY (manufacturer) REFERENCES manufacturer(name) ON UPDATE CASCADE ON DELETE RESTRICT);
    
# airplanes
CREATE TABLE IF NOT EXISTS airplane (
	airline_id CHAR(2),
    registration_num VARCHAR(10) PRIMARY KEY,
    registration_date DATE,
    model VARCHAR(20),
    CONSTRAINT airplane_owner_fk FOREIGN KEY (airline_id) REFERENCES airline(id) ON UPDATE CASCADE,
    CONSTRAINT airplane_model_fk FOREIGN KEY (model) REFERENCES aircraft(aircraft_model));
    
# employees
CREATE TABLE IF NOT EXISTS employee (
	employee_id INT PRIMARY KEY AUTO_INCREMENT,
    airline VARCHAR(2),
    first_name VARCHAR(10),
    last_name VARCHAR(10),
    dob DATE,
    hire_date DATE,
    CONSTRAINT employee_airline_fk FOREIGN KEY (airline) REFERENCES airline(id) ON UPDATE CASCADE);
    
# pilots
CREATE TABLE IF NOT EXISTS pilot (
	employee_id INT PRIMARY KEY,
    flight_license INT,
    CONSTRAINT pilot_empid_fk FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON UPDATE CASCADE ON DELETE CASCADE);
    
# flight attendants
CREATE TABLE IF NOT EXISTS flight_attendant (
	employee_id INT PRIMARY KEY,
    registration_num INT,
    CONSTRAINT flight_attendant_eid_fk FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON UPDATE CASCADE ON DELETE CASCADE);

# flights
CREATE TABLE IF NOT EXISTS flight (
    airline CHAR(2),
	flight_num INT AUTO_INCREMENT,
	departs_from CHAR(3),
    arrives_to CHAR(3),
    departure_time DATETIME,
    arrival_time DATETIME,
    num_passengers INT DEFAULT 0,
    airplane VARCHAR(10),
    pilot1 INT,
    pilot2 INT,
    CONSTRAINT flight_airline_fk FOREIGN KEY (airline) REFERENCES airline(id) ON UPDATE CASCADE,
    CONSTRAINT flight_depart_fk FOREIGN KEY (departs_from) REFERENCES airport(airport_id) ON UPDATE CASCADE,
    CONSTRAINT flight_arrival_fk FOREIGN KEY (arrives_to) REFERENCES airport(airport_id) ON UPDATE CASCADE,
    CONSTRAINT flight_airplane_fk FOREIGN KEY (airplane) REFERENCES airplane(registration_num) ON UPDATE CASCADE,
    CONSTRAINT flight_pilot1_fk FOREIGN KEY (pilot1) REFERENCES pilot(employee_id) ON DELETE SET NULL,
    CONSTRAINT flight_pilot2_fk FOREIGN KEY (pilot2) REFERENCES pilot(employee_id) ON DELETE SET NULL,
    PRIMARY KEY (flight_num, airline));
    
# flight attendants on the flight
CREATE TABLE IF NOT EXISTS attendants_on_flight (
	employee_id INT,
    airline_id CHAR(2),
    flight_num INT,
    CONSTRAINT aof_eid_fk FOREIGN KEY (employee_id) REFERENCES flight_attendant(employee_id),
    CONSTRAINT aod_airline_flight_fk FOREIGN KEY (airline_id, flight_num) REFERENCES flight(airline, flight_num),
    PRIMARY KEY (employee_id, airline_id, flight_num));

# passengers
CREATE TABLE IF NOT EXISTS passenger (
	name VARCHAR(50),
    dob DATE,
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    phone CHAR(12));
    
# passengers on the flight
CREATE TABLE IF NOT EXISTS passengers_on_flight (
	passenger_id INT,
    airline CHAR(2),
    flight_num INT,
    CONSTRAINT pof_ssn_fk FOREIGN KEY (passenger_id) REFERENCES passenger(passenger_id) ON UPDATE CASCADE,
    CONSTRAINT pof_airline_fk FOREIGN KEY (airline, flight_num) REFERENCES flight(airline, flight_num));
	
