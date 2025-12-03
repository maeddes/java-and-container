in target:

java -Djarmode=tools -jar simplecode-0.0.1-SNAPSHOT.jar extract --layers --destination extracted

ls -ltr extracted/
drwxr-xr-x@ 2 matthias  staff  64 Dec  1 19:32 spring-boot-loader
drwxr-xr-x@ 2 matthias  staff  64 Dec  1 19:32 snapshot-dependencies
drwxr-xr-x@ 3 matthias  staff  96 Dec  1 19:32 dependencies
drwxr-xr-x@ 3 matthias  staff  96 Dec  1 19:32 application

cp -r extracted/dependencies/ ../structure-v33
cp -r extracted/spring-boot-loader/ ../structure-v33
cp -r extracted/snapshot-dependencies/ ../structure-v33
cp -r extracted/application/ ../structure-v33

in structure-v33:

ls -ltr

drwxr-xr-x@ 38 matthias  staff  1216 Dec  1 19:37 lib
-rw-r--r--@  1 matthias  staff  4308 Dec  1 19:38 simplecode-0.0.1-SNAPSHOT.jar

plain execution (no fat jar):

java -jar simplecode-0.0.1-SNAPSHOT.jar 


AOT execution:
java -XX:AOTCacheOutput=app.aot -Dspring.context.exit=onRefresh -jar simplecode-0.0.1-SNAPSHOT.jar
java -XX:AOTCache=app.aot -jar simplecode-0.0.1-SNAPSHOT.jar

CDS execution:
java -XX:ArchiveClassesAtExit=application.jsa -Dspring.context.exit=onRefresh -jar simplecode-0.0.1-SNAPSHOT.jar
java -XX:SharedArchiveFile=application.jsa -jar simplecode-0.0.1-SNAPSHOT.jar