require "json"
require "open-uri"
require 'soda'
require 'rest_client'



time = Time.new

yyyy = time.strftime("%Y")
mm = time.strftime("%m")
mm = mm.to_i
mm = mm - 2
if mm <= 0
yyyy = yyyy.to_i-1
yyyy = yyyy.to_s
mm = mm.to_i + 12
end
mm = mm.to_s
yyyy = yyyy.to_s

puts "YYYY:  "
puts yyyy
puts "mm:  "
puts mm

client = SODA::Client.new({:domain => "XXXX", :username => "XXXX", :password => "XXXX", :app_token => "XXXX"})


u=["electricity","gas"]

@rows =[]

u.each do |uu|

  y = open("XXXX"+uu+"", "Content-Type" => "text/json")

  x = open("XXXX"+uu+"&startDate="+yyyy+"-"+mm+"-01&numberOfMonths=1","Content-Type" => "text/json")


  sites = JSON.parse(y.read)
  readings =JSON.parse( x.read)

  sites["Response"].each do |l|

    readings["Response"].each do |m|


      if l["Id"] == m["DataSetId"]


        @rows << [l["Location"],l["Utility"],m["Consumption"],l["Units"],m["StartDate"][0..3],m["StartDate"][5..6]]


      end

    end

  end

end

puts @rows


@update = []

@rows.each do |x|

     @update << {
    "Location" => x[0],
    "Utility" => x[1],
    "Consumption" => x[2],
    "Units" => x[3],
    "Year" => x[4],
    "Month" => x[5]
    }
end

@response = client.post("XXXX-XXXX", @update)

#USE WITH EXTREME CARE THIS CLEARS DATASET
#@response = client.put("ak9k-3z8a",{})
