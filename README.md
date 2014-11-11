DBTCityPlanning
===============

Git vett och etikett
Repo = Repository, där filerna lagras,finns externt alltså github samt lokalt på er dator. Dessa synkas inte automatiskt.
Commit = Är "paketet" med ändringar ni har gjort.
Push = att ni skickar upp eventuella skillnader mellan ert lokala repo och det externa. 


1. Gör alltid en pull request mot repot till den branch ni jobbar i innan ni börjar göra ändringar. Ni vet aldrig om någon har laddat upp något sen ni senast gjorde något.
2. Gör alltid en pull request mot repot innan ni pushar upp er commit, som förra. Någon kan ha pushat något mellan att ni började jobba och att ni ska pusha era ändringar.
3. Pusha bara upp saker som funkar. När ni har något som funkar kan ni pusha upp, inte innan. Nästa person som drar ner från repot ska inte behöva ha ett trasigt program.
4. Påbyggnad från förra punkten. Gör "små" ändringar och pusha sen upp. Skicka inte upp 3 dagar med arbete på en gång, försök om möjligt att dela upp programmet i mindre delar. Allt behöver inte nödvändigtvis användas men det ska inte vara trasigt när det pushas upp.
5. Varje grupp jobbar i egna branches. På detta sätt slipper vi att andra personer måste vänta på att saker fixas i master innan de kan dra ner den senaste eller pusha upp sina commits. Om det går åt helsike på en branch saktar det bara upp arbetet för ett par inte hela gruppen.
6. I master ska det bara vara fungerande kod. Drar man ner master ska det vara den senaste fungerande versionen.
7. När en branch har något färdigt kan den mergas in i master. Lite upp till diskussion när detta är lämpligt men det borde vi kunna ta som en grupp innan vi gör. T.ex. "den här större funktionen är testad och klar innan vi börjar på nästa drar vi in den i master".
