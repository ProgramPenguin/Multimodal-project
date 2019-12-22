cd icar
start cmd /c java -cp .;icar-1.2.jar;ivy-java-1.2.17.jar IcarClientIvy dictionnaires/formes_DB.dat
cd ../sra5
start cmd /c sra5 -b 127.255.255.255:2010 -p on
cd ../visionneur_1_2
start cmd /c java -classpath visionneur-1.2.jar;ivy-java-1.2.17.jar fr.irit.diamant.ivy.viewer.Visionneur