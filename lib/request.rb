class Request

  attr_reader :request_hash, :formatted_diagnostic

  def parse_request(request_lines)
    initialize_hash
    parse_first_line(request_lines)
    parse_second_line(request_lines)
    parse_remaining_lines(request_lines)
    format_request
    @request_hash
  end

  def initialize_hash
    @request_hash = {}
  end

  def parse_first_line(request_lines)
    @request_hash["Verb"] = request_lines[0].split[0]
    @request_hash["Path"] = request_lines[0].split[1]
    @request_hash["Protocol"] = request_lines[0].split[2]
  end

  def parse_second_line(request_lines)
    @request_hash["Host"] = request_lines[1].split(': ')[1].split(':')[0]
    @request_hash["Port"] = request_lines[1].split(': ')[1].split(':')[1]
  end
  
  def parse_remaining_lines(request_lines)
    request_lines[2...request_lines.length].each do |line|
      new_variable = line.split(': ')
      @request_hash[new_variable[0]] = new_variable[1]
    end
    @request_hash
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
