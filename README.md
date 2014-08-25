docker-usergrid
===================
Base docker image to run a Apache usergrid_ BaaS.

Used elements of [tutum-docker-tomcat](https://github.com/tutumcloud/tutum-docker-tomcat) as Tomcat build manifest.


Image tags
----------
```
    gaborwnuk/usergrid:latest
```


Usage
-----

To create the image `gaborwnuk/usergrid`, execute the following command on the docker-usergrid folder:

    docker build -t gaborwnuk/usergrid .

To run the image and bind to port :

    docker run -e CASSANDRA_HOST=127.0.0.1:8080 -d -p 8080:8080 gaborwnuk/usergrid


The first time that you run your container, a new user `admin` with all privileges 
will be created in Tomcat with a random password. To get the password, check the logs
of the container by running:

    docker logs <CONTAINER_ID>

You will see an output like the following:

	=> Creating and admin user with a random password in Tomcat ...
	=> Done!
	=> Creating Apache usergrid_ properties ...
	=> Done!
	========================================================================
	You can now configure to this Tomcat server using:
	
	    admin:rGlsLYtiPce2
	
	Your Cassandra host is:
	    127.0.0.1:8080
	
	Your Apache usergrid_ superuser credentials are:
	
	    superuser:IK7o8Pw8uYJf
	
	========================================================================

In this case, `rGlsLYtiPce2` is the password allocated to the `admin` user for Tomcat admin console, and `IK7o8Pw8uYJf` is the password for `superuser` account of usergrid_ service. You can define Your non-random, specific properties using `-e` flag, as described later in this document.

You can now check usergrid_ status with:

	curl http://127.0.0.1:8080/status
    
Probably the most important value here is:

	"cassandraAvailable" : true
	
If Your value is `false` - usergrid_ won't work as Cassandra instance is required as storage database. Check [docker-cassandra](https://github.com/nicolasff/docker-cassandra).


Customising usergrid_ docker container
-------------------------------------------------

If you want to use a preset password instead of a random generated one, you can
set the environment variable `TOMCAT_PASS` to your specific password when running the container:

    docker run -d -p 8080:8080 -e TOMCAT_PASS="mypass" gaborwnuk/usergrid

Following environmental variables are available:

* `TOMCAT_PASS` (**Optional**, default: random generated) - Tomcat instance password, use if required. You won't probably need this.
* `CASSANDRA_HOST` (**Required**) - Cassandra database host, use host visible from docker container.
* `UG_USERNAME` (**Optional**, default: superuser) - usergrid_ superuser username.
* `UG_EMAIL` (**Optional**, default: superuser@localhost) - usergrid_ superuser e-mail.
* `UG_PASSWORD` (**Optional**, default: random generated) - usergrid_ superuser username.