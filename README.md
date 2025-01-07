# Tworzenie conda environment
Jeżeli chcesz powtórzyć eksperymenty lokalnie: 

```conda config --add channels conda-forge``` - aby dodać kanal z którego conda będzie pobierać paczki

```conda create --name <env> --file requirements.txt``` - aby utworzyć conda env

# MongoDB with Docker
Pobieranie Docker image z bazą
```bash
docker pull mongo:latest
```

Uruchomienie kontenera z bazą
```bash
docker run -d -p 27017:27017 --name mongo-db mongo:latest
```

W PyCharm dodać connection z MongoDB tak samo jak z Postgresem, tylko że ```Authentication: No auth```
