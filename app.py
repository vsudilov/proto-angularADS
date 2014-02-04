from flask import Flask, render_template, request, session, send_from_directory
import json
import time
import os

app = Flask(__name__)


@app.route('/',methods=['GET'])
def home():
  return render_template('index.html')


@app.route('/q=<userquery>',methods=['GET'])
def api(userquery):
  data = open('etc/data.json').readlines()
  fakeSearchData = {
    'sudilovsky':data[0],
    'greiner':data[1],
    'savaglio':data[2],
  }
  try:
    #results = fakeSearchData[request.json['UserQuery'].lower()]
    results = fakeSearchData[userquery.lower()]
  except KeyError:
    return "No Results!"
  return results

if __name__ == '__main__':
  app.debug = True
  app.run(host='0.0.0.0')
