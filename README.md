## Sencha Ext JS SDK and Sencha Cmd
Get the image from [Docker Hub](https://hub.docker.com/r/pointw/sencha-extjs/):
```docker pull pointw/sencha-extjs```

This Dockerfile creates an image with everything you need to create Ext JS applications.
* Ext JS SDK (v6.2.0.981 GPL)
* Sencha CMD (v6.5.3.6)

The SDK is installed at **/opt/sencha/sdk**.  
Create your workspace and/or projects in the volume mounted at **/code**.

Running this image in a container:  
```
docker run --rm -it -v /my/project:/code -p 1841:1841 pointw/sencha-extjs
```
.

Create a project
```
sencha generate app -sdk /opt/sencha/sdk -classic MyApp ./MyApp
```
.

Create a workspace then add projects:
```
sencha -sdk /opt/sencha/sdk generate workspace .
sencha generate app -ext MyApp1 ./MyApp1
sencha generate app -ext -classic MyApp2 ./MyApp2
```
.

Run app watch
```
cd MyApp
sencha app watch
```
.

Then you can see the app in your browser with http://localhost:1841  (or http://localhost:1841/MyApp1 if you are using a workspace)
