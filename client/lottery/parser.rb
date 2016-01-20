$:.push("../gen-rb")
$:.unshift "../rb/lib"

require "thrift"
require "lottery"

module Lottery
  class Parser
    def initialize
      @url = "http://ketqua.net"
    end

    def result
      begin
        port = ARGV[0] || 9091
        transport = Thrift::BufferedTransport.new(Thrift::Socket.new("localhost", 9091))
        protocol = Thrift::BinaryProtocol.new transport
        client = Lottery::Client.new protocol
        transport.open
        lottery_result = client.result @url
        transport.close

        lottery_result.each do |prize|
          puts " #{prize["prize"].to_a.join.encode("UTF-8")} :"
          numbers = prize["numbers"]

          numbers.each_with_index do |number, index|
            print "#{number}"
            print "-" if index < numbers.size - 1
          end

          puts
        end

        lottery_result
      rescue Thrift::Exception => tx
        print "Thrift::Exception: ", tx.message, "\n"
        nil
      end
    end
  end
end
