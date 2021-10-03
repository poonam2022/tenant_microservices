import requests
from flask import Flask, render_template, request,session
import os
import mysql.connector

app = Flask(__name__)
app.secret_key=os.urandom(24)

ports_map={"flight":"8001", "taxi":"8003", "hotel":"8002", "train":"8001"}

@app.route('/',methods = ['POST','GET'])
def home():
    try:
        return render_template("home.html")
    except Exception as e:
        return(str(e))

#tenant
@app.route('/tenantSignup', methods = ['POST','GET'])
def tenantSignup():
    try:
        return render_template("tenant_signup.html")
    except Exception as e:
        return(str(e))


@app.route('/registerTenant', methods = ['POST', 'GET'])
def registerTenant():
    try:
        mydb = mysql.connector.connect(host="127.0.0.1",
                                user="root",
                                password="root",
                                database="user",
                                auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        if request.method == 'POST':
            name = request.form["name"]
            username = request.form["userId"]
            password = request.form["password"]
            confirmPassword = request.form["cnfpassword"]
            
            service_array=request.form.getlist('service')
            print(name, username, password)
            
            myquery = "select exists(select * from tenant where username=%s)"
            rec_tup = (username,)
            mycursor.execute(myquery, rec_tup)
            if mycursor.fetchone()[0]==1:
                return render_template('Err.html', message="Username already exists")
            elif password!=confirmPassword:
                return render_template('Err.html', message="Passwords Don't Match")
            else:
                mysql_query = "insert into tenant(username,name,password) values(%s, %s, %s)"
                records = ( username, name, password)
                mycursor.execute(mysql_query, records)
                mydb.commit()
                # query="select username from tenant where username=%s"
                # rec_tup=(username,)
                # mycursor.execute(query,rec_tup)
                # tid=mycursor.fetchone()[0]
                for service in service_array:
                    query1="insert into tenant_service(username,service_type) values(%s,%s)"
                    records=(username,service)
                    mycursor.execute(query1,records)
                    mydb.commit()
            return render_template("tenant_login.html")

    except Exception as e:
        return(str(e))

@app.route('/toLogin', methods = ['POST','GET'])
def home3():
    try:
        return render_template("tenant_login.html")
    except Exception as e:
        return(str(e)) 

@app.route('/tenantLogin', methods = ['POST', 'GET'])
def loginTenant():
    try:
        mydb = mysql.connector.connect(host="127.0.0.1",
                                user="root",
                                password="root",
                                database="user",
                                auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        global curr_user
        global curr_user_type
        if request.method == 'POST':
            username = request.form["username"]
            password = request.form["password"]
            
            myquery = "select exists(select * from tenant where username=%s)"
            rec_tup = (username,)
            mycursor.execute(myquery, rec_tup)
        # return render_template("tenant_home.html",user=mycursor.fetchone())

            if mycursor.fetchone()[0]==1:
                new_query = "select password from tenant where username=%s"
                mycursor.execute(new_query, rec_tup)
                if mycursor.fetchone()[0]==password:
                    curr_user = username
                    session['user']=username
                    # query0="select t_id from tenant where userId=%s"
                    # rec_tup=(username,)
                    # mycursor.execute(query0,rec_tup)
                    # tid=mycursor.fetchone()[0]
                    # query="select * from users where t_id=%s"
                    rec_tup=(username,)
                    # mycursor.execute(query,rec_tup)
                    # users=mycursor.fetchall()
                    #services now
                    query2="select service_type from tenant_service where username=%s"
                    mycursor.execute(query2,rec_tup)
                    service_list=mycursor.fetchall()
                    print(service_list)
                    return render_template("tenant_home.html",services_list=service_list)
                else:
                    print("username password wrong")
                    return render_template('Err.html', message="Username/Password Wrong")
            else:
                print("outer error")
                return render_template('Err.html', message="Username/Password Wrong")
    except Exception as e:
        return(str(e))

#user 
@app.route('/userSignup',methods=['GET','POST'])
def user_signup():
    try:
        mydb = mysql.connector.connect(host="127.0.0.1",
                                user="root",
                                password="root",
                                database="user",
                                auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        query="select username, name from tenant"
        mycursor.execute(query)
        tenants=mycursor.fetchall()
        
        return render_template("user_signup.html",len=len(tenants),tenants=tenants)
    except Exception as e:
        return(str(e))

@app.route('/registerUser', methods = ['POST', 'GET'])
def registerUser():
    try:
        mydb = mysql.connector.connect(host="127.0.0.1",
                                user="root",
                                password="root",
                                database="user",
                                auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        if request.method == 'POST':
        # name = request.form["name"]
            username = request.form["username"]
            password = request.form["password"]
            confirmPassword = request.form["cnfpassword"]
            t_username=request.form["t_username"]

            #print(name, username, password)

            myquery = "select exists(select * from users where username=%s)"
            rec_tup = (username,)
            mycursor.execute(myquery, rec_tup)
            if mycursor.fetchone()[0]==1:
                return render_template('Err.html', message="Username already exists")
            elif password!=confirmPassword:
                return render_template('Err.html', message="Passwords Don't Match")
            else:
                mysql_query = "insert into users(username, tenant_username, password) values(%s, %s, %s)"
                records = (username, t_username, password)
                mycursor.execute(mysql_query, records)
                mydb.commit()
            return render_template("user_login.html")
    except Exception as e:
        return(str(e))

@app.route('/userLoginPage',methods=['GET','POST'])
def user_login():
    try:
        return render_template("user_login.html")
    except Exception as e:
        return(str(e))

@app.route('/userLogin', methods = ['POST', 'GET'])
def signIn_user():
    try:
        mydb = mysql.connector.connect(host="127.0.0.1",
                                user="root",
                                password="root",
                                database="user",
                                auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        global curr_user
        global curr_user_type
        if request.method == 'POST':
        
            if 'user' in session:
                    username=session['user']
                    query1="select tenant_username from users where username=%s"
                    rec_tup=(username,)
                    mycursor.execute(query1,rec_tup)
                    t_username=mycursor.fetchone()[0]
                    print(t_username)
                    query2="select service_type from tenant_service where username=%s"
                    rec_tup=(t_username,)
                    mycursor.execute(query2,rec_tup)
                    servicess=mycursor.fetchall()
                    print(servicess)
                    ports_map={"flight":"8001", "taxi":"8003", "hotel":"8002", "train":"8001"}
                    return render_template("user_home.html",user=curr_user,t_username=t_username,services=servicess, ports_map=ports_map)

            username = request.form["username"]
            password = request.form["password"]
            
            myquery = "select exists(select * from users where username=%s)"
            rec_tup = (username,)
            mycursor.execute(myquery, rec_tup)

            if mycursor.fetchone()[0]==1:
                new_query = "select password from users where username=%s"
                mycursor.execute(new_query, rec_tup)
                if mycursor.fetchone()[0]==password:
                    curr_user = username
                    session['user']=username
                    query1="select tenant_username from users where username=%s"
                    rec_tup=(username,)
                    mycursor.execute(query1,rec_tup)
                    t_username=mycursor.fetchone()[0]
                    query2="select service_type from tenant_service where username=%s"
                    rec_tup=(t_username,)
                    mycursor.execute(query2,rec_tup)
                    servicess=mycursor.fetchall()

                    ports_map={"flight":"8001", "taxi":"8003", "hotel":"8002", "train":"8001"}
                    
                    return render_template("user_home.html",user=session['user'],t_username=t_username,services=servicess,ports_map=ports_map)
                else:
                    print("username password wrong")
                    return render_template('Err.html', message="Username/Password Wrong")
            else:
                print("outer error")
                return render_template('Err.html', message="Username/Password Wrong")
    except Exception as e:
        return(str(e))

@app.route('/logout', methods = ['POST', 'GET'])
def logout():
    try:
        session.pop('user',None)
        return render_template('home.html')
    except Exception as e:
        return(str(e))

if __name__ == '__main__':
    app.run(host="localhost", port=8000, debug=True)