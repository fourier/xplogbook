Simple parser of X-Plane 10 logbook files
=========================================
In order to compile one must have OSX, sbcl, quicklisp installed and configured.
Run 
```
make
```
to compile.
Usage: 
```
./xplogbook path-to-logbook
```
where path-to-logbook - path to the logbook file.
For Steam OSX installation typically:
_"/Users/UserName/Library/Application Support/Steam/SteamApps/common/X-Plane 10/Output/logbooks/X-Plane Pilot.txt"_

=Output example
```
Total statistics
=======================
Flight time: 25.4 hours
Night flight time: 2.9 hours
Number of landings: 62

Airplanes used:
Cessna_172SP
F-4
Carenado_C172
Carenado_C172_v10
Car_C152II_v10

Statistics per airplane
=======================

Cessna_172SP
-----------------------
Flight time: 6.1 hours
Night flight time: 1.2 hours
Number of landings: 16

F-4
-----------------------
Flight time: 0.4 hours
Night flight time: 0.0 hours
Number of landings: 2

Carenado_C172
-----------------------
Flight time: 3.1 hours
Night flight time: 0.0 hours
Number of landings: 8

Carenado_C172_v10
-----------------------
Flight time: 8.6 hours
Night flight time: 0.4 hours
Number of landings: 21

Car_C152II_v10
-----------------------
Flight time: 7.2 hours
Night flight time: 1.3 hours
Number of landings: 15
```


