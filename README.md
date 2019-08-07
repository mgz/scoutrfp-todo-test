### Running locally in Docker:
```
docker build -t scoutrfp-api-test . && \
docker run --name scoutrfp-api-test --rm -p 3000:80 -it -v `pwd`/postgres_data:/var/lib/postgresql scoutrfp-api-test
```
When it's up, open http://localhost:3000 in browser.