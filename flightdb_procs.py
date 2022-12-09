import re
from prettytable import PrettyTable, from_db_cursor

def addAircraft(cursor):
    cursor.execute('SELECT name FROM manufacturer')
    manufacturers = []
    for row in cursor.fetchall():
        manufacturers.append(row[0])

    cursor.execute('SELECT aircraft_model FROM aircraft')
    models = []
    for row in cursor.fetchall():
        models.append(row[0])

    print(models, manufacturers)

    good_input = False

    while not good_input:
        good_input = True

        manu = input('Enter manufacturer name: ').upper()
        model = input('Enter model name: ').upper()
        try: 
            seats = int(input('Enter number of seats: '))
            range = int(input('Enter flight range (in naut miles): '))
        except:
            valid_ints = False
            while not valid_ints:
                try:
                    seats = int(input('Invalid input. Enter number of seats: '))
                    range = int(input('Flight range (in naut miles): '))
                    valid_ints = True
                except:
                    continue
        if manu not in manufacturers:
            good_input = False
            confirm = input('Manufacturer currently does not exist. Would you like to add it? (y/n) ')
            if confirm == 'y':
                cursor.execute(f'INSERT INTO manufacturer VALUES (\'{manu}\')')
                good_input = True
            else:
                continue
        while model in models:
            model = input('Duplicate model name. Enter another model name: ')
    try:
        cursor.execute(f'CALL addAircraft(\'{manu}\', \'{model}\', {seats}, {range})')
        print('Successfully added aircraft.')
    except:
        print('Unexpected error. Returning to main menu...')

    return 

def addAirplane(cursor):
    try:
        good_input = False
        while not good_input:
            good_input = True
            printAirlines(cursor)
            airline = input('Enter owner airline (abbr.): ').upper()
            cursor.execute('SELECT id FROM airline')
            airlines = [i[0] for i in cursor.fetchall()]
            if airline not in airlines:
                good_input = False
            reg_num = input('Enter plane registration #: ')
            while len(reg_num) > 10 or len(reg_num) < 1:
                print('Invalid input. Registration # must be <= 10 characters.')
                reg_num = input('Enter plane registration #: ')
            reg_date = input('Enter registration date (format: yyyy-mm-dd): ')
            model = input('Enter plane model: ').upper()
            cursor.execute('SELECT aircraft_model FROM aircraft')
            models = [i[0] for i in cursor.fetchall()]
            if model not in models:
                good_input = False
            if not good_input:
                print('Invalid input. Please try again.')

        cursor.execute(f'CALL addAirplane(\'{airline}\', \'{reg_num}\', \'{reg_date}\', \'{model}\')')
        print('Successfully added new airplane.')
    except:
        print('Unexpected error. Returning to main menu...')

    return

def addFlight(cursor):
    try: 
        printAirlines(cursor)
        airline = input('Enter airline (abbr.): ')
        printAirports(cursor)
        departure = input('Enter departure airport (abbr.): ')
        arrival = input('Enter destination airport (abbr.): ')
        departure_time = input('Enter departure time (format yyyy-mm-dd hh:mm:ss): ')
        arrival_time = input('Enter arrival time (format yyyy-mm-dd hh:mm:ss): ')
        airplane = int(input('Enter airplane registration #: '))
        pilot1 = int(input('Enter pilot 1 employee ID: '))
        pilot2 = int(input('Enter pilot 2 employee ID: '))

        cursor.execute(f'CALL addFlight(\'{airline}\', \'{departure}\', \'{arrival}\', \'{departure_time}\', \'{arrival_time}\', {airplane}, {pilot1}, {pilot2})')
        print('Successfully added new flight.')

    except:
        print('Unexpected error. Returning to main menu...')
    return

def addPassengerToFlight(cursor):
    try:
        pid = int(input('Enter passenger ID: '))
    except:
        while not isinstance(pid, int):
            try:
                pid = int(input('Invalid id. Enter passenger ID: '))
            except:
                continue
    printAirlines(cursor)
    flightcode = input('Enter airline and flight number (e.g. DL123): ')
    try: 
        airline = flightcode[0:2]
        flightnum = int(flightcode[2:])
    except:
        print('Invalid flight code. Returning to main menu...')

    try:
        cursor.execute(f'CALL addPassengerToFlight({pid}, \'{airline}\', \'{flightnum}\')')
    except:
        print('Unexpected error. Returning to main menu...')

    return

def addPassenger(cursor):
    name = input('Enter first and last name: ').title()
    dob = input('Enter DOB (format: yyyy-mm-dd): ')
    phone = input('Enter phone # (format: ##########): ')
    try:
        cursor.execute(f'CALL addPassenger(\'{name}\', \'{dob}\', {phone})')
        print('Successfully added new passenger.')
    except:
        print('Input error. Returning to main menu...')
    return

def cancelFlight(cursor):
    flightcode = input('Enter airline and flight number (e.g. DL123): ').upper()
    try: 
        airline = flightcode[0:2]
        flightnum = int(flightcode[2:])
    except:
        print('Invalid flight code. Returning to main menu...')

    if not verifyFlight(cursor, airline, flightnum):
        print('Invalid flight. Returning to main menu...')
        return
    cursor.execute(f'CALL cancelFlight(\'{airline}\', {flightnum})')
    return

def changeArrival(cursor):
    airline = input('Enter airline (airline designation): ').upper()
    flight_num = int(input('Enter flight number: '))
    if not verifyFlight(cursor, airline, flight_num):
        print('Invalid flight. Returning to main menu...')
        return
    arrival = input('Enter arrival time (format: yyyy-mm-dd hh:mm:ss): ')
    pattern = re.compile('[0-9]{4}-[0-9]{2}-[0-9]{2}\s[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]{1,3})?')
    while pattern.match(arrival):
        arrival = input('Invalid input. Enter arrival time (yyyy-mm-dd hh:mm:ss): ')

    cursor.execute(f'CALL changeArrival(\'{airline}\', {flight_num}, \'{arrival}\')')
    return

def changeDeparture(cursor):
    airline = input('Enter airline (airline designation): ').upper()
    flight_num = int(input('Enter flight number: '))
    if not verifyFlight(cursor, airline, flight_num):
        print('Invalid flight. Returning to main menu...')
        return
    departure = input('Enter departure time (format: yyyy-mm-dd hh:mm:ss): ')
    pattern = re.compile('[0-9]{4}-[0-9]{2}-[0-9]{2}\s[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]{1,3})?')
    while pattern.match(departure):
        departure = input('Invalid input. Enter departure time (yyyy-mm-dd hh:mm:ss): ')

    cursor.execute(f'CALL changeDeparture(\'{airline}\', {flight_num}, \'{departure}\')')
    return

def getAirlineFlights(cursor):
    cursor.execute('SELECT name FROM airline')
    airlines = [i[0] for i in cursor.fetchall()]
    
    tab = PrettyTable()
    tab.add_column("Airlines", airlines)
    print(tab)
    airline = input('Enter airline (full name): ')
    airlines = [i.lower() for i in airlines]
    while airline.lower() not in airlines:
        airline = input('Invalid airline name. Enter airline name (see above): ')
    
    cursor.execute('CALL getAirlineFlights(%s)', airline)
    print(from_db_cursor(cursor))

def getAllFlights(cursor):
    cursor.callproc('getAllFlights')
    print(from_db_cursor(cursor))
    return

def getArrivalFlights(cursor):
    cursor.execute('SELECT airport_id, airport_name, zip FROM airport')
    airports = []
    for row in cursor.fetchall():
        airports.append([row[0], row[1], row[2]])

    tab = PrettyTable()
    tab.field_names = ['ID', 'Name', 'ZIP']
    tab.add_rows(airports)
    print(tab)
    airport = input('Enter airport (abbr.): ')
    abbreviations = [i[0] for i in airports]
    while airport.upper() not in abbreviations:
        airport = input('Invalid airport name. Enter airport name (see above): ')
    
    cursor.execute(f'CALL getArrivalFlights(\'{airport}\')')
    print(from_db_cursor(cursor))
    return

def getFlight(cursor):
    printAirlines(cursor)
    flightcode = input('Enter airline and flight number (e.g. DL123): ')
    try: 
        airline = flightcode[0:2]
        flightnum = int(flightcode[2:])
    except:
        print('Invalid flight code. Returning to main menu...')

    cursor.execute(f'CALL getFlight(\'{airline}\', {flightnum})')

    print(from_db_cursor(cursor))
    return

def removeEmployee(cursor):
    try:
        eid = int(input('Enter employee ID: '))
    except:
        while not isinstance(eid, int):
            try:
                eid = int(input('Invalid input. Enter employee ID: '))
            except:
                continue
    
    try:
        cursor.execute(f'CALL removeEmployee({eid})')
    except:
        print('Unexpected error. Returning to main menu...')

    return


def verifyFlight(cursor, airline, flightnum):
    '''
    Verifies that the passed airline/flightnum combination is valid. Returns a boolean.
    '''
    cursor.execute(f'SELECT * FROM flight WHERE airline = \'{airline}\' AND flight_num = {flightnum}')
    cursor.fetchall()
    testList = []
    for row in cursor:
        testList.append(row)

    return True if testList is not None else False


def printAirlines(cursor):
    cursor.execute('SELECT id, name FROM airline')
    print(from_db_cursor(cursor))

def printAirports(cursor):
    cursor.execute('SELECT airport_id, airport_name, ZIP from airport')
    print(from_db_cursor(cursor))
    
    def passengersOnFlight(cursor):
    flightcode = input('Enter airline and flight number (e.g. DL123): ')
    
    try: 
        airline = flightcode[0:2]
        flightnum = int(flightcode[2:])
    except:
        print('Invalid flight code. Returning to main menu...')

    cursor.execute(f'CALL getFlightPassengers(\'{airline}\', \'{flightnum}\')')
    print(from_db_cursor(cursor))
    return

def getPassengerFlights(cursor):
    passenger = input('Enter passenger ID number (e.g. 12): ')

    cursor.execute(f'CALL getPassengerFlights({passenger})')
    print(from_db_cursor(cursor))
    return
