class Request

  attr_reader :request_hash, :formatted_diagnostic

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
    format_request
  end

  def format_request
    @formatted_diagnostic = "Verb: #{@request_hash["Verb"]}\n"\
    "Path: #{@request_hash["Path"]}\n"\
    "Protocol: #{@request_hash["Protocol"]}\n"\
    "Host: #{@request_hash["Host"]}\n"\
    "Port: #{@request_hash["Port"]}\n"\
    "Origin: #{@request_hash["Host"]}\n"\
    "Accept: #{@request_hash["Accept"]}\n"
  end

end
