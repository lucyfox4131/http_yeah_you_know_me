class Request

  attr_reader :request_hash

  def parse_request(request_lines)
    verb = request_lines[0].split[0]
    path = request_lines[0].split[1]
    protocol = request_lines[0].split[2]
    host = request_lines[1].split(': ')[1].split(':')[0]
    port = request_lines[1].split(': ')[1].split(':')[1]
    @request_hash = {"Verb" => verb, "Path" => path, "Protocol" => protocol, "Host" => host, "Port" => port}
    request_lines[2...request_lines.length].each do |line|
      new_variable = line.split(': ')
      @request_hash[new_variable[0]] = new_variable[1]
    end
    @request_hash
  end

end
