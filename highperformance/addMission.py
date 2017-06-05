#coding: utf-8

import time
import requests,urllib
import urllib2
import random
from lxml import etree
from cookielib import CookieJar
import ssl
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

_UserAgents = ["Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36",
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:48.0) Gecko/20100101 Firefox/48.0"
            ]
_UserAgent = random.choice(_UserAgents)
global _UserAgent

class HTTPRedirectHandler(urllib2.HTTPRedirectHandler):

    # Implementation note: To avoid the server sending us into an
    # infinite loop, the request object needs to track what URLs we
    # have already seen.  Do this by adding a handler-specific
    # attribute to the Request object.
    def http_error_302(self, req, fp, code, msg, headers):
        return fp

    http_error_301 = http_error_303 = http_error_307 = http_error_302

class HTTPDefaultErrorHandler(urllib2.BaseHandler):
    def http_error_default(self, req, fp, code, msg, hdrs):
        return fp

def login():
    global _UserAgent
    para = {
        'service': 'http://hpc.bjtu.edu.cn:8081/static/'
    }
    paraEncode = urllib.urlencode(para)
    LoginUrl1 = "https://hpc.bjtu.edu.cn/cas/login?{}".format(paraEncode)
    headers = {
        "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Encoding":"gzip, deflate, sdch, br",
        "Accept-Language":"zh-CN,zh;q=0.8",
        #"Connection":"keep-alive",
        #"DNT":"1",
        "Host":"hpc.bjtu.edu.cn",
        #"Upgrade-Insecure-Requests":"1",
        "User-Agent":_UserAgent
    }
    session = requests.session()
    session.get(LoginUrl1,headers=headers,verify=False)
    jessionId = session.cookies.items()[0][1]
    print jessionId
    #context = ssl._create_unverified_context()
    #ssl._create_default_https_context = ssl._create_unverified_context
    #req = urllib2.Request(LoginUrl.format(paraEncode),headers=headers)
    #res = urllib2.urlopen(req,data=urllib.urlencode(data))
    data = {
        "username":"14121553",
        "password":"iv11SM&*",
        "lt":"e1s1",
        "_eventId":"submit",
        "submit":u"登录"
    }
    #dataEncode = urllib.urlencode(data)
    dataEncode = "username=14121553&password=iv11SM%26*&lt=e1s1&_eventId=submit&submit=%E7%99%BB%E5%BD%95"
    dataUp = "Content-Type: application/x-www-form-urlencoded\nContent-Length: 87\n\n"+dataEncode
    LoginUrl2 = 'https://hpc.bjtu.edu.cn/cas/login;jsessionid={}?{}'.format(jessionId,paraEncode)
    headers.update({
        "Referer": "https://hpc.bjtu.edu.cn/cas/login?service=http%3A%2F%2Fhpc.bjtu.edu.cn%3A8081%2Fstatic%2F",
        "Cookie": "JSESSIONID={}".format(session.cookies.items()[0][1])
    })
    #LoginUrl3 = 'https://hpc.bjtu.edu.cn'
    #httpClient = httplib.HTTPConnection(LoginUrl3,80)
    #httpClient.request("POST", '/cas/login;jsessionid={}?{}'.format(jessionId,paraEncode),dataUp,headers)
    #response = httpClient.getresponse()
    ssl._create_default_https_context = ssl._create_unverified_context
    class RedirectHandler(urllib2.HTTPRedirectHandler):
        def http_error_301(self, req, fp, code, msg, headers):
            pass     
        def http_error_301_302(self, req, fp, code, msg, headers):
            pass
    opener = urllib2.build_opener(HTTPDefaultErrorHandler)
    req = urllib2.Request(LoginUrl2,headers=headers)
    res = opener.open(req,data=dataEncode,timeout=10)
    res = session.post(LoginUrl2,headers=headers,data=dataEncode,verify=False)
    print res.cookies.items()
    return 
    
def getNodeNum(cookiesTuple):
    t = str(time.time()).replace('.','')
    NodeNumUrl = "https://hpc.bjtu.edu.cn/static/dynamic/SiteJob/GetNodeList?_search=false&nd={}&rows=10&page=1&sidx=&sord=asc".format(t)
    
    headers = {
        "Host": "hpc.bjtu.edu.cn",
        "User-Agent": _UserAgent,
        "Accept": "application/xml, text/xml, */*; q=0.01",
        "Accept-Language": "zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3",
        "Accept-Encoding": "gzip, deflate, br",
        "DNT": "1",
        "X-Requested-With": "XMLHttpRequest",
        "Referer": "https://hpc.bjtu.edu.cn/static/Cluster_Management.html",
        "Cookie": "sysLang=en; JSESSIONID={}".format(cookiesTuple[1]),
        "Connection": "keep-alive"
    }