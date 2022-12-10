'''
CS5200: Final Project
Andrew Moy and Cauviya Selva | 12.08.22
This app connects and utilizes the flight database to allow the user to view, edit, and add/remove values.
Application is accessed and interacted with using the command line interface. 
'''

import pymysql as sql
from flightdb_procs import *

def get_credentials(config):
    '''
    takes input and assigns it appropriately to the config dictionary for server connection.
    input: config dictionary
    output: none, config is edited by reference
    '''
    username = input('Please enter your MySQL username: ') 
    password = input('Please enter your MySQL password: ')
    config['user'] = username
    config['password'] = password
    return

def main_menu(connection, cursor):
    selection = 0
    while not (selection == 'q' or selection == 'Q'):
        print('Please select an operation.')
        print('1) View all flights.\n2) View an airline\'s flights.\n3) View flights arriving at a specific airport.\n4) Search for flight by airline and number.')
        print('5) Add an aircraft model.\n6) Add a commercial airplane.\n7) Add a flight.\n8) Add a passenger.\n9) Add an existing passenger to a flight.\n10) Change flight departure time.')
        print('11) Change flight arrival time.\n12) Cancel (remove) a flight.\n13) Remove an employee. \n14) View all passengers on a flight.\n15) View all flights a specific passenger has been on.\nQ) Quit.')
        selection = input('Please enter a number (or Q to quit): ')
        if selection.lower() == 'q':
            return

        match int(selection):
            case 1:
                getAllFlights(cursor)
            case 2:
                getAirlineFlights(cursor)
            case 3:
                getArrivalFlights(cursor)
            case 4:
                getFlight(cursor)
            case 5:
                addAircraft(cursor)
            case 6:
                addAirplane(cursor)
            case 7:
                addFlight(cursor)
            case 8:
                addPassenger(cursor)
            case 9:
                addPassengerToFlight(cursor)
            case 10:
                changeDeparture(cursor)
            case 11:
                changeArrival(cursor)
            case 12:
                cancelFlight(cursor)
            case 13:
                removeEmployee(cursor)
            case 14: 
                passengersOnFlight(cursor)
            case 15:
                getPassengerFlights(cursor)
            case _:
                print('Invalid selection. Please try again.\n')
        cont = input('Press enter to continue.')
        connection.commit()

    return



def main(config):
    '''
    The main function of the program. Handles the meat of the program, including the input loops for user interaction.
    input: config file for database connection
    output: none
    '''
    get_credentials(config)

    try:
        connection = sql.connect(**config)
    except:
        valid_creds = False
        while not valid_creds:
            print('Invalid credentials.')
            get_credentials(config)
            try:
                connection = sql.connect(**config)
                valid_creds = True
            except:
                continue
            

    cursor = connection.cursor()
    print('Credentials validated. Proceeding...')

    main_menu(connection, cursor)

    cursor.fetchall()
    connection.commit()
    connection.close()
    return

if __name__ == '__main__':
    # config variable for initializing the sql cursor. needs user and password to be appended in main before use.
    config = {'host': 'localhost',
              'port': 3306,
              'database': 'flight_db',
              'charset': 'utf8',
              'use_unicode': True,
              'cursorclass': sql.cursors.SSCursor}
    main(config)
