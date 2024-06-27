import os

from dotenv import load_dotenv
from flask import Flask
from sqlalchemy import URL, create_engine, MetaData, inspect

app = Flask(__name__)
load_dotenv(".env")


@app.route('/')
def hello_world():  # put application's code here
    db_credential = URL.create(
        'postgresql+psycopg2',
        username='postgres',
        password=os.environ["PASSWORD"],
        host=os.environ["HOST"],
        database='postgres',
    )
    engine = create_engine(db_credential, connect_args={'connect_timeout': 10})
    metadata = MetaData()
    metadata.reflect(engine)

    insp = inspect(engine)

    return f'Tables: {insp.get_table_names()}'


if __name__ == '__main__':
    app.run()
