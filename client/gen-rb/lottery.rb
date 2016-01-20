#
# Autogenerated by Thrift Compiler (0.9.3)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#

require 'thrift'
require 'lottery_types'

module Lottery
  class Client
    include ::Thrift::Client

    def result(url)
      send_result(url)
      return recv_result()
    end

    def send_result(url)
      send_message('result', Result_args, :url => url)
    end

    def recv_result()
      result = receive_message(Result_result)
      return result.success unless result.success.nil?
      raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'result failed: unknown result')
    end

  end

  class Processor
    include ::Thrift::Processor

    def process_result(seqid, iprot, oprot)
      args = read_args(iprot, Result_args)
      result = Result_result.new()
      result.success = @handler.result(args.url)
      write_result(result, oprot, 'result', seqid)
    end

  end

  # HELPER FUNCTIONS AND STRUCTURES

  class Result_args
    include ::Thrift::Struct, ::Thrift::Struct_Union
    URL = 1

    FIELDS = {
      URL => {:type => ::Thrift::Types::STRING, :name => 'url'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Result_result
    include ::Thrift::Struct, ::Thrift::Struct_Union
    SUCCESS = 0

    FIELDS = {
      SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::MAP, :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::SET, :element => {:type => ::Thrift::Types::STRING}}}}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

end

