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
First of all - You need Cassandra. If You don't have working instance already, installation using docker is pretty straightforward.

	docker run -p 9042:9042 -d --name cass1 poklet/cassandra

*Installation from repository only*: to create the image `gaborwnuk/usergrid`, execute the following command on the docker-usergrid folder:

    docker build -t gaborwnuk/usergrid .

To run the image and bind to port :

    docker run -d -p 8080:8080 --link cass1:cassandra gaborwnuk/usergrid


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

In this case, `rGlsLYtiPce2` is the password allocated to the `admin` user for Tomcat admin console.

**Important**: default username and password for usergrid_ is `superuser` and `VDprvB6bt7ebDW`. This can be changed by customising Dockerfile to suit Your needs and add custom `usergrid-*.properties` file. **Without modifications this should not be used on production.**

You can now check usergrid_ status with:

	curl http://127.0.0.1:8080/status
    
Probably the most important value here is:

	"cassandraAvailable" : true
	
If Your value is `false` - usergrid_ won't work as Cassandra instance is required as storage database. Check [docker-cassandra](https://github.com/nicolasff/docker-cassandra).

To fully configure Your Cassandra/usergrid_ , just:

	curl http://superuser:VDprvB6bt7ebDW@127.0.0.1:8080/system/database/setup
	
After few moments You should receive following response:

	{
	  "action" : "cassandra setup",
	  "status" : "ok",
	  "timestamp" : 1409052433807,
	  "duration" : 7442
	}

Now You're good to go - create Your account:

	curl -X POST  \
	     -d 'organization=gwp&username=admin&name=Admin&email=admin@example.com&password=password' \
	     http://127.0.0.1:8080/management/organizations
	     
Authenticate and get token:

	curl "http://127.0.0.1:8080/management/token?grant_type=password&username=admin&password=password"
	
You should receive authentication feedback with token used in all following REST requests, ie:

	curl -H "Authorization: Bearer YWMtA6C8Ti0bEeSpsz3neosJlAAAAUg2TNNzocqs39RLNbd_V5gr2jaoUacix0E" \
	     -H "Content-Type: application/json" \
	     -X POST -d '{ "name":"myapp" }' \
	     http://127.0.0.1:8080/management/orgs/gwp/apps

And so on.

From now on, if You're interested on how to secure Your usergrid_ instance, refer to [https://github.com/apache/incubator-usergrid/tree/master/stack](https://github.com/apache/incubator-usergrid/tree/master/stack) and [https://usergrid.incubator.apache.org/docs/](https://usergrid.incubator.apache.org/docs/).
	

Customising usergrid_ docker container
-------------------------------------------------

If you want to use a preset password instead of a random generated one, you can
set the environment variable `TOMCAT_PASS` to your specific password when running the container:

    docker run -d -p 8080:8080 -e TOMCAT_PASS="mypass" gaborwnuk/usergrid

Following environmental variables are available:

* `TOMCAT_PASS` (**Optional**, default: random generated) - Tomcat instance password, use if required. You won't probably need this.