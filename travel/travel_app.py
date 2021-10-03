import requests
from flask import Flask, render_template, request,session
import os
import mysql.connector

app = Flask(__name__)
app.secret_key=os.urandom(24)


@app.route('/checkip')
def checkip():
        f = requests.request('GET', 'http://myip.dnsomatic.com')
        ip = f.text
        return ip


@app.route('/train',methods=['POST','GET'])
def train():
    try:
        mydb = mysql.connector.connect(host="127.0.0.1",
                                user="root",
                                password="root",
                                database="travel",
                                auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        if True:
            query="select * from train"
            mycursor.execute(query)
            trains=mycursor.fetchall()
            return render_template('train.html',trains=trains)
        else:
            return render_template('home.html')
    except Exception as e:
        return(str(e))

@app.route('/book/train/<string:tr_id>',methods=['GET','POST'])
def book_train(tr_id):
    try:
        mydb = mysql.connector.connect(host="127.0.0.1",
                                user="root",
                                password="root",
                                database="travel",
                                auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        if True :
            query="select from_city,to_city,available_seats,price from train where tr_id=%s"
            rec_tup=(tr_id,)
            mycursor.execute(query,rec_tup)
            f=mycursor.fetchone()
            fromCity=f[0]
            toCity=f[1]
            availSeats=f[2]
            #price = f[3]
            if availSeats>0:
                #availSeats=availSeats-1
                #query1="update train set avail_seats=%s where tr_id=%s"
                #rec_tup=(availSeats,trainid)
                #mycursor.execute(query1,rec_tup)
                username = "user1"
                query2="insert into train_bookings(username,tr_id) values (%s,%s)"
                rec_tup=(username,tr_id)
                mycursor.execute(query2,rec_tup)
                mydb.commit()
                query3="select booking_id from train_bookings where username=%s"
                rec_tup1=(username,)
                mycursor.execute(query3,rec_tup1)
                records=mycursor.fetchall()
                length=len(records)
                last_record=records[length-1]
                return render_template('train_confirm.html',id=last_record[0],other=rec_tup)
            else:
                return 'no seats available'
        else:
            return render_template('home.html')

    except Exception as e:
        return(str(e))


@app.route('/flight',methods=['POST','GET'])
def flight():
    try:
        mydb = mysql.connector.connect(host="127.0.0.1",
                                user="root",
                                password="root",
                                database="travel",
                                auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        if True:
            query="select * from flight"
            mycursor.execute(query)
            flights=mycursor.fetchall()
            return render_template('flight.html',flights=flights)
        else:
            return render_template('home.html')
    except Exception as e:
        return(str(e))

@app.route('/book/flight/<string:fl_id>',methods=['GET','POST'])
def book_flight(fl_id):
    try:
        mydb = mysql.connector.connect(host="127.0.0.1",
                                user="root",
                                password="root",
                                database="travel",
                                auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        if True :
            query="select from_city,to_city,available_seats from flight where fl_id=%s"
            rec_tup=(fl_id,)
            mycursor.execute(query,rec_tup)
            f=mycursor.fetchone()
            fromCity=f[0]
            toCity=f[1]
            availSeats=f[2]
            if availSeats>0:
                #availSeats=availSeats-1
                #query1="update flight set avail_seats=%s where fl_id=%s"
                #rec_tup=(availSeats,fl_id)
                #mycursor.execute(query1,rec_tup)
                username = "user1"
                query2="insert into flight_bookings(username,fl_id) values (%s,%s)"
                rec_tup=(username,fl_id)
                mycursor.execute(query2,rec_tup)
                mydb.commit()
                query3="select booking_id from flight_bookings where username=%s"
                rec_tup1=(username,)
                mycursor.execute(query3,rec_tup1)
                records=mycursor.fetchall()
                length=len(records)
                last_record=records[length-1]
                return render_template('flight_confirm.html',id=last_record[0],other=rec_tup)
            else:
                return 'no seats available'
        else:
            return render_template('home.html')

    except Exception as e:
        return(str(e))


if __name__ == '__main__':
    app.run(host="localhost", port=8001, debug=True)