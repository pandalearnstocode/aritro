---
title: Local development environment with Fast API + SQLModel + SQLite + Alembic
author: Aritra Biswas
date: '2021-10-16'
highlight: true
slug: local-development-environment-with-fast-api-sqlmodel-sqlite-alembic-sync-async-version
categories: []
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2021-10-16T07:04:33+05:30'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

This is important to have a working local development environment for quick prototyping and developing CRUD application using Fast API. Here in this post we are going to explore how we can quickly spin up and a local development environment. Here we are going to use the following tools to develop the REST API endpoints,

* [Fast API](https://fastapi.tiangolo.com/)
* [SQLModel](https://sqlmodel.tiangolo.com/)
* [SQLite](https://www.sqlite.org/index.html)
* [Alembic](https://alembic.sqlalchemy.org/en/latest/)

### Prerequisite:

* [Anaconda](https://www.anaconda.com/)
* [DB browser for SQLite](https://sqlitebrowser.org/)
* curl

### Code repository:

* [Fast API + SQLite + SQLModel + Alembic (Sync version)](https://github.com/pandalearnstocode/fastapi_sqlmodel_sqlite_alembic_sync_template)
* [Fast API + SQLite + SQLModel + Alembic (Async version)](https://github.com/pandalearnstocode/fastapi_sqlmodel_sqlite_alembic_async_template)


### Sample API workflow:

#### Workflow:

* Write database models
* Write database settings
* Write REST API endpoints
* Test APIs
* Setup alembic
* Change database models
* Update APIs
* Run alembic migration
* Test APIs


#### Project structure:

```
.
├── app
│   ├── db.py : All the settings related to DB will be here.
│   ├── __init__.py
│   ├── main.py : All endpoints will be defined here.
│   └── models.py : All the data models will be defined here.
└── database.db : This SQLite DB will be created and data will be stored here.
```

### Step 1: Setup development environment

Create a local development conda environment to run the application from local. Here we are going to use python 3.8. After creating the environment install the required dependencies.

```bash
conda create --name fastapi_sqlmodel python=3.8
conda activate fastapi_sqlmodel
pip install fastapi[all] sqlmodel alembic aiosqlite
```

### Step 2: Create database models in `models.py`

Here we are going to define a database model to store information related to `task name`. Task table is the table which will be updated later with the `task description` information and we will perform a migration to see how the changes are going to be maintained and reflected in the database. 

```python
from sqlmodel import SQLModel, Field

class TaskBase(SQLModel):
    task_name: str

class Task(TaskBase, table=True):
    id: int = Field(default=None, primary_key=True)

class TaskCreate(TaskBase):
    pass
```

### Step 3: Create settings related to DB in `db.py`

Here for rapid prototype we are going to use sqlite local db. Which is kind of a standalone file. To view the record in the file we can we use the [DB browser for SQLite](https://sqlitebrowser.org/). After we run the application a a file called `database.db` will be created in the root directory of the project.

#### Sync version:

Here are going to create two functions which will create all the required tables when the FastAPI application starts and will generate a session using which I/O operations will be performed in a DB.

```python
from sqlmodel import Session, SQLModel, create_engine
sqlite_file_name = "database.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"

connect_args = {"check_same_thread": False}
engine = create_engine(sqlite_url, echo=True, connect_args=connect_args)

def create_db_and_tables():
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session
```

#### Async version:

Asyn version of the above defined functions which will be used in `main.py`.

```python
from sqlmodel import SQLModel
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

sqlite_file_name = "database.db"
sqlite_url = f"sqlite+aiosqlite:///{sqlite_file_name}"
engine = create_async_engine(sqlite_url, echo=True, future=True)

async def init_db():
    async with engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.create_all)

async def get_session() -> AsyncSession:
    async_session = sessionmaker(
        engine, class_=AsyncSession, expire_on_commit=False
    )
    async with async_session() as session:
        yield session
```

### Step 4: Define API endpoints in `main.py`

Here we are going to define a POST endpoint using which we can write some task related information in the database. As of now, the request model for this endpoint is `TaskCreate` and in the response this endpoint will return an object of type `Task`.

#### Sync version:

```python
from fastapi import FastAPI, Depends
from sqlmodel import Session
from app.db import create_db_and_tables, get_session
from app.models import Task, TaskCreate

app = FastAPI()

@app.on_event("startup")
def on_startup():
    create_db_and_tables()

@app.get("/ping")
def pong():
    return {"ping": "pong!"}

@app.post("/task/", response_model=Task)
def create_task(task: TaskCreate, session: Session = Depends(get_session)):
    db_task = Task.from_orm(task)
    session.add(db_task)
    session.commit()
    session.refresh(db_task)
    return db_task
```

#### Async version:

```python
from fastapi import FastAPI, Depends
from sqlmodel import Session
from app.db import create_db_and_tables, get_session
from app.models import Task, TaskCreate

app = FastAPI()

@app.on_event("startup")
def on_startup():
    create_db_and_tables()

@app.get("/ping")
def pong():
    return {"ping": "pong!"}

@app.post("/task/", response_model=Task)
def create_task(task: TaskCreate, session: Session = Depends(get_session)):
    db_task = Task.from_orm(task)
    session.add(db_task)
    session.commit()
    session.refresh(db_task)
    return db_task
```

### Step 5: Test API endpoints

Here we are going to test the API endpoints are working fine or not. If we get the expected result from the CURL and can validate the records are being updated in the DB we can expect that the APIs are working fine.

```bash
uvicorn app.main:app --reload
curl -X POST http://127.0.0.1:8000/task/ -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"task_name": "just added task"}'
```

__Note:__

* a `database.db` file will be create in project root directory.
* after making the post call validate the db records are being updated using `DB browser for SQLite`


### Step 6: Setup alembic

#### Step 6a: Generate alembic settings

In this step we are going generate all the settings for alembic migration. This will generate some files and folders in the project root directory.

##### Sync version:

```bash
alembic init alembic
```

##### Async version:

```bash
alembic init -t async alembic
```

#### Step 6b: Update alembic settings

After these files are generated, change the DB url in `alembic.ini`.

##### Sync version:

* replace `sqlalchemy.url = driver://user:pass@localhost/dbname` in `alembic.ini` with `sqlite:///database.db`.

##### Async version:

* replace `sqlalchemy.url = driver://user:pass@localhost/dbname` in `alembic.ini` with `sqlite+aiosqlite:///database.db`.

##### Common changes for Sync & Async version:

* in `alembic/env.py` file add `from sqlmodel import SQLModel` in the import section.
* in `alembic/env.py` file add the following line in import section, `from app.models import Task`.
* in `alembic/env.py` change `target_metadata = None` to `target_metadata = SQLModel.metadata`.
* in `alembic/script.py.mako` add `import sqlmodel` in the import section.

#### Step 6c: Generate alembic migration settings

After making all the changes, make first migration. 

```bash
alembic revision --autogenerate -m "init"
alembic upgrade head
```

### Step 7: Update data models in `models.py`

Now, lets say there is some changes we need to add to our data model. In this case we are just going to add `task_description`. `task_description` will be a optional string column in the `Task` table. After we make the required changes in the `app/models.py` and `app/main.py`, we need to run the migration to add the newly added columns in the DB.


```python
from sqlmodel import SQLModel, Field
from typing import Optional # This is a new add line

class TaskBase(SQLModel):
    task_name: str
    task_description: Optional[str] = None # This is a new add line

class Task(TaskBase, table=True):
    id: int = Field(default=None, primary_key=True)

class TaskCreate(TaskBase):
    pass
```

### Step 8: Update API endpoints in `main.py`

In this case, endpoints remains unchanged but in a realistic scenario endpoints has to be changed to take the new information into account.

### Step 9: Run DB migration

Run the following line to update the database tables.

```bash
alembic revision --autogenerate -m "add description"
alembic upgrade head
```


### Step 10: Test updated API endpoints

As last step, make a call to the API endpoints which will be using the updated table and check if everything is working fine or not.

```bash
uvicorn app.main:app --reload
curl -X POST http://127.0.0.1:8000/task/ -H 'accept: application/json' -H 'Content-Type: application/json' -d '{"task_name": "just added task","task_description":"a newly created task"}'
```
* after making the post call validate the db records are being updated using `DB browser for SQLite`

### Conclusion:

This workflow is quite good when in come to rapid prototyping. One can use this inside a docker container as well but make sure that the volume mounting is in place to keep the standalone database file and the other related alembic migration scripts.

### Reference:

* [FastAPI with Async SQLAlchemy, SQLModel, and Alembic](https://testdriven.io/blog/fastapi-sqlmodel/)
* [Async SQL (Relational) Databases](https://fastapi.tiangolo.com/advanced/async-sql-databases/)
* [FastAPI + SQLModel + Alembic](https://github.com/testdrivenio/fastapi-sqlmodel-alembic)
* [SQL (Relational) Databases](https://fastapi.tiangolo.com/tutorial/sql-databases/)
* [Building a Phone Directory with Python, MySQL, FastAPI, and Angular](https://python.plainenglish.io/building-a-phone-directory-with-mysql-fastapi-and-angular-cd48673904f4)
* [Alembic: Auto Generating Migrations](https://alembic.sqlalchemy.org/en/latest/autogenerate.html)
* [Build an async python service with FastAPI & SQLAlchemy](https://towardsdatascience.com/build-an-async-python-service-with-fastapi-sqlalchemy-196d8792fa08)
* [How to set up FastAPI, Ormar, and Alembic](https://hackernoon.com/how-to-set-up-fastapi-ormar-and-alembic)
* [tiangolo/uvicorn-gunicorn-fastapi-docker](https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker)