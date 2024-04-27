# Chatting application using Ruby on rails

It allows creating new applications where each application can have multiple chats, and each chat contains multiple messages. 

Table of contents:
* Demo
* Dependencies
* How to run 
* Versions used
* Endpoints
* Models
* Database design 
* Services (job queues, cache servers, search engines, etc.)

### Demo

https://github.com/Loayelshall/chatting_app/assets/11968453/98dac26c-41a9-495e-889c-50c943071f37


### Dependencies
1. Docker
2. Docker Compose

### How to run
1. Clone the repo
2. Run docker-compose using the following command
```
docker-compose up
```

### Versions used
Main framework: Ruby on rails -> v7.1.3
Language: Ruby -> 3.3.0
Containerization: Docker -> v25.0.2
Orchestration: Docker compose -> v2.24.3


### Endpoints
![image](https://github.com/Loayelshall/chatting_app/assets/11968453/9489c00f-bd06-4333-bf8c-32da393529e7)

### Models
![image](https://github.com/Loayelshall/chatting_app/assets/11968453/59b980ad-cb16-4693-afb5-fdb7da1295aa)

### Data flow design
#### I used two data storage solutions in this project: 

1. <b>MySQL</b>: it is used for persistent long term data storage, where all the data eventually is stored, to avoid racing conditions locks are used when updating any of the database content which might increase request latency. So, it needed a faster layer while servicing the requests, for that i used redis as an in memory transient data store.


2. <b>Redis</b>: it is used for temporary short term storage due to its nature as an in-memory data store. it acts as a datastore for Sidekiq jobs (messaging queue) until they get executed without affecting requests latency. it was used also as a data store for keeping track of the next available numbers to be used in chats and messages creation.

### Services

1. Elasticsearch and Searchkick: for searching through messages content
2. Sidekiq: for queuing and executing jobs
3. MySQL
4. Redis
5. Redlock: for handling redis mutex locks

    
