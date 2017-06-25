#coding: utf-8

import time
import requests,urllib
from requests.packages.urllib3.exceptions import InsecureRequestWarning
import random
from lxml import etree
from cookielib import CookieJar
import ssl
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import logging
logging.basicConfig(level=logging.INFO,format='%(asctime)s %(message)s',datefmt='[%m%d %H:%M:%S]',filename="addMission.log")
logger = logging.getLogger('stdout')
logger.addHandler(logging.StreamHandler())
logger.setLevel(logging.INFO)


class ownExcept(Exception):
    def __init__(self, msg):
        self.msg = msg
    def __str__(self):
        return repr(self.msg)
       
global _UserAgent

def login(i):
    global _UserAgent
    headers = {
        "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Encoding":"gzip, deflate, sdch, br",
        "Accept-Language":"zh-CN,zh;q=0.8",
        "Host":"hpc.bjtu.edu.cn",
        "User-Agent":_UserAgent
    }
    
    UrlGetJession = "https://hpc.bjtu.edu.cn/static/"
    session = requests.session()
    res = session.get(UrlGetJession,headers=headers,verify=False)
    
    para = {
        'service': 'http://hpc.bjtu.edu.cn:8081/static/'
    }
    paraEncode = urllib.urlencode(para)
    LoginUrl1 = "https://hpc.bjtu.edu.cn/cas/login?{}".format(paraEncode)
    jessionId = res.cookies.items()[0][1]
    headers.update({
        "Content-Type": "application/x-www-form-urlencoded",
        "Referer": "https://hpc.bjtu.edu.cn/cas/login?service=http%3A%2F%2Fhpc.bjtu.edu.cn%3A8081%2Fstatic%2F",
        "Cookie": "JSESSIONID={}".format(jessionId)
    })
    username = ['14121553','8163']
    passwd = ['iv11SM&*','ej62YN^@']
    data = {
        "username":username[i],
        "password":passwd[i],
        "lt":"e1s1",
        "_eventId":"submit",
        "submit":u"登录"
    }
    #dataEncode = urllib.urlencode(data)
    dataEncode = "username=14121553&password=iv11SM%26*&lt=e1s1&_eventId=submit&submit=%E7%99%BB%E5%BD%95"
    LoginUrl2 = 'https://hpc.bjtu.edu.cn/cas/login;jsessionid={}?{}'.format(jessionId,paraEncode)

    res2 = session.post(LoginUrl2,headers=headers,data=dataEncode,verify=False)
    a = session.cookies.values()[1:]
    a.remove(jessionId)
    jession = a[0]
    return jession
    

    
def getNodeNum(jession):
    global _UserAgent
    t = str(time.time()).replace('.','')
    NodeNumUrl = "https://hpc.bjtu.edu.cn/static/dynamic/SiteJob/GetNodeList?_search=false&nd={}&rows=10&page=1&sidx=&sord=asc".format(t)
    
    headers = {
        "Host": "hpc.bjtu.edu.cn",
        "User-Agent": _UserAgent,
        "Accept": "application/xml, text/xml, */*; q=0.01",
        "Accept-Language": "zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3",
        "Accept-Encoding": "gzip, deflate, br",
        "X-Requested-With": "XMLHttpRequest",
        "Referer": "https://hpc.bjtu.edu.cn/static/Cluster_Management.html",
        "Cookie": "sysLang=en; JSESSIONID={}".format(jession),
    }
    
    res = requests.get(NodeNumUrl,headers=headers,verify=False)
    if str(res.status_code).startswith('3'):
        url = res.history[-1].headers['Location']
        if 'login' in url: 
            raise ownExcept("need re-login")
        else:
            yield -1, -1
    logger.info('GetNodeList resp: {}'.format(res.content))
    if 'ticket' in res.content:
        raise ownExcept("need re-login")
    e = etree.HTML(res.content)
    nodes = e.xpath('/html/body/response/nodes//node')
    for node in nodes:
        if not node.xpath('state/text()') == ['free']:
            continue
        properties = node.xpath('properties/text()')[0]
        if 'fat' in properties:
            nodeType = 'fat'
        elif 'matlab' in properties:
            nodeType = 'batch'
        else:
            continue
        np = node.xpath('np/text()')[0]
        usedn = node.xpath('assignedncpus/text()')[0]
        freeNodeNum = int(np) - int(usedn)
        yield freeNodeNum, nodeType
    yield 0, 0
    
def submitJob(jession, jobname, pattern, nodeNum, nodeType):
    global _UserAgent
    Command = "/software/MATLAB/R2014b/bin/matlab -nodisplay -r {} \\".format(jobname)
    url = "https://hpc.bjtu.edu.cn/static/dynamic/SiteJob/SubmitCommonJob"
    
    headers = {
        "Host": "hpc.bjtu.edu.cn",
        "User-Agent": _UserAgent,
        "Accept": "application/xml, text/xml, */*; q=0.01",
        "Accept-Language": "zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3",
        "Accept-Encoding": "gzip, deflate, br",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "X-Requested-With": "XMLHttpRequest",
        "Referer": "https://hpc.bjtu.edu.cn/static/Submit_Job_common.html",
        "Cookie": "sysLang=cn; JSESSIONID={}".format(jession)
    }
    
    data = {
        "UserName": "14121553",
        "JobName": jobname,
        "Queue": nodeType,
        "RemoteScriptFilePath": "",
        "Command": Command,
        "JobParameters": "",
        "WorkDirectory": pattern,
        "NodeCount": "1",
        "SlotPerNode": nodeNum,
        "SlotCount": "",
        "NodeList": "",
        "isNodeExclusive": "yes",
        "TotalMemory": "",
        "MemoryPerSlot": "",
        "Priority": "",
        "EnvironmentVariables": "",
        "StandardOutputFilePath": "",
        "StandardErrorFilePath": "",
        "PrologueScriptFilePath": "",
        "EpilogueScriptFilePath": "",
        "MaxWalltime": "",
        "OtherParameters": "",
        "CopyFilesList": "",
        "DeleteFilesList": "",
        "NeedNotification": "false",
        "JobType": "",
        "Checkpointable": "disabled",
        "CheckpointInterval": "",
        "CheckpointDepth": "",
        "CheckpointDir": ""
    }
    dataEncode = urllib.urlencode(data)
    
    res = requests.post(url, headers=headers, data=dataEncode,verify=False)
    if res.status_code == 200:
        logger.info("add job success\njobname: {}, \npattern: {},\n {}  {}".format(jobname, pattern, nodeNum, nodeType))
        return True
    else:
        wrongContent = res.content
        logger.info("add fail\n" + wrongContent)
        return False
        
def start(jession, jobnamebase, pattern):

    MissionNum = 0
    while MissionNum < 6:
        logger.info("search nodes")
        for freeNodeNum, nodeType in getNodeNum(jession):
            if not freeNodeNum: continue
            if freeNodeNum == -1: break
<<<<<<< HEAD
            if freeNodeNum < 8: continue
=======
            if freeNodeNum < 1: continue
>>>>>>> 45a2274b223ce63fae05ebcdd80b15d43de3e26a
            #jobTotalNodeNum += freeNodeNum
            #logger.info('total node nums: {}'.format(jobTotalNodeNum))
            jobname = jobnamebase.format(freeNodeNum)
            if not submitJob(jession, jobname, pattern, freeNodeNum, nodeType):
                return False
        if freeNodeNum == -1: break
        sleeptime = random.randint(30,120)
        logger.info('pause for {}s'.format(sleeptime))
        time.sleep(sleeptime)
    return False
    
def main():
    jobnamebase = "main_all_best_YaleB_shelter_10_percent_60_{}poolbig"
    pattern = "/home/14121553/workspace/GNMFO17_5_29/YaleB_shelter_10_percent_60_sigma_sqrt10"
    #pattern = "/home/8163/workspace/GNMFO17_5_29/Orl_shelter_40_percent_80_sigma_sqrt10"
    _UserAgents = ["Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:48.0) Gecko/20100101 Firefox/48.0"
        ]
    global _UserAgent
    _UserAgent = random.choice(_UserAgents)
    
    logger.info('Login')
    i = 0
    while i<1:
        jession = login(i)
        try:
            if not start(jession, jobnamebase, pattern):
                i += 1
        except ownExcept, e:
            logging.info('re login')
            time.sleep(30)
        except Exception, e:
            logging.error(str(e))
            break
    logging.info("mission max")
            
if __name__ == '__main__':
    main()