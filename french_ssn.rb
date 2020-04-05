REGEX_SSN = /^(?<gender>[12])\s(?<birth_year>\d{2})\s(?<birth_month>0[1-9]|1[0-2])\s(?<zip>\d{2})\s(\d{3})\s(\d{3})\s(?<key>\d{2})$/
MONTHS = [nil, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

require 'yaml'

def french_ssn_info(ssn_number)
  return "The number is invalid" if ssn_number == ""

  data = ssn_number.match(REGEX_SSN)
  if data && valid?(ssn_number, data[:key])
    gender = check_gender(data[:gender])
    year = "19#{data[:birth_year]}"
    month = check_month(data[:birth_month])
    department = zipcode(data[:zip])
    return "a #{gender}, born in #{month}, #{year} in #{department}."
  else
    return "The number is invalid"
  end
end

def check_gender(code)
  code == '1' ? 'man' : 'woman'
end

def check_month(code)
  MONTHS[code.to_i]
end

def zipcode(code)
  YAML.load_file('data/french_departments.yml')[code]
end

def valid?(ssn, code)
  valid = ssn.gsub!(" ", "")[0..12].to_i
  (97 - valid % 97) == code.to_i
end

