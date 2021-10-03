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

@app.route('/hotel',methods=['POST','GET'])
def hotel():
    try:
        mydb = mysql.connector.connect(host="127.0.0.1",
                                user="root",
                                password="root",
                                database="stay",
                                auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        if True:
            query="select * from hotel"
            mycursor.execute(query)
            hotels=mycursor.fetchall()
            return render_template('hotel.html',hotels=hotels)
        else:
            return render_template('home.html')

    except Exception as e:
        return(str(e))

@app.route('/book/hotel/<string:ht_id>',methods=['GET','POST'])
def book_hotel(ht_id):
    try:
        mydb = mysql.connector.connect(host="127.0.0.1",
                                user="root",
                                password="root",
                                database="stay",
                                auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        if True :
            query="select hotel_name,city,available_rooms,price from hotel where ht_id=%s"
            rec_tup=(ht_id,)
            mycursor.execute(query,rec_tup)
            f=mycursor.fetchone()
            #hotelName=f[0]
            city=f[1]
            availrooms=f[2]
            if availrooms>0:
                #availrooms=availrooms-1
                #query1="update hotel set avail_rooms=%s where ht_id=%s"
                #rec_tup=(availrooms,hotelid)
                #mycursor.execute(query1,rec_tup)
                username = "user1"
                query2="insert into hotel_bookings(username,ht_id) values (%s,%s)"
                rec_tup=(username,ht_id)
                mycursor.execute(query2,rec_tup)
                mydb.commit()
                query3="select booking_id from hotel_bookings where username=%s"
                rec_tup1=(username,)
                mycursor.execute(query3,rec_tup1)
                records=mycursor.fetchall()
                length=len(records)
                last_record=records[length-1]
                return render_template('hotel_confirm.html',id=last_record[0],other=rec_tup)
            else:
                return 'no rooms available'
        else:
            return render_template('home.html')
    except Exception as e:
        return(str(e))

if __name__ == '__main__':
    app.run(host="localhost", port=8002, debug=True)