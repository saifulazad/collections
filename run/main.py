
from flask import Flask

app = Flask(__name__)


@app.route('/')
def hello_world():  # put application's code here
    print("Function call")
    i =1/0
    return {"m":"Abdullah & Mamun vai"}

if __name__ == '__main__':
    app.run()
