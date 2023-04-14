import time
import pyperclip
import keyboard
from smartcard.ATR import ATR
from smartcard.System import readers
from smartcard.util import toHexString
import smartcard.Exceptions
from datetime import datetime

#import readers
r = readers()
reader = r[0]

#getuid command in Bytes
COMMAND = [0xFF, 0xCA, 0x00, 0x00, 0x00]

def read_data():
    try:
        dt = datetime.now()

        #connect to reader
        connection = reader.createConnection()
        connection.connect()

        data, sw1, sw2 = connection.transmit(COMMAND)
        uid = (toHexString(data)).replace(' ', '')
        if (sw1, sw2) == (0x90, 0x0):
            success = "Status: The operation completed successfully."
            print (success)
        elif (sw1, sw2) == (0x63, 0x0):
            failed = "Status: The operation failed."
            print (failed, dt)
            with open('nfcreader.log', 'a') as f:
                f.write(failed + dt + '\n')
        return uid
    except smartcard.Exceptions.NoCardException:
        pass


while True:
    try:
        uid = read_data()
        if uid is not None:
            #copy uid
            pyperclip.copy(uid)
            #paste uid
            keyboard.send("ctrl+v")
            time.sleep(2)
            #'empty' clipboard
            pyperclip.copy('')
    except smartcard.Exceptions.NoCardException:
        time.sleep(0.5)
    except smartcard.Exceptions.CardConnectionException:
        pass