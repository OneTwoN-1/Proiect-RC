#### **ppm-pulse position modulation(2-ppm-mainly used in adsb)**

&#x20;**assume the bit has a period of Ts**

**if the impulse is transmited in the first half of its period, then its 1, if its the second half, its 0.** 

#### **The adsb out protocol** 

* ###### broadcast protocol;
* ###### 1090MHz-extended squitter; 978MHz-Universal Transceiver(USA),twice a second
* Uses PPM. Rate=1Mbps
* Manchester encoding
* Preamble-8 us preamble consisting of four specific pulses
* Data Structure:
1. 5 biti ce spun receiver ului ce fel de mesaj s a transmis
2. 24 biti- ICAO address;
3. 56 biti-Payload-datele efective. Depinzand de tipul mesajului, poate contine lat/long precise, inaltime, ground speed, heading/
4. 24 biti de paritate-cod detector de erori ce se asigura ca receiver ul nu primeste date corupte din cauza interferentelor.:CRC-cyclic redundancy check-permite si corectarea unui anumit numar de biti courpti:forward err correction

\->112 biti in total

* este tranmsis in pachete
* foloseste canal cu acces multiplu nesincronizat. Signal se transmite orbeste fara detectia purtatoarei
* Transmisiile sunt asincrone, probabilitatea de coliziune creste exponential cu numarul de aeronave din spatiul aerian.->se introduce jittering
* transponderul introduce o intarziere pseudo aleatoare la nivel de ms pt fiecare pachet. Chiar daca e posibil ca pachetele sa se suprapuna la t0, la urmatoarea transmisie, probabilitatea ca ambele sa aleaga exact acelasi offset temporal e practic nula


#### **Receptia de catre satelit**


satelit la orizontul avionului-frecventa creste-Blue Shift

satelit fix deasupra-no deviation

satelit la apus-Red Shift-frecventa scade


deviatia doppler =+-33kHz



se folosesc antene Phased Array(Reteaua Aireon, payloads pe 66 sateliti din iridium NEXT).

Prin phased array, antena satelitului manipuleaza electronic faza semnalelor pentru a crea spot beams. In loc sa asculte o suprafata uriasa, satelitul imparte amprenta geografica in zeci de celule mai mici, izoland semnalele spatial. Proces numit SDMA-reduce rata coliziunilor



Pentru transmitere spre receivere la sol se foloseste cross links(legaturi inter-satelitare)

###### ***Antenele Phased Array***

* un grid din zeci/sute de elemente radiante mai mici, individuale ce folosesc principiul **interferentei undelor**->undele ce vin dintr o anumita directe se aduna constructiv, cele ce vin din alte directii se aduna destructiv->**BEAMFORMING**
* fiecare avion cu fasciculul sau, chiar daca au fost trimise at the same time,on same freq



###### **!!!Definitii pentru unii termeni!!!**

###### **TDMA-Time Division Multiple Acces**

* Axa timpului este impartita in cadre, iar fiecare cadru este impartit in time slots. Un utilizator transmite datele sub forma unui burst la o viteza mare, doar in slotul sau alocat
* Necesita Guard Times intre sloturi si mecanisme de compensare a intarzierii
* permite utilizarea unui singur tx/rx radio care poate comuta rapid  intre rx si tx.


###### **SDMA-Space Division Multiple Acces**

* ortogonalitatea este obtinuta controland directivitatea energiei electromagnetice.
* utilizatorii pot utiliza aceeasi frecventa si acelasi slot de timp, atata timp cat sunt separate unghiular
* retea de antene phased array->beamforming
* se creaza o diagrama de radiatie cu castig maxim pe directia utilizatorului dorit si nuluri adanci pe directia surselor de interferenta
* permite reutilizarea frecventei intr o zona geografica restransa


###### **FDMA-Frequency Division Multiple Acces**

* Utilizatorii sunt ortogonali in domeniul frecventei. Intreaga resursa spectrala disponibila sistemului este divizata in sub-benzi de frecventa disjuncte
* fiecarui utilizator i se aloca o purtatoare dedicata pe care transmite continuu. Semnalul este limitat in banda
* Necesita FTB cu Q >>>

Transponderele ADSB ignora vremea locala. Pentru ca toate avioanele sa aiba acelasi baseline, adsb tranmite altitudinea calculata barometric, necorectata, bazata pe o presiune standard globala (1013.25 hPa). Uneori altitudinea poate aparea negativa, intrucat in ziua respectiva presiunea atmosferica poate fi mai ridicata decat cea standard, astfel senzorul avionului "simte" ca ar fi sub apa la aterizare.(-304 m este de obicei etajul default/minimul necalibrat pentru transponderele Boeing/Airbus).

&#x09;      		  

