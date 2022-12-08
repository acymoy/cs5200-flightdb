# ------------------- INSERTION OF DATA ------------------------
INSERT INTO manufacturer VALUES ('AIRBUS'), ('BOEING');

INSERT INTO aircraft VALUES ('A220', 'AIRBUS', 141, 3200), ('A320', 'AIRBUS', 206, 4000), ('A330', 'AIRBUS', 287, 8150), 
							('A350', 'AIRBUS', 366, 8400), ('737', 'BOEING', 188, 3825), ('747-8', 'BOEING', 410, 8000),
                            ('777', 'BOEING', 400, 8700), ('787', 'BOEING', 330, 7635);
                            
INSERT INTO airline VALUES ('AS', 'Alaska Airlines'), ('G4', 'Allegiant Air'), ('AA', 'American Airlines'), 
						   ('DL', 'Delta Air Lines'), ('F9', 'Frontier Airlines'), ('HA', 'Hawaiian Airlines'),
                           ('B6', 'JetBlue'), ('WN', 'Southwest Airlines'), ('NK', 'Spirit Airlines'), 
                           ('UA', 'United Airlines');
                           
INSERT INTO airport VALUES ('ATL', 'Hartsfield-Jackson Atlanta International Airport', 30320), ('LAX', 'Los Angeles International Airport', 90045),
						   ('ORD', 'O\'Hare International Airport', 60666), ('DFW', 'Dallas/Fort Worth International Airport', 75261),
                           ('DEN', 'Denver International Airport', 80249), ('JFK', 'John F. Kennedy International Airport', 11430),
                           ('SFO', 'San Francisco International Airport', 94128), ('SEA', 'Seattle-Tacoma International Airport', 98158),
                           ('LAS', 'McCarran International Airport', 89119), ('MCO', 'Orlando International Airport', 32827),
                           ('DCA', 'Ronald Reagan Washington National Airport', 22202);