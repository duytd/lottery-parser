import sys, glob
sys.path.append('gen-py')
sys.path.insert(0, glob.glob('py/build/lib*')[0])

from lottery import Lottery
from lottery.ttypes import *
from thrift.transport import TSocket
from thrift.transport import TTransport
from thrift.protocol import TBinaryProtocol
from thrift.server import TServer

from sets import Set
from bs4 import BeautifulSoup
import urllib
from urllib import FancyURLopener

class LotterOpener(FancyURLopener):
  # Preventing permission denied error from CloudFare
  version = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; it; rv:1.8.1.11) Gecko/20071127 Firefox/2.0.0.11'

class LotteryHandler:
  def result(self, url):
    try:
      lottery_result = []
      lottery_opener = LotterOpener()
      r = lottery_opener.open(url).read()
      soup = BeautifulSoup(r)
      container = soup.find('div', id='ketqua')
      table = container.find('tbody')

      for row in table.find_all('tr'):
        prize = row.find('h3')
        number_set = Set([])

        if prize is not None:
          for td in row.find_all('td', class_='f2'):
            number_set.add(str(td.contents[0]))
          result_dict = {'prize': prize.contents[0].encode('utf8', 'replace'), 'numbers': number_set}
          lottery_result.append(result_dict)
        else:
          for td in row.find_all('td', class_='f2'):
            lottery_result[-1]['numbers'].add(str(td.contents[0]))

      return lottery_result
    except Exception as e:
      print e

handler = LotteryHandler()
processor = Lottery.Processor(handler)
transport = TSocket.TServerSocket(port=9091)
tfactory = TTransport.TBufferedTransportFactory()
pfactory = TBinaryProtocol.TBinaryProtocolFactory()

server = TServer.TSimpleServer(processor, transport, tfactory, pfactory)

print('Starting the server...')
server.serve()
print('done.')

