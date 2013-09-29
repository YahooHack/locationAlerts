import sys
import pycurl
import json
import StringIO
import urllib
import requests
import os
import subprocess 
import math
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer


class Person(object):
    ticket=None
    latitude=None
    longitute=None

class AlertPlace(object):
    place=None
    latitude=None
    longitude=None 

def GetDistance(la1,lo1,la2,lo2):
	d = abs((la2-la1)+(lo2-lo1))
	#print "Distnace is"+str(d)
	return d


def GetAlerts(latitude,longitude):
	r = requests.get('http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20rss%20where%20url%3D%27http%3A%2F%2Fnews.yahoo.com%2Frss%2Ftopstories%27&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys')

	my_json= r.text.encode('utf-8')
	news_stream = json.loads(my_json)
	disaster_found = 0

	disasters = ['earthquake','hurricane','explosion','bomb','terror','shooting','killing','crisis','safety','gunmen','kill','shot','Explosion']
	Alert_places_list = []
	Alert_places_lat= []
	Alert_places_lon = []
	Alert_title_list = []
	for i in range(news_stream['query']['count']):
                param = news_stream['query']['results']['item'][i]['title']
                disaster_found = 0
		for j in disasters:
                        if(param.find(j) != -1):
                                disaster_found = 1
                                break
#		print param             
		if disaster_found == 1:
#                        print "Disaster found"
#			print param
                        where = urllib.quote(param.encode('utf-8'))
			url='http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20geo.placemaker%20WHERE%20documentContent%20%3D%20%22'+where+'%22%20AND%0A%20%20%20%20%20%20documentType%3D%22text%2Fplain%22&format=json&diagnostics=true&callback='
			r1 = requests.get(url)
#                        print r1.status_code
			my_json_place_obj =  r1.text.encode('utf-8')
                        my_json_place = json.loads(my_json_place_obj)
			if my_json_place['query']['results']['matches']:
                                if my_json_place['query']['results']['matches']['match'].get(0):
                                        print "Json Error"
#                                        print my_json_place['query']['results']['matches']['match'][0]['place']['name']
                                else:
#                                        print my_json_place['query']['results']['matches']['match']['place']['name']
					
					Alert_places_list.append(my_json_place['query']['results']['matches']['match']['place']['name'])
				        Alert_places_lat.append(my_json_place['query']['results']['matches']['match']['place']['centroid']['latitude'])
					Alert_places_lon.append(my_json_place['query']['results']['matches']['match']['place']['centroid']['longitude'])
                             		Alert_title_list.append(news_stream['query']['results']['item'][i]['title'])           



        for k in range(len(Alert_places_list)):
		d = GetDistance(latitude,longitude,float(Alert_places_lat[k]),float(Alert_places_lon[k]))
		if(d<150):
			print "Send alert to people in "+ Alert_places_list[k]
#	                print "Send alert to people in lat"+Alert_places_lat[k]
#        	        print "Send alert to people in lon"+Alert_places_lon[k]
                	print "Message Sent: "+Alert_title_list[k]

			


	return;


#Create custom HTTPRequestHandler class
class KodeFunHTTPRequestHandler(BaseHTTPRequestHandler):
    
    #handle GET command
    def do_GET(self):
   	print "Inside DoGet"     


    
def run():
#    print('http server is starting...')

    #ip and port of servr
    #by default http server port is 80
    server_address = ('localhost', 8088)
    httpd = HTTPServer(server_address, KodeFunHTTPRequestHandler)
#    print('http server is running...')
    httpd.serve_forever()
    
if __name__ == '__main__':
	Person.ticket="DIHKDHKHDK"
	Person.latitude=37.2719
	Person.longitude=-119.27
	GetAlerts(Person.latitude,Person.longitude)
	run()
