in target:

java -Djarmode=layertools -jar simplecode-0.0.1-SNAPSHOT.jar extract

ls -ltr
drwxr-xr-x@ 2 matthias  staff        64 Dec  1 18:47 snapshot-dependencies
drwxr-xr-x@ 3 matthias  staff        96 Dec  1 18:47 spring-boot-loader
drwxr-xr-x@ 4 matthias  staff       128 Dec  1 18:47 application
drwxr-xr-x@ 3 matthias  staff        96 Dec  1 18:47 dependencies

cp -r target/dependencies/ structure-v23
cp -r target/spring-boot-loader/ structure-v23
cp -r target/snapshot-dependencies/ structure-v23
cp -r target/application/ structure-v23

in structure-v23:

ls -ltr

drwxr-xr-x@ 3 matthias  staff   96 Dec  1 18:57 org
drwxr-xr-x@ 2 matthias  staff   64 Dec  1 18:58 snapshot-dependencies
drwxr-xr-x@ 5 matthias  staff  160 Dec  1 18:59 META-INF
drwxr-xr-x@ 6 matthias  staff  192 Dec  1 18:59 BOOT-INF
-rw-r--r--@ 1 matthias  staff  549 Dec  1 19:18 steps.md
