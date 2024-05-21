defmodule Friendr.Geolocation do
  # Finds the latitude and longitude coordinates of the given address.
  def find_coordinates(address) do
    uri = "http://dev.virtualearth.net/REST/v1/Locations?q=1#{URI.encode(address)}%&key=#{get_api_key()}"
    response = HTTPoison.get! uri
    matches = Regex.named_captures(~r/coordinates\D+(?<lat>-?\d+.\d+)\D+(?<long>-?\d+.\d+)/, response.body)
    if(matches["lat"] != nil &&  matches["long"] != nil) do
      [{v1, _}, {v2, _}] = [matches["lat"] |> Float.parse, matches["long"] |> Float.parse]
      [v1, v2]
    else
      [nil,nil]
     end
  end

  def distance(origin, destination) do
    [o1, o2] = find_coordinates(origin)
    [d1, d2] = find_coordinates(destination)

    if(o1 && o2 && d1 && d2) do
      uri = "https://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix?origins=#{o1},#{o2}&destinations=#{d1},#{d2}&travelMode=driving&key=#{get_api_key()}"
      response = HTTPoison.get! uri
      distance_match = Regex.named_captures(~r/travelD\D+(?<dist>\d+.\d+)/, response.body)

      if distance_match["dist"] do
        distance_value = distance_match["dist"] |> String.to_float()
        distance_value
      else
        nil
      end
    else
      nil
    end
  end

  # Checks if the address is valid by ensuring it has three components and retrieving coordinates.
  def address_valid(address) do
    [lat,long] = Friendr.Geolocation.find_coordinates(address)
    address_valid = address |> String.split(",") |> length() == 3
    lat != nil && long != nil && address_valid
  end


  # Private function to get the API key.
  defp get_api_key(), do: "AgwdG2GQ2_CXMru8EU90spxdKtPtP6_pWWvczb60UuIbZyFXjlDPn474f768oj0Y"
end
